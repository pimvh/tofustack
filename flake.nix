{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # set of custom packages
      pkgsSet =
        { pkgs }:
        {
          # Custom packages, that can be defined similarly to ones from nixpkgs
          # You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
          terraform-graph-beautifier = pkgs.callPackage ./pkgs/terraform-graph-beautifier { };
        };

    in
    {
      # Your custom packages and modifications, exported as overlays
      overlays = {
        # This one brings our custom packages from the 'pkgs' directory
        additions = final: _prev: pkgsSet { pkgs = final; };

        # This one contains whatever you want to overlay
        # You can change versions, add patches, set compilation flags, anything really.
        # https://nixos.wiki/wiki/Overlays
        modifications = final: prev: {
          # example = prev.example.overrideAttrs (oldAttrs: rec {
          # ...
          # });
        };

        # When applied, the stable nixpkgs set (declared in the flake inputs) will
        # be accessible through 'pkgs.stable'
        stable-packages = final: _prev: {
          stable = import inputs.nixpkgs-stable {
            system = final.system;
            config.allowUnfree = true;
          };
        };
      };

      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgsSet { inherit pkgs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.additions
              self.overlays.modifications
              self.overlays.stable-packages
            ];
          };
        in
        {
          # default target, to run terraform
          default = pkgs.mkShell {
            nativeBuildInputs = [
            ];

            buildInputs = with pkgs; [
              opentofu
              terraform-graph-beautifier # package to generate graphs

              # shell utils
              fish
              just

              ripgrep
              # bws

              graphviz # dot graph
              python311 # Python for modules/github_description
              python311Packages.tabulate
            ];

            shellHook = ''
              alias terraform=tofu
            '';
          };

          # secondary target to encrypt secrets
          encryptSecret = pkgs.mkShell {
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
          };
        }
      );
    };
}
