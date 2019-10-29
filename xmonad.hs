-- AngusP's XMonad Config

import System.IO
import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.MouseGestures
import XMonad.Actions.SpawnOn
import XMonad.Actions.Warp
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Script
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.MultiToggle
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- import Data.String.Utils


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "/usr/bin/gnome-terminal"

scratchpads = [
  NS "term" "gnome-terminal --role=scratchpad" (role =? "scratchpad") (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6)),
  NS "spotify" "spotify" (className =? "Spotify") (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6))]
  where
    role = stringProperty "WM_WINDOW_ROLE"

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = map show [1..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ resource  =? "desktop_window"   --> doIgnore
    --, role =? "xmobar" --> doIgnore
    , name =? "File Operation Progress" --> doFloat
    , role =? "vlc-video"  --> (doF W.focusDown <+> doFullFloat)
    --, role =? "scratchpad" --> doFloat <+> manageScratchPad
      -- Below gets chrome_app_list to properly float
    , role =? "bubble"     --> doFloat
    , role =? "pop-up"     --> doFloat
    , role =? "Spotify"     --> doFloat
    , className =? "feh" --> (doF W.swapDown <+> (doRectFloat $ W.RationalRect 0.6 0.6 0.25 0.3))
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
  where
    role = stringProperty "WM_WINDOW_ROLE"
    name = stringProperty "WM_NAME"

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.1     -- height, 10%
    w = 1       -- width, 100%
    t = 1 - h   -- distance from top edge, 90%
    l = 1 - w   -- distance from left edge, 0%

------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbedBottom shrinkText myTabConfig |||
    -- simpleTabbedBottom |||
    Full |||
    spiral (6/7)) |||
    tabbedBottom shrinkText myTabConfig |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#181818"
myFocusedBorderColor = "#FF8500"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
myTabConfig = defaultTheme {
    activeBorderColor = "#181818",
    activeTextColor = "#FF8500",
    activeColor = "#181818",
    inactiveBorderColor = "#000000",
    inactiveTextColor = "#DDDDDD",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#DDD"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#FF8500"

-- Width of the window border in pixels.
myBorderWidth = 2


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "super key" is usually mod4Mask.
--
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Start EMACS
  , ((modMask, xK_e),
     spawn "code")
    
  -- Start Chrome Browser
  , ((modMask, xK_i),
     spawn "google-chrome")
    
  -- Lock the screen using xscreensaver.
  , ((modMask, xK_x),
    spawn "~/.xmonad/lock.sh")
    -- spawn "xscreensaver-command -lock")


  , ((modMask .|. shiftMask, xK_x),
     spawn "python ~/.xmonad/lockswitch.py")


  -- show/hide scratchpads
  , ((0, xK_F1), namedScratchpadAction scratchpads "term")
  -- show/hide scratchpad
  , ((myModMask, xK_s), namedScratchpadAction scratchpads "spotify")

    
  -- Launch dmenu.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p),
     spawn "yeganesh -x | ${SHELL:-\"/bin/sh\"} &")

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  --, ((modMask .|. shiftMask, xK_p),
  --   spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  --, ((modMask .|. controlMask .|. shiftMask, xK_p),
  --   spawn "screenshot")

  , ((0, xK_Print), spawn "gnome-screenshot -i")

  , ((mod1Mask, xK_space), namedScratchpadAction scratchpads "term")

  -- MonBrightnessUp
  , ((0, 0x1008FF02),
     spawn "xbacklight -inc 10")

  -- MonBrightnessDown 0x1008FF02
  , ((0, 0x1008FF03),
     spawn "xbacklight -dec 5")

  -- Audio mute toggle
  , ((modMask, xK_numbersign ),
     spawn "amixer -q set Master toggle")

  -- Audio Vol+
  , ((modMask, xK_bracketright ),
     spawn "amixer -q set Master 5%+")
    
  -- Audio Vol-
  , ((modMask, xK_bracketleft ),
     spawn "amixer -q set Master 5%-")

  -- Audio mute toggle (media key)
  , ((0, 0x1008FF12),
     spawn "amixer -q set Master toggle")

  -- Audio Vol+ (media key)
  , ((0, 0x1008FF13),
     spawn "amixer -q set Master 5%+")
    
  -- Audio Vol- (media key)
  , ((0, 0x1008FF11),
     spawn "amixer -q set Master 5%-")
    
  -- Audio previous.
  , ((0, 0x1008FF16),
    spawn "dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")

  -- Play/pause.
  , ((0, 0x1008FF14),
    spawn "dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")

  -- Audio next.
  , ((0, 0x1008FF17),
    spawn "dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")

  -- Eject CD tray.
  --, ((0, 0x1008FF2C),
  --   spawn "eject")

  -- Cycle workspaces left and right
  , ((modMask, xK_Right),
     nextWS)

  , ((modMask, xK_Left),
     prevWS)

  -- Move focus to the next window with workspace-like keys
  , ((modMask, xK_Down),
     windows W.focusDown)

  , ((modMask, xK_Tab),
     toggleWS' ["NSP"])

  -- Move focus to the previous window with workspace-like keys
  , ((modMask, xK_Up),
     windows W.focusUp  )
    
  , ((controlMask .|. modMask, xK_Right),
     shiftToNext >> nextWS)

  , ((controlMask .|. modMask, xK_Left),
     shiftToPrev >> prevWS)

  , ((modMask, xK_d ),
     windows copyToAll)

  , ((modMask .|. shiftMask, xK_d ),
     killAllOtherCopies)

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  --, ((mod1Mask, xK_Tab),
  --   windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp)

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster)

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown)

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp)

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     spawn "$HOME/road/VENV/bin/python $HOME/.xmonad/roll-of-a-dice/client.py logout http://wikid.tardis.ed.ac.uk $ROAD_API_KEY&"
     >> io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  -- ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook :: X ()
myStartupHook = do
  setWMName "LG3D"
  spawn "xscreensaver &"
  spawn "pacmd set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo"
  spawn "feh --bg-fill $HOME/.wall&"
  -- spawn "cvlc --video-wallpaper --no-audio --no-video-title-show --loop $HOME/.wall&"
  spawn "xsetroot -cursor_name left_ptr"
  -- spawn "google-chrome"
  spawn "amixer -q set Master mute"
  spawn "emacs --daemon"


------------------------------------------------------------------------
-- 
replace :: Eq a => [a] -> [a] -> [a] -> [a]
replace [] _ _ = []
replace s find repl =
    if take (length find) s == find
        then repl ++ (replace (drop (length find) s) find repl)
        else [head s] ++ (replace (tail s) find repl)

replace_n find repl s = replace s find repl

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc . replace_n "NSP " ""
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
      }
      , manageHook = manageDocks <+> myManageHook <+> namedScratchpadManageHook scratchpads
      , startupHook = myStartupHook
      , handleEventHook = mconcat
                          [ docksEventHook
                          , handleEventHook defaultConfig ]

  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
