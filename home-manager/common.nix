{
  pkgs,
  config,
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [
    ./modules/neovim
    ./modules/tmux-thumbs.nix
  ];

  # nix.package = inputs.nix.packages.${pkgs.hostPlatform.system}.nix;

  home.packages =
    with pkgs;
    [
      # inputs.nix.packages.${pkgs.hostPlatform.system}.nix
      # nixpkgs-review # Review pull-requests on https://github.com/NixOS/nixpkgs
      # nix-prefetch # Prefetch any fetcher function call, e.g. package sources
      (pkgs.callPackage ./pkgs/atuin { })
      # mergiraf #  solve a wide range of Git merge conflicts

      hexyl # Command-line hex viewer
      binutils
      ouch # Command-line utility for easily compressing and decompressing files and directories

      du-dust #  A more intuitive version of du in rust

      procs
      xcp # An extended cp

      socat # Utility for bidirectional data transfer between two independent data channels
      tmux
      # nurl # Command-line tool to generate Nix fetcher calls from repository URLs
      htop
      # hub # Command-line wrapper for git that makes you better at GitHub
      # tea # Gitea official CLI client
      # gh # GitHub CLI tool
      # hyperfine # Command-line benchmarking tool
      jq # Lightweight and flexible command-line JSON processor
      # yq-go # Portable command-line YAML processor
      # tig # Text-mode interface for git
      # lazygit
      git-absorb # git commit --fixup, but automatic
      delta
      scc # Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
      direnv
      nix-direnv # Fast, persistent use_nix implementation for direnv
      fzf
      lsd # Next gen ls command
      zoxide
      pinentry-curses # GnuPG’s interface to passphrase input
      fd
      bat
      moar # Nice-to-use pager for humans
      vivid # Generator for LS_COLORS with support for multiple color themes
      ripgrep
      less
      bashInteractive
      gnused # GNU sed, a batch stream editor
      gnugrep # GNU implementation of the Unix grep command
      findutils
      ncurses # Free software emulation of curses in SVR4 and more
      coreutils
      git

      # self.packages.${pkgs.stdenv.hostPlatform.system}.mergify-gen-config
      # self.packages.${pkgs.stdenv.hostPlatform.system}.merge-when-green
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      strace
      psmisc
      glibcLocales
      gdb
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ darwin.iproute2mac ]
    ++ lib.optional (pkgs.hostPlatform.system != "riscv64-linux") nix-output-monitor;

  home.enableNixpkgsReleaseCheck = false;

  # better eval time
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  home.stateVersion = "24.11";
  home.username = lib.mkDefault "joerg";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
  programs.home-manager.enable = true;
}
