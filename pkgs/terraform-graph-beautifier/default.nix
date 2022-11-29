{ buildGoModule
, fetchFromGitHub
, lib
,
}:
buildGoModule rec {
  pname = "terraform-graph-beautifier";
  version = "0.3.4";
  vendorHash = "sha256-UZmZ7xCzuq8/B5C4x4Ti7/v1BW1AH4cDxFrORuaIqAY=";

  src = fetchFromGitHub {
    owner = "pcasteran";
    repo = "terraform-graph-beautifier";
    rev = "v${version}";
    hash = "sha256-+IuZOgnxYVR3X7RQbXbrOvfQVJ02+UYedvq+A3WaSS4=";
  };

  meta = {
    description =
      "Command line tool allowing to convert the barely usable output of the terraform graph command to something more meaningful and explanatory.";
    homepage = "https://github.com/pcasteran/terraform-graph-beautifier";
    # license = pkgs.lib.license.apache;
    changelog = "https://github.com/pcasteran/terraform-graph-beautifier/releases/v${version}/";
    maintainers = with lib.maintainers; [ pimvh ];
  };
}
