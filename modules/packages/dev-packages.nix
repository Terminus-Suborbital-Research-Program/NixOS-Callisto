{pkgs, ...} : {
  environment.systemPackages = with pkgs; [
    git
    vim
    tmux
    gcc
    tree
  ];
}