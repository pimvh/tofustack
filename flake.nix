{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # set of custom packages
      pkgsSet = { pkgs }: {
        # Custom packages, that can be defined similarly to ones from nixpkgs
        # You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
        terraform-graph-beautifier = pkgs.callPackage ./pkgs/terraform-graph-beautifier { };
      };

    in
    {
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs pkgsSet; };

      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgsSet { inherit pkgs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.additions
              self.overlays.modifications
              self.overlays.unstable-packages
            ];
          };
        in
        {
          # default target, to run terraform
          default = pkgs.mkShell ({
            nativeBuildInputs = [
            ];

            buildInputs = with pkgs; [
              unstable.opentofu
              terraform-graph-beautifier # package to generate graphs

              gnumake

              graphviz # dot graph
              # python (for github/github_description)
              python311 # Python for modules/github_description
              python311Packages.tabulate
            ];

            shellHook = ''
              alias terraform=tofu
            '';
          });

          # secondary target to encrypt secrets
          encryptSecret = pkgs.mkShell ({
            nativeBuildInputs = [
            ];

            buildInputs = with pkgs; [
              python311
              python311Packages.pynacl
              python311Packages.pyhcl
            ];

            shellHook = ''
              vim .secret
              if [ ! -f .secret ]; then
                echo "No secret file found!"
                exit 1
              fi
              python3 scripts/encrypt_secret.py --help
            '';
          });
        });
    };
}
