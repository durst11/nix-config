{
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Use stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosConfigurations = {
      jrd-t490 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs-unstable; };
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
