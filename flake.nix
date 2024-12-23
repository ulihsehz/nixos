{
  description = "NixOS Flakes";

  nixConfig = {
    extra-substituters = [ "https://cache.thalheim.io" ];
    extra-trusted-public-keys = [ "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc=" ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        withSystem,
        self,
        config,
        ...
      }:
      {
        imports = [
          ./machines/flake-module.nix
          inputs.clan-core.flakeModules.default
        ];
        systems = [
          "x86_64-linux"
        ];
        debug = true;

        perSystem =
          {
            inputs',
            self',
            lib,
            system,
            ...
          }:
          {
            # make pkgs available to all `perSystem` functions
            _module.args.pkgs = inputs'.nixpkgs.legacyPackages;

            checks =
              let
                machinesPerSystem = {
                  # aarch64-linux = [
                  # ];
                  x86_64-linux = [
                    "turingmachine"
                  ];
                };
                nixosMachines = lib.mapAttrs' (n: lib.nameValuePair "nixos-${n}") (
                  lib.genAttrs (machinesPerSystem.${system} or [ ]) (
                    name: self.nixosConfigurations.${name}.config.system.build.toplevel
                  )
                );

                blacklistPackages = [
                  "install-iso"
                  "nspawn-template"
                  "netboot-pixie-core"
                  "netboot"
                ];
                packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
                  lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages)) self'.packages
                );
                devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
                homeConfigurations = lib.mapAttrs' (
                  name: config: lib.nameValuePair "home-manager-${name}" config.activation-script
                ) (self'.legacyPackages.homeConfigurations or { });
              in
              nixosMachines // packages // devShells // homeConfigurations;
          };
      }
    );

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixpkgs.url = "git+https://github.com/Mic92/nixpkgs?shallow=1";

    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:numtide/srvos/dotfiles";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
}
