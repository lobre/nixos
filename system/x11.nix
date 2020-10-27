{ config, pkgs, ... }:

{
  # Network Manager is a high level interface
  # to automatically configure the network.
  # It comes with opinionated configurations
  # which don't always play well with server setups.
  # That's why it is only enabled alongside x11 configs.
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";

    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk = {
          theme.name = "Arc-Darker";
          theme.package = pkgs.arc-theme;
          iconTheme.name = "Arc";
          iconTheme.package = pkgs.arc-icon-theme;
          indicators = [
            "~host"
            "~spacer"
            "~clock"
            "~spacer"
            "~session"
            "~power"
          ];
          extraConfig = ''
            font-name=Fira Code 12
          '';
        };
      };

      # Launch user defined session from ~/.xsession
      session = [
         {
           manage = "desktop";
           name = "xsession";
           start = "";
         }
      ];
    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    fira-code
  ];
}
