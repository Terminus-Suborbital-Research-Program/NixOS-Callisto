{pkgs, ...} : {
  imports = [./modules/hardware/pi-5-v1.nix];
  system.stateVersion = "26.05";# Pinned, DON"T CHANGE

  nixpkgs.config.allowUnfree = true;

  users.users.terminus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "gpio" "i2c" "uart" "video" ];
    hashedPassword =
      "$6$/y/JpKnBdDNKy4TT$AwhlCR6pIDBvvzdk8ZIKQFUQ/qp4o5lGJJq3kLQtnFHfuW6eJbbz7Pd/MxDOV8Ie0/0moYgCxTln0a9UA0Edz.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFABx8yt6E4tlqX0/vGELPKcuooKUwfPC7E4xhKroYZm tonez3d@gmail.com"
    ];
  };

  networking.hostName = "terminus";
  security.sudo.wheelNeedsPassword = false;

  hardware = { 
    raspberry-pi = { 
      firmware = {
        enable = true;
        uboot.enable = true;
      };
      configtxt.settings = {
        all.dtparam = [ "i2c_arm=on" ];
        pi5.arm_freq = 2400;
      };
    };
    enableRedistributableFirmware = true;
  };

  services.openssh.enable = true;
  systemd.services.systemd-timesyncd.enable = false;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}