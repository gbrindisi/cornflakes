{
  description = "Collection of apps bundled in Nix derivations";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # You can add any other imported flake module here
      ];

      # Define the supported systems
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      # Per-system configurations
      perSystem = { self', inputs', pkgs, system, lib, ... }: {
        packages = {
          help = pkgs.callPackage ./apps/help.nix { pkgs = pkgs; lib = lib; self = self'; };
          # Define the aider package
          aider = pkgs.callPackage ./apps/aider.nix { pkgs = pkgs; lib = lib;};
        };

        # Define the aider app
        apps = {
          aider = {
            type = "app";
            program = "${self'.packages.aider}/bin/aider";
          };
        };

        # Optional: default package for nix run
        packages.default = self'.packages.help;
      };

      flake = {
        # Other flake-level attributes (e.g., `nixosModules`, `overlays`) can be defined here.
      };
    };
}
