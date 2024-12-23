{ self, inputs, ... }:
{
 flake.nixosModules.default = ../nixosModules/default.nix;
  clan = {
    meta.name = "alice";

    directory = self;
    specialArgs = {
      self = self;
      inputs = inputs;
    };
    pkgsForSystem = system: inputs.nixpkgs.legacyPackages.${system};
  };
}

