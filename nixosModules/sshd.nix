{lib, ...}:
{
  systemd.services.openssh = {
    before = [ "boot-complete.target" ];
    wantedBy = [ "boot-complete.target" ];
    unitConfig.FailureAction = "reboot";
  };

  services.openssh = {
    enable = true;
    ports = [222];
  };
}
