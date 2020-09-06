settings {
  logfile = "/var/log/lsyncd.log",
  statusFile = "/var/log/lsyncd-status.log",
  statusInterval = 1,
}

sync {
  default.rsyncssh,
  source = "/home/public/iot-mariner/",
  host = "lsync@iot-mariner",
  targetdir = "/mnt/usb_share/",
  ssh = {
    identityFile = "/etc/lsyncd/id_rsa",
  },
}
