# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { nixpkgs, home-manager, inputs, system, user, overlays, sops-nix, ...}:

# let p = import inputs.nixpkgs-in { inherit system overlays;
#                          config = { allowUnfree = true;
#                                     allowUnsupportedSystem = true;
#                                   };
#                        };

# in
nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.

    # { nixpkgs.overlays = overlays; }
    ../hardware/${name}.nix
    ../machines/${name}.nix
    ../users/${user}/nixos.nix
    ({ config, ...}: {
      environment.etc.age-key = {
        text = "${builtins.readFile ../muqadma-test-public-age-key.txt}";
        target = "/age/age-key";
      };

      _module.args.pkgs = nixpkgs.lib.mkForce (import nixpkgs { inherit system overlays;
                                                                config = { allowUnfree = true;
                                                                           allowUnsupportedSystem = true;

                                                                         };
                                                              });
      _module.args.system = nixpkgs.lib.mkForce system;
    })
    # ({ config,  ...}: {
    #   services.onlyoffice.enable = nixpkgs.lib.mkForce true;
    #   services.onlyoffice.enableExampleServer = nixpkgs.lib.mkForce true;
    #   services.onlyoffice.examplePort = nixpkgs.lib.mkForce 9999;
    #   services.onlyoffice.port = nixpkgs.lib.mkForce 9998;
    #   services.onlyoffice.jwtSecretFile = config.sops.secrets.jwk-pk.path;
    # })
    #inputs.ghaar.nixosModules.simplex-lan
    inputs.muqadma.nixosModules.muqadma {
        services.muqadma.enable = true;
        services.gcsfuse.enable = nixpkgs.lib.mkForce false;
        services.muqadma.isHttps = nixpkgs.lib.mkForce false;
        services.muqadma.withFuse = nixpkgs.lib.mkForce false;
        services.muqadma.serve-muqadma-port = nixpkgs.lib.mkForce 8088;
        services.postgresql.identMap = ''
        qrn faezs muqadma
        qrn muqadma muqadma
        '';
        services.postgresql.authentication = "local all muqadma peer  map=qrn";
        services.gotrue.external-url = "http://192.168.18.170/";
        services.gotrue.uri-allow-list = "http://localhost*,http://localhost:8088/*";
        _module.args.isTest = nixpkgs.lib.mkForce true;
        _module.args.testCredentials = nixpkgs.lib.mkForce false;
        _module.args.sshKeyPath = nixpkgs.lib.mkForce "/etc/ssh/ssh_host_ed25519_key";
    }
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = {
        imports = [
          inputs.nix-doom-emacs.hmModule
          ../users/${user}/home-manager.nix

        ];
        home.stateVersion = "22.05";
      };
      home-manager.extraSpecialArgs = {
        flakes = inputs;
        inherit system;
        #claude-code = p.claude-code;
      };
    }

  ];
  extraArgs = { currentSystem = system; };
}
