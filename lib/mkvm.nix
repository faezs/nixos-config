# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { nixpkgs, home-manager, inputs, system, user, overlays, sops-nix, ...}:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    ../hardware/${name}.nix
    ../machines/${name}.nix
    ../users/${user}/nixos.nix
    { environment.etc.age-key = {
        text = "${builtins.readFile ../muqadma-test-public-age-key.txt}";
          target = "/age/age-key";
      };
    }
    inputs.muqadma.nixosModules.muqadma {
        services.muqadma.enable = true;
        services.gcsfuse.enable = nixpkgs.lib.mkForce false;
        services.muqadma.isHttps = nixpkgs.lib.mkForce false;
        services.muqadma.withFuse = nixpkgs.lib.mkForce false;
        services.postgresql.identMap = "qrn faezs muqadma";
        services.postgresql.authentication = "local all muqadma peer  map=qrn";
        services.gotrue.external-url = "http://192.168.18.170/auth/v1";
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
      };
    }

  ];
  extraArgs = { currentSystem = system; };
}
