{ pkgs, ... }:

(self: super:
  let
    xconf = drv: with pkgs.haskell.lib; dontHaddock (dontCheck drv);
  in
  {
    xmonad = xconf (self.callHackage "xmonad" "0.17.0" { });
    xmonad-contrib = xconf (self.callHackage "xmonad-contrib" "0.17.0" { });
    xmonad-extras = xconf (self.callHackage "xmonad-extras" "0.17.0" { });
  }
)