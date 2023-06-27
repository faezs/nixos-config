{ pkgs, flakes, ... }:

let
  agda = pkgs.agda.withPackages (p: [
    p.standard-library
    p.agda-categories
    # p.cubical
    # (p.mkDerivation {
    #   pname = "agda-unimath";
    #   version = "1.0.0";
    #   src = flakes.agda-unimath;
    #   meta = {};
    #   preBuild = "make src/everything.lagda.md";
    #   everythingFile = "./src/everything.lagda.md";
    #   libraryFile = "agda-unimath.agda-lib";
    # })
    # (p.mkDerivation {
    #   pname = "hardware";
    #   version = "1.0.0";
    #   src = flakes.denotational-hardware;
    #   meta = {};
    #   libraryFile = "hardware.agda-lib";
    #   buildInputs = [
    #     p.standard-library
    #   ];
    # })
  ]);
in
{
  xdg.enable = true;

  home.packages = [
    pkgs.chromium
    pkgs.glances
    pkgs.ripgrep
    agda
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
    doomPrivateDir = ../../conf/doom.d;
    emacsPackagesOverlay = self: super: {
        copilot = self.trivialBuild {
          pname = "copilot";
          ename = "copilot";
          version = "0.0.0";
	        buildInputs = [ self.s self.dash self.editorconfig self.jsonrpc ];
          src = flakes.copilot-el;
          extraPackages = [ pkgs.nodejs ];
          extraConfig = ''
             (setq copilot-node-executable = "${pkgs.nodejs}/bin/node")
             (setq copilot--base-dir = "${flakes.copilot-el}")
             '';
          installPhase = ''
              runHook preInstall
              LISPDIR=$out/share/emacs/site-lisp
              install -d $LISPDIR
              cp -r * $LISPDIR
              runHook postInstall
              '';

        };
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
    lfs.enable = true;
  };
}
