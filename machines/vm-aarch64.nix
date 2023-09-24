{ config, pkgs, ... }: {
  imports = [
    ../modules/vmware-guest.nix
    ./vm-shared.nix
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # Disable the default module and import our override. We have
  # customizations to make this work on aarch64.
  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  # Interface is this on M1
  networking.interfaces.ens160.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # This works through our custom module imported above
  virtualisation.vmware.guest.enable = true;

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "ens160";
  };

  networking.bridges.br0.interfaces = [ ];

  networking.interfaces = {
    br0 = {
      ipv4.addresses = [{
        address = "192.168.0.1";
        prefixLength = 24;
      }];
    };
  };

  networking.firewall.extraCommands = ''
    # FORWARD rule for traffic from br0 to ens160
    ${pkgs.iptables}/bin/iptables -A FORWARD -i br0 -o ens160 -j ACCEPT

    # FORWARD rule for established and related traffic from ens160 to br0
    ${pkgs.iptables}/bin/iptables -A FORWARD -i ens160 -o br0 -m state --state ESTABLISHED,RELATED -j ACCEPT
  '';

  networking.firewall.interfaces.br0.trusted = true;

  # Share our host filesystem
  # fileSystems."/host" = {
  #   fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  #   device = ".host:/";
  #   options = [
  #     "umask=22"
  #     "uid=1000"
  #     "gid=1000"
  #     "allow_other"
  #     "auto_unmount"
  #     "defaults"
  #   ];
  # };
}
