{ config, pkgs, ... }:

{
  fileSystems."/mnt/home" = {
    device = "backup/home";
    fsType = "zfs";
  };

  fileSystems."/mnt/media" = {
    device = "backup/media";
    fsType = "zfs";
  };

  fileSystems."/mnt/projects" = {
    device = "backup/projects";
    fsType = "zfs";
  };

  fileSystems."/export/home" = {
    device = "/mnt/home";
    options = ["bind"];
  };

  fileSystems."/export/media" = {
    device = "/mnt/media";
    options = ["bind"];
  };

  fileSystems."/export/projects" = {
    device = "/mnt/projects";
    options = ["bind"];
  };

  services.nfs.server = {
    enable = true;
    # statdPort = 4000;
    # lockdPort = 4001;
    # mountdPort = 4002;
    exports = ''
      /export                192.168.1.0/24(rw,fsid=0,no_subtree_check)
      /export/home           192.168.1.0/24(rw,async,nohide,all_squash,anonuid=1000,anongid=1000,insecure,no_subtree_check)
      /export/media          192.168.1.0/24(rw,nohide,all_squash,anonuid=1000,anongid=1000,insecure,no_subtree_check)
      /export/projects       192.168.1.0/24(rw,async,nohide,all_squash,anonuid=1000,anongid=1000,insecure,no_subtree_check)
    '';
  };

  networking.firewall.allowPing = true;

  networking.firewall.allowedTCPPorts = [
    111  # nfs?
    2049 # nfs
    4000 # nfs/statd
    4001 # nfs/lockd
    4002 # nfs/mountd
    138  # smb
    445  # smb
  ];

  networking.firewall.allowedUDPPorts = [
    111  # nfs?
    2049 # nfs
    4000 # nfs/statd
    4001 # nfs/lockd
    4002 # nfs/mountd
    138  # smb
    445  # smb
  ];

  services.samba = {
    enable = true;
    syncPasswordsByPam = true;
    extraConfig = ''
      guest account = nobody
      map to guest = bad user

      load printers = no
      printing = bsd
      printcap name = /dev/null
      disable spoolss = yes

      dos charset = cp866
      unix charset = UTF8

      server multi channel support = yes
      aio read size = 1
      aio write size = 1
    '';

    shares = {
      home = {
        path = "/mnt/home";
        "read only" = "no";
        "valid users" = "dejanr";
        "max connections" = "20000";
      };
      media = {
        path = "/mnt/media";
        "writable" = "yes";
        "public" = "yes";
        "browsable" = "yes";
        "guest ok" = "yes";
        "max connections" = "20000";
      };
      projects = {
        path = "/mnt/home";
        "read only" = "no";
        "valid users" = "dejanr";
        "max connections" = "20000";
      };
    };
  };
}
