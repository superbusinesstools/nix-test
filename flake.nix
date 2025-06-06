{
  description = "Lightweight NixOS setup with i3, dev tools, and Samba";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/default.nix
          ];
        };
      });
}
