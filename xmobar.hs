-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
  bgColor = "#1E1E1E"
  , fgColor = "#FFFFFF"
  , font = "xft:Roboto:normal:size=10:antialias=true",lowerOnStart = True
  , commands = [
      Run Memory ["-t","Mem:<usedratio>%","-H","50","-L","10",
                   "-h","#FF8500","-l","#8CC4FF","-n","#8CC4FF"] 15,
        Run Cpu ["-t","CPU:<total>%","-H","60","-L","20","-h","#FF8500",
                  "-l","#8CC4FF","-n","#CCCC00"] 15,
        Run Network "wlp8s0" ["-t","Net:<rx>rx,<tx>tx","-H","500","-L","20",
                              "-h","#FF8500","-l","#8CC4FF","-n","#CCCC00"] 10,
        Run Date "%A %d/%m - %-I:%M:%S %P" "date" 10,
        -- Run Com "/bin/sh" ["-c","~/.xmonad/battscript.sh"] "battery" 20,
        Run Com "/bin/sh" ["-c","~/.xmonad/volscript.sh"] "vol" 5,
        -- Run Com "/bin/sh" ["-c","~/.xmonad/wifiscript.sh"] "radio" 20,
        -- Run Com "/bin/bash" ["-c","~/.xmonad/sizescript.sh"] "space" 300,
        Run Com "/bin/bash" ["-c","python ~/.xmonad/lockscript.py"] "lock" 15,
        Run Com "/bin/bash" ["-c","python ~/.xmonad/userscript.py"] "users" 5,
        Run StdinReader
      ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "    %StdinReader% }  %date% %users% %lock% {  %memory%    %cpu%    %vol%    "
  --, template = "    %StdinReader% }  %date% %users%  {  %memory%    %cpu%    %wlp8s0%  %vol%    "
  , position = TopW C 100
  --, lowerOnStart =     True    -- send to bottom of window stack on start
  , hideOnStart =      False   -- start with window unmapped (hidden)
  , allDesktops =      True    -- show on all desktops
  , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
  , pickBroadest =     False   -- choose widest display (multi-monitor)
  , persistent =       True    -- enable/disable hiding (True = disabled)
}
