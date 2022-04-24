{ config, lib, pkgs, ... }:

let
  agda = pkgs.agda.withPackages (p: [ p.standard-library ]);
in

{ xdg.enable = true;

  home.packages = [
    pkgs.emacs
    pkgs.firefox
    pkgs.glances
    pkgs.ripgrep
    agda
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "emacs -nw";
    PAGER = "less -FirSwX";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      # env.TERM = "xterm-256color";
      key_bindings = [
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
      ];
    };
  };
  programs.kitty = {
    enable = true;
    font = {
      name = "Monaco";
      size = 14;
    };
  };

  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./config/doom.d;
  # };
  
  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        prefix = [
	  "$HOME/platonic/snoiks"
	  "$HOME/ee/chopaan"
	];
	exact = ["$HOME/.envrc"];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Faez Shakil";
    userEmail = "faez.shakil@gmail.com";
    extraConfig = {
      color.ui = true;
      github.user = "faezs";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };
}
