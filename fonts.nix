{ config, pkgs, ...}: {

  fonts.packages = with pkgs; [
    #(nerdfonts.override { fonts = [ "FiraCode" "Mononoki" "UbuntuMono" "SpaceMono" "DejaVuSansMono" ]; })
    nerd-fonts.fira-code
    nerd-fonts.mononoki
    nerd-fonts.ubuntu-mono
    nerd-fonts.space-mono
    nerd-fonts.dejavu-sans-mono
  ];

  fonts.fontDir.enable = true;

}
