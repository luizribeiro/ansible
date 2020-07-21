import os

from pyexpect import expect
from testinfra.host import Host
from testinfra.utils.ansible_runner import AnsibleRunner


testinfra_hosts = AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


def test_pihole_is_installed(host: Host) -> None:
    expect(host.package("pi-hole-server").is_installed).is_true()
    expect(host.package("pi-hole-ftl").is_installed).is_true()


def test_setupvars_conf_permissions(host: Host) -> None:
    with host.sudo():
        setupvars_conf = host.file("/etc/pihole/setupVars.conf")
    expect(setupvars_conf.is_file).is_true()
    expect(setupvars_conf.user).equals("pihole")
    expect(setupvars_conf.group).equals("pihole")
    expect(oct(setupvars_conf.mode)).equals("0o640")


def test_setupvars_conf_can_be_read_by_http_user(host: Host) -> None:
    with host.sudo():
        getfacl = host.run("getfacl /etc/pihole/setupVars.conf")
    expect(getfacl.stdout.split("\n")).to_contain("user:http:r--")
