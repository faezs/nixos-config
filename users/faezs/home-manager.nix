{ pkgs, flakes, claude-code, ... }:

{
  xdg.enable = true;

  home.packages = [
    pkgs.chromium
    pkgs.glances
    pkgs.ripgrep
    pkgs.agda
    pkgs.wget
    pkgs.curl
    pkgs.dmenu
    pkgs.zathura
    pkgs.cachix
    pkgs.stack
    pkgs.nodejs
    pkgs.ihp-new
    pkgs.nixfmt
    pkgs.xclip
    pkgs.google-cloud-sdk
    pkgs.gh
    pkgs.claude-code
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

  programs.doom-emacs = {
    enable = true;
    doomDir = ../../conf/doom.d;
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
    config = {
      whitelist = {
        prefix = [
	        "$HOME/ee/chopaan"
          "$HOME/jinnah/muqadma"
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
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
    lfs.enable = true;
  };
}
