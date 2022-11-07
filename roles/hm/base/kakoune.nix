{ pkgs, ... }:

{
  # colorscheme
  xdg.configFile."kak/colors/ansi.kak".source = ./ansi.kak;

  programs.kakoune = {
    enable = true;

    config = {
      colorScheme = "ansi";
      ui.assistant = "none";

      indentWidth = 4;
      tabStop = 4;
    };

    extraConfig = ''
      def find -params 1 -shell-script-candidates %{ git ls-files } %{ edit %arg{1} }
    '';
  };
}

