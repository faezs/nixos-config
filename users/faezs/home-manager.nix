{ config, lib, pkgs, ... }:

{

  xdg.enable = true;

  home.packages = [
    pkgs.firefox
    pkgs.glances
    pkgs.ripgrep
    pkgs.agda
    pkgs.emacs
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "emacs -nw";
    PAGER = "less -FirSwX";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Monaco";
      size = 14;
    };
  };
  
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