import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(removeKeys, additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { terminal = "xterm -fg White -bg Black"
        , normalBorderColor = "#007f00#"
        , focusedBorderColor = "#00ff00"
        , logHook = fadeInactiveLogHook 0.9 >> 
            dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
        , manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , modMask = mod4Mask
        }
        `removeKeys` [(mod4Mask, xK_p)]
        `additionalKeys` [((mod4Mask, xK_p), spawn "dmenu_run")]

