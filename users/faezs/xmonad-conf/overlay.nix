{ pkgs, ... }:

(self: super:
  let
    xconf = drv: with pkgs.haskell.lib; dontHaddock (dontCheck drv);
  in
  {
    xmonad = xconf (self.callHackage "xmonad" "0.18.0" { });
    xmonad-contrib = xconf (self.callHackage "xmonad-contrib" "0.18.1" { });
    xmonad-extras = xconf (self.callHackage "xmonad-extras" "0.17.2" { });
    extensible-exceptions = xconf (self.callHackage "extensible-exceptions" "0.1.1.4" { });
    alsa-core = xconf (self.callHackage "alsa-core" "0.5.0.1" { });
  }
)
