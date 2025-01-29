{ config, pkgs, ... }: {
  # System-wide Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
#    ohMyZsh = {
#      enable = true;
#      plugins = [ "git" "sudo" ];
#      theme = "robbyrussell";
#    };
    shellAliases = {
      ll = "ls -l";
      #update = "sudo nixos-rebuild switch";
    };
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
  };

  # Set Zsh as default shell for all users
  users.defaultUserShell = pkgs.zsh;
}
