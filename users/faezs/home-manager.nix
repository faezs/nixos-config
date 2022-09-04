{ config, lib, pkgs, ... }:

let
  agda = pkgs.agda.withPackages (p: [
    (p.standard-library.overrideAttrs (oldAttrs: {
      version = "2.0";
      src =  pkgs.fetchFromGitHub {
        repo = "agda-stdlib";
        owner = "agda";
        rev = "6e79234dcd47b7ca1d232b16c9270c33ff42fb84";
        sha256 = "0n1xksqz0d2vxd4l45mxkab2j9hz9g291zgkjl76h5cn0p9wylk3";
      };
    }))
    p.agda-categories
  ]);
in
{ xdg.enable = true;

  home.packages = [
    pkgs.emacs
    pkgs.firefox
    pkgs.glances
    pkgs.ripgrep
    agda
    pkgs.wget
    pkgs.curl
    pkgs.dmenu
    pkgs.zathura
    pkgs.cachix
    pkgs.stack
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "emacs -nw";
    PAGER = "less -FirSwX";
  };

  programs.alacritty = {
    enable = false;
    settings = {
      env.TERM = "xterm-256color";
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
  
  programs.rofi = {
    enable = false;
    terminal = "${pkgs.kitty}/bin/kitty";
  };

  services.polybar = {
    enable = true;
    script = "polybar bar &";
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
    nix-direnv.enableFlakes = true;
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
