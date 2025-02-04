{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure consistent nixpkgs
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      # inputs.nixpkgs.follows = "nixpkgs"; # Ensure consistent nixpkgs
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic, ghostty, nvf, ... }: {

    packages."x86_64-linux".default =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [./nvf-configuration.nix ];
      }).neovim;

    nixosConfigurations = {
      # Replace "host" with your actual hostname
      jrd-t490 = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./configuration.nix
          nvf.nixosModules.default
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
        ];
      };
    };
  };
}
