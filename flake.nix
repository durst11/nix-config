{
  inputs = {
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic, ghostty }: {
    nixosConfigurations.jrd-t490 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
          environment.systemPackages = [
            ghostty.packages.x86_64-linux.default
          ];
        }
        nixos-cosmic.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
