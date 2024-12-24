{ inputs, ... }:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJlt3pHk+Bh/WqId89uritqSHUxkaMe4i7xf27POvaO alice@DESKTOP-G7PM6NU"
  ];
in
{
  users.users = {
    joerg = {
      isNormalUser = true;
      # initialPassword = "123"; # replaced by sops hashedPasswordFile
      home = "/home/joerg";
      extraGroups = [
        "wheel"
      ];
      shell = "/run/current-system/sw/bin/zsh";
      uid = 1000;
      openssh.authorizedKeys.keys = keys;
    };
    root.openssh.authorizedKeys.keys = keys;
  };

  boot.initrd.network.ssh.authorizedKeys = keys;

  security.sudo.wheelNeedsPassword = false;

  imports = [
    ./zsh.nix
    # inputs.clan-core.clanModules.root-password
  ];
}
