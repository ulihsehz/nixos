{ pkgs, inputs, ... }:
{
  imports = [
    ./common.nix
    ./modules/atuin-autosync.nix # Magical shell history
    # ./modules/rust.nix
    # ./modules/debugging.nix
    ./modules/default-apps.nix
    #./modules/waybar.nix
  ];

  fonts.fontconfig.enable = true;

  services.mpris-proxy.enable = true; # mpris: Media Player Remote Interfacing Specification
  services.syncthing.enable = true;

  home.packages = with pkgs; [
    league-of-moveable-type # Font Collection by The League of Moveable Type
    dejavu_fonts
    ubuntu_font_family
    unifont # Unicode font for Base Multilingual Plane
    twitter-color-emoji
    # upterm # Secure terminal-session sharing
    # eternal-terminal # remote shell that automatically reconnects without interrupting the session
    # gimp # GNU Image Manipulation Program
    # zed-editor # High-performance, multiplayer code editor from the creators of Atom and Tree-sitter
    # jujutsu # A Git-compatible VCS that is both simple and powerful
    # lazyjj # GUi for `Jujutsu/jj`

    arandr # Simple visual front end for XRandR
    # signal-desktop # Private, simple, and secure messenger
    # inputs.nur-packages.packages.${pkgs.hostPlatform.system}.pandoc-bin # Conversion between documentation formats
    adwaita-icon-theme
    hicolor-icon-theme
    # graphicsmagick # Swiss army knife of image processing
    # aspell # Spell checker for many languages
    # aspellDicts.de
    # aspellDicts.fr
    # aspellDicts.en
    # hunspell # Spell checker
    # hunspellDicts.en-gb-ise
    # dino # Modern XMPP ("Jabber") Chat Client using GTK+/Vala
    foot # Fast, lightweight and minimalistic Wayland terminal emulator
    # screen-message # Displays a short text fullscreen in an X11 window
    # sshfs-fuse # FUSE-based filesystem that allows remote filesystems to be mounted over SSH
    # sshuttle # Transparent proxy server that works as a poor man's VPN
    # git-lfs # Git extension for versioning large files
    # cheat # Create and view interactive cheatsheets on the command-line
    xdg-utils # Set of command line tools that assist applications with a variety of desktop integration tasks
    patool # portable archive file manager, supports 7z, tar, zip, bzip2, gzip, ..., many types
    # tio # a serial device tool to easily connect to serial TTY devices for basic I/O operations
    # shell-gpt

    (mpv.override { scripts = [ mpvScripts.mpris ]; })
    playerctl # Command-line utility and library for controlling media players that implement MPRIS
    # yt-dlp # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    # mumble # Low-latency, high quality voice chat software
    # ferdium # Add all your services in one place for quick and easy access and never search your tabs or bookmarks again
    # kubectl # Kubernetes CLI
    # inkscape # Vector graphics editor

    # q # Tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH
    # rbw # Unofficial command line client for Bitwarden
    # isync # Free IMAP and MailDir mailbox synchronizer
    # to fix xdg-open
    # glib # C library of programming buildings blocks
    # zoom-us # ZOOM, video conferencing application
    # jmtpfs # FUSE filesystem for MTP devices like Android phones
    # (pkgs.runCommand "slack-aliases" { } ''
    #   mkdir -p $out/bin
    #   declare -A rooms=([numtide]=numtide \
    #          ["numtide-labs"]="numtide-labs" \
    #          ["tum"]="ls1-tum" \
    #          ["tum-courses"]="ls1-tum-course")
    #   for name in "''${!rooms[@]}"; do
    #     cat > "$out/bin/slack-''${name}" <<EOF
    #   #!${runtimeShell}
    #   exec chromium --app="https://''${rooms[$name]}.slack.com" "$@"
    #   EOF
    #   done
    #   chmod +x $out/bin/slack-*
    # '')
    (pkgs.writeScriptBin "jellyfinmediaplayer" ''
      # bluetooth speaker
      bluetoothctl connect E6:4D:D6:0A:CC:9B &
      systemd-inhibit \
        --why="Jellyfin Media Player" \
        --who="Jellyfin Media Player" \
        --mode=block \
        ${pkgs.jellyfin-media-player}/bin/jellyfinmediaplayer
    '')
    #(retroarch.override {
    #  cores = [
    #    libretro.bsnes-hd
    #    libretro.mupen64plus
    #    libretro.beetle-psx-hw
    #    libretro.dolphin
    #    #libretro.pcsx2
    #  ];
    #})

    (pkgs.writeScriptBin "rhasspy-play" ''
      #!${pkgs.runtimeShell}
      set -eux -o pipefail
      export PATH=${pkgs.pulseaudioFull}/bin:$PATH
      sink=alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink

      if pamixer --get-mute --sink="$sink"; then
          pamixer --sink=$sink --unmute
          paplay --device=$sink
          pamixer --sink=$sink --mute
      else
          paplay --device=$sink
      fi
    '')

    # nixos-shell # Spawns lightweight nixos vms in a shell
    nerd-fonts.fira-code
    # inxi # a full featured system information script
  ];
}
