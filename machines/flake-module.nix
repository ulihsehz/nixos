{ self, inputs, ... }:
{
  flake.nixosModules.default = ../nixosModules/default.nix;
  # https://github.com/clan-lol/clan-core/blob/main/flakeModules/clan.nix
  clan = {
    meta.name = "alice";

    # https://github.com/clan-lol/clan-core/blob/main/lib/build-clan/interface.nix
    directory = self;
    specialArgs = {
      self = self;
      inputs = inputs;
    };
    pkgsForSystem = system: inputs.nixpkgs.legacyPackages.${system};
  };
}

