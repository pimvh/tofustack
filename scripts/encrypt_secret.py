#!/usr/bin/python3
import argparse
import json
import logging
import os
import subprocess
from base64 import b64encode

import hcl
from nacl import encoding, public

logging.basicConfig(level="INFO")
logger = logging.getLogger()

ENCRYPTED_SECRET_FILE = "secrets.auto.tfvars.json"

def fetch_public_key(owner, repo):

    logging.info('fetching public key for %s/%s...', owner, repo)
    get_public_key = subprocess.run(
        [
            "gh",
            "api",
            "-H",
            "Accept: application/vnd.github+json",
            "-H",
            "X-GitHub-Api-Version: 2022-11-28",
            f"/repos/{owner}/{repo}/actions/secrets/public-key",
        ],
        check=True,
        capture_output=True,
    )

    github_key_json_str = get_public_key.stdout.decode("utf-8").strip()
    public_key = json.loads(github_key_json_str).get("key")

    return public_key


def encrypt(public_key: str, secret_value: str) -> str:
    """Encrypt a Unicode string using the public key."""

    public_key = public.PublicKey(public_key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))

    return b64encode(encrypted).decode("utf-8")


def rotate_secret(args : argparse.Namespace, repo_type : str):
    """

    Rotates the secret for a given type of repository

    Args:
        args: arguments passed down from argeparse
        repo_type: the type of repositories to retrieve
    """
    logging.info('reading secret...')
    with open(".secret") as fp:
        secret: str = fp.read().strip()

    logging.info('reading terraform.tfvars...')
    with open('terraform.tfvars', 'r') as fp:
        open_tofu_vars = hcl.load(fp)

    repos: list[str] = [repo_name for repo_name, repo_attrs in open_tofu_vars['github_repositories'].items() if repo_attrs.get('type') == repo_type]

    if os.path.isfile(ENCRYPTED_SECRET_FILE):
        with open(ENCRYPTED_SECRET_FILE) as fp:
            secrets: dict = json.load(fp).get("secrets")
    else:
        secrets: dict = {}

    for repo in repos:
        if not secrets.get(repo):
            secrets[repo] = {}

        secrets[repo][args.rotate.replace('-', '_')] = encrypt(fetch_public_key(args.owner, repo), secret)


    logging.info('dumping secrets result file...')
    with open(ENCRYPTED_SECRET_FILE, "w+") as fp:
        json.dump({"secrets": secrets} , fp, indent='  ')


def main():
    """main function to encrypt/rotate secrets with the correct Github public key, dumping them into the secrets.auto.tfvars.json file"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--owner", help="owner of the github repository", default="pimvh"
    )

    parser.add_argument("rotate", choices=["ansible-galaxy-api-key", "pypi-api-token", "quay-login-password"], help="which secret to rotate")
    parser.add_argument(
        "--do-not-remove", help="flag to explicitly not remove the secret file", default=False, action="store_true"
    )

    args = parser.parse_args()

    match args.rotate:
        case "ansible-galaxy-api-key":
            rotate_secret(args, "ansible-role")

        case "pypi-api-token":
            rotate_secret(args, "python-package")

        case "quay-login-password":
            rotate_secret(args, "molecule-images")

    if not args.do_not_remove:
        logging.info('removing file with secret...')
        os.remove(".secret")

if __name__ == "__main__":
    main()
