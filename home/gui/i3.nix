{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
  mod = "Mod4";

  wallpaper = "$HOME/${config.xdg.dataFile."wallpaper.jpg".target}";

  # Allow to fallback to native i3lock if on non-nixos
  # if binary exists at /usr/bin/i3lock-fancy
  # This is proposed due to pam incompatibilities.
  # See https://gist.github.com/rossabaker/f6e5e89fd7423e1c0730fcd950c0cd33
  lockScript = pkgs.writeScriptBin "i3lock" ''
    #!${pkgs.stdenv.shell}

    notify-send "DUNST_COMMAND_PAUSE"
    PATH=$PATH:/usr/bin:${pkgs.i3lock-fancy}/bin i3lock-fancy "$@"
    notify-send "DUNST_COMMAND_RESUME"
  '';
in

{
  # Enable xsession
  xsession.enable = true;
 
  # Enable numlock
  xsession.numlock.enable = true;

  # Used to configure xsession user service
  home.keyboard = {
    layout = "fr";
    variant = "bepo";

    # Use caps lock as escape
    options = [ "caps:escape" ];
  };

  home.packages = with pkgs; [
    arandr
    i3blocks
    shutter
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "${mod}";
      workspaceLayout = "default";
      fonts = [ "monospace 10" ];

      keybindings = {
        # switching between workspace
        "mod1+Shift+Tab" = "workspace prev_on_output";
        "mod1+Tab" = "workspace next_on_output";
        "${mod}+p" = "workspace prev_on_output";
        "${mod}+n" = "workspace next_on_output";

        # change focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # move focused window
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # switch to workspace
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # move focused container to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # kill focused window
        "${mod}+Shift+q" = "kill";
        "--release button2" = "kill";
        "--whole-window ${mod}+button2" = "kill";

        # enter fullscreen mode for the focused container
        "${mod}+z" = "fullscreen";

        # change container layout
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # split in horizontal/vertical orientation
        # the default h and v are already used
        # instead using Shift as modifier and same as vim splits
        "${mod}+Shift+v" = "split h";
        "${mod}+Shift+s" = "split v";

        # toggle tiling / floating
        "${mod}+f" = "floating toggle";

        # Change focus between tiling / floating windows
        "${mod}+Shift+f" = "focus mode_toggle";

        # focus the parent container
        # never had the need to focus child
        "${mod}+a" = "focus parent";

        # Sound shortcuts
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

        # Sreen brightness controls
        # make sure your user belong to the "video" group to have permissions (sudo usermod -a -G video $USER)
        # make also sure you have the correct udev rules in place (https://github.com/haikarainen/light/blob/master/90-backlight.rules)
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 30 # increase screen brightness";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 30 # decrease screen brightness";

        # Scratchpad
        "${mod}+Shift+dollar" = "move scratchpad";
        "${mod}+dollar" = "scratchpad show";

        # Rofi
        "${mod}+space" = "exec --no-startup-id rofi-run";
        "${mod}+v" = "exec --no-startup-id rofi-clipboard";

        # Start a terminal
        "${mod}+Return" = "exec --no-startup-id ${config.programs.alacritty.package}/bin/alacritty --working-directory \"`${pkgs.xcwd}/bin/xcwd`\"";

        # Screenshot
        "Print" = "exec --no-startup-id ${pkgs.shutter}/bin/shutter --select --disable_systray";

        # Enable modes
        "${mod}+r" = "mode resize";
        "${mod}+Delete" = "mode power";
        "${mod}+o" = "mode output";

        # Rename workspace
        "${mod}+comma" = "exec i3-input -F 'rename workspace to \"%s\"' -P 'New name for this workspace: '";
      };

      # Colors for windows.
      #
      # border, background and text: will be visible in the titlebar for tabbed or stacked modes.
      # indicator: will be visible in split mode and will show where the next window will open.
      # childBorder: is the actual window border around the child window.
      # background: is used to paint the background of the client window. Only clients which do not cover
      # the whole area of this window expose the color.
      colors = {
        focused         = { border = "${colors.blue-800}"; background = "${colors.blue-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-100}"; childBorder = "${colors.blue-700}"; };
        focusedInactive = { border = "${colors.blue-800}"; background = "${colors.blue-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.gray-700}"; };
        unfocused       = { border = "${colors.gray-700}"; background = "${colors.gray-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.gray-700}"; };
        urgent          = { border = "${colors.red-800}";  background = "${colors.red-800}";  text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.red-800}"; };
        placeholder     = { border = "${colors.gray-700}"; background = "${colors.gray-800}"; text = "${colors.gray-100}"; indicator = "${colors.gray-800}"; childBorder = "${colors.gray-700}"; };
        background      = "${colors.gray-800}";
      };

      startup = [
        # Remove screensaver and turn off screen after 5 min
        { command = "xset +dpms"; notification = false; }
        { command = "xset dpms 0 0 300"; notification = false; }
        { command = "xset s off"; notification = false; }

        # Autolock after 10 min except if mouse in bottom right corner
        { command = "${pkgs.xautolock}/bin/xautolock -corners 000- -detectsleep -time 10 -locker \"${lockScript}/bin/i3lock -n --text 'Enter Laboratory' --font 'monospace' --greyscale\""; notification = false; }

        # Hide mouse after 10 seconds
        { command = "${pkgs.unclutter-xfixes}/bin/unclutter -idle 10"; notification = false; }

        # Make keyboard stop faster
        { command = "sleep 2 && xset r rate 200 25"; notification = false; }

        # Restore wallpaper
        { command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}"; notification = false; }

        # Start applets
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; notification = false; }

        # Clipboard manager
        { command = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon"; notification = false; }

        # Enable vmware guests if installed
        { command = "vmware-user"; notification = false; }

        # Force restart picom as the service does not start anymore automatically...
        # https://github.com/nix-community/home-manager/issues/1217
        { command = "systemctl --user restart picom.service"; notification = false; }
      ];

      floating = {
        border = 2;

        criteria = [ 
          { title = "Microsoft Teams Notification"; }
        ];
      };

      window = {
        hideEdgeBorders = "smart";
        border = 2;
        titlebar = false;
      };

      focus = {
        # does focus follows mouse
        followMouse = true;
        # does mouse reset to focused container
        mouseWarping = true;
        # disable cycle focus back to opposite window in containers when reaching the edge
        forceWrapping = false;
        newWindow = "smart";
      };

      modes = { 
        resize = { 
          h = "resize grow width 5 px or 5 ppt";
          j = "resize grow height 5 px or 5 ppt";
          k = "resize shrink height 5 px or 5 ppt";
          l = "resize shrink width 5 px or 5 ppt";

          Return = "mode default";
          Escape = "mode default";
        }; 

        power = {
          l = "mode default, exec --no-startup-id ${lockScript}/bin/i3lock -n --text 'Enter Laboratory' --font 'monospace' --greyscale";
          e = "mode default, exec --no-startup-id i3-msg exit";
          r = "mode default, exec --no-startup-id systemctl reboot";
          p = "mode default, exec --no-startup-id systemctl poweroff -i";
          c = "mode default, restart";

          Return = "mode default";
          Escape = "mode default";
        };

        output = {
          h = "move workspace to output left";
          j = "move workspace to output down";
          k = "move workspace to output up";
          l = "move workspace to output right";

          Return = "mode default";
          Escape = "mode default";
        };

      };

      gaps = {
        outer = 8;
        inner = 8;
        smartBorders = "off";
        smartGaps = false;
      };

      bars = [
        {
          mode = "dock";
          position = "top";
          trayOutput = "primary";
          workspaceButtons = true;
          workspaceNumbers = true;
          command = "i3bar";
          fonts = [ "monospace 10" ];
          hiddenState = "hide";

          colors = {
            background = "${colors.gray-800}";
            statusline = "${colors.gray-800}";
            separator = "${colors.gray-800}";

            focusedWorkspace  = { border = "${colors.blue-800}";   background = "${colors.blue-800}";   text = "${colors.gray-100}"; };
            activeWorkspace   = { border = "${colors.blue-800}";   background = "${colors.blue-800}";   text = "${colors.gray-100}"; };
            inactiveWorkspace = { border = "${colors.gray-700}";   background = "${colors.gray-800}";   text = "${colors.gray-100}"; };
            urgentWorkspace   = { border = "${colors.red-800}";    background = "${colors.red-800}";    text = "${colors.gray-100}"; };
            bindingMode       = { border = "${colors.purple-500}"; background = "${colors.purple-500}"; text = "${colors.gray-800}"; };
          };
        }
      ];
    };
  };
}
