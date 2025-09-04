# openaudible.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.openaudible;

  # OpenAudible AppImage package
  openaudible = pkgs.appimageTools.wrapType2 {
    pname = "openaudible";
    version = "4.6.3";
    src = pkgs.fetchurl {
      url = "https://github.com/openaudible/openaudible/releases/download/v4.6.3/OpenAudible_4.6.3_x86_64.AppImage";
      sha256 = "4bd7b3de76572500cc11e3cb3d1cfa39c21d5595c4aeceffddb8fea4b78ea178";
    };

    extraPkgs = pkgs: with pkgs; [
      # Additional dependencies that OpenAudible might need
      ffmpeg
      openjfx
      gtk3
      gsettings-desktop-schemas
    ];

    extraInstallCommands = ''
      # Create desktop entry
      mkdir -p $out/share/applications
      cat > $out/share/applications/openaudible.desktop << EOF
      [Desktop Entry]
      Type=Application
      Name=OpenAudible
      Comment=Audible audiobook manager
      Exec=$out/bin/openaudible
      Icon=openaudible
      Categories=AudioVideo;Audio;
      StartupWMClass=OpenAudible
      EOF

      # Install icon if available in the AppImage
      mkdir -p $out/share/pixmaps
      # The icon extraction might need adjustment based on the actual AppImage contents
      ${pkgs.libsForQt5.qt5.qttools}/bin/icns2png -x $out/bin/openaudible || true
    '';
  };

in {
  options.programs.openaudible = {
    enable = mkEnableOption "OpenAudible audiobook manager";

    package = mkOption {
      type = types.package;
      default = openaudible;
      description = "The OpenAudible package to use";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Enable required services
    services.dbus.enable = true;

    # Font and theme support
    fonts.packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
    ];

    # GTK theme support for better integration
    programs.dconf.enable = true;

    # File associations (optional)
    environment.etc."mime.types".text = ''
      audio/x-audible application/x-audible
    '';
  };
}
