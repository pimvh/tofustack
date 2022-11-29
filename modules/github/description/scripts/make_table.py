#!/usr/bin/env python3
import argparse
import json
import logging
import sys
from dataclasses import dataclass
from typing import Optional

from tabulate import tabulate

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


@dataclass
class PinnedVersion:
    name: str
    version: str


@dataclass
class GithubRepository:
    description: str
    topics: Optional[list[str]] = None
    is_private: bool = False
    license: Optional[str] = None
    type: Optional[str] = None
    molecule_testing_instances: Optional[dict[str, list[str]]] = None
    pinned_versions: Optional[list[PinnedVersion]] = None


def main():
    """main function to ..."""
    parser = argparse.ArgumentParser()
    parser.add_argument("query", type=argparse.FileType("r"))

    # - means read from stdin
    args = parser.parse_args(["-"])

    if not args.query:
        sys.exit("Please pipe query via stdin")

    query: dict = json.load(args.query)

    github_repositories = json.loads(query["github_repositories"])
    non_default_attributes = json.loads(query["non_default_attributes"])

    repositories_table = []

    #
    #  build repository entries based on the passed JSON
    #
    for repo_name, repo_attributes in github_repositories.items():
        repository_table_entry = {
            "type": repo_attributes.get("type", "unknown"),
            "name": repo_name,
            "description": repo_attributes.get("description"),
        }

        non_default_config = []

        for x in non_default_attributes:
            if repo_attributes.get(x):
                non_default_config.append(x)

        repository_table_entry.update(
            {"non default configuration": ", ".join(list(non_default_config))}
        )
        repositories_table.append(repository_table_entry)

    output = f"\n\nTable of managed repositories:\n{tabulate(repositories_table, headers='keys', tablefmt='github')}"

    print(json.dumps({"table": output}))


if __name__ == "__main__":
    main()
