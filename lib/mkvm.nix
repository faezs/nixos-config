# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { nixpkgs, home-manager, inputs, system, user, overlays, ...}:

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
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = {
        imports = [
          inputs.nix-doom-emacs.hmModule
          ../users/${user}/home-manager.nix
        ];
      };
    }
    ({ config, lib, ... }: {
      options.home-manager.users = lib.mkOption {
        type = with lib.types; attrsOf (submoduleWith {
          specialArgs = { super = config; inherit inputs; };
        });
      };
    })
  ];

  extraArgs = {
    currentSystem = system;
  };
}
