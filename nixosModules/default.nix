{
  inputs,
  config,
  lib,
  ...
}:
{
  srvos.flake = inputs.self;
  documentation.info.enable = false;
  clan.core.networking.targetHost = lib.mkDefault "root@${config.networking.hostName}.r";

  security.sudo.execWheelOnly = lib.mkForce false;
  programs.nano.enable = false;

  imports = [
    ./nix-path.nix
    ./nix-daemon.nix
    ./i18n.nix
    # ./fhs-compat.nix
    # ./update-prefetch.nix

    inputs.srvos.nixosModules.common
    inputs.srvos.nixosModules.mixins-nix-experimental
    # { networking.firewall.interfaces."tinc.retiolum".allowedTCPPorts = [ 9273 ]; }
    # inputs.srvos.nixosModules.mixins-telegraf
    inputs.srvos.nixosModules.mixins-trusted-nix-caches
  ];
}
