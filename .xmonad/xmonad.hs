import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(removeKeys, additionalKeys)
import System.IO

main =
    let dzenArgs = "dzen2 -ta r -bg black -fg white" in
let conf =
            defaultConfig
            { terminal = "xterm -fg White -bg Black"
            , normalBorderColor = "#007f00#"
            , focusedBorderColor = "#00ff00"
            , logHook = fadeInactiveLogHook 0.9
            , manageHook = manageDocks <+> manageHook defaultConfig
            , layoutHook = avoidStruts  $  layoutHook defaultConfig
            , modMask = mod4Mask
            }
            `removeKeys` [(mod4Mask, xK_p)]
            `additionalKeys` [((mod4Mask, xK_p), spawn "dmenu_run")] in
    xmonad =<< statusBar dzenArgs dzenPP (const (mod4Mask, xK_b)) conf
