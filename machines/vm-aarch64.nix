{ config, pkgs, ... }: {
  imports = [
    ../modules/vmware-guest.nix
    ./vm-shared.nix
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;


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

  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp/nix-daemon";


  #networking.firewall.enable = true;
  #networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.extraCommands = ''
  #   iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.233.1.2:80
  #   iptables -t nat -A POSTROUTING -d 10.233.1.2 -p tcp -m tcp --dport 80 -j MASQUERADE
  #   iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 10.233.1.2:443
  #   iptables -t nat -A POSTROUTING -d 10.233.1.2 -p tcp -m tcp --dport 443 -j MASQUERADE


  # networking.bridges.br0.interfaces = [ "ens160" ];

  # networking.interfaces = {

  #   br0 = {
  #     ipv4.addresses = [{
  #       address = "168.152.0.1";
  #       prefixLength = 24;
  #     }];
  #   };
  # };


  # networking.firewall.interfaces.br0.trusted = true;

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
