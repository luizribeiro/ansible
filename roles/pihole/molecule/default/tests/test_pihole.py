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
    expect(oct(setupvars_conf.mode)).equals("0o644")


SIMPLE_IP_ADDRESS_REGEXP = r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"


def _resolve(host: Host, domain: str) -> str:
    dig = host.run(f"dig +short @127.0.0.1 {domain}")
    return str(dig.stdout.split("\n")[-2])


def test_dns_resolving(host: Host) -> None:
    ip_address = _resolve(host, "www.google.com")
    expect(ip_address).matches(SIMPLE_IP_ADDRESS_REGEXP)


def test_dns_resolving_for_a_blocked_domain(host: Host) -> None:
    ip_address = _resolve(host, "app-measurement.com")
    expect(ip_address).equals("0.0.0.0")


def test_dns_resolving_for_a_whitelisted_domain(host: Host) -> None:
    ip_address = _resolve(host, "graph.instagram.com")
    expect(ip_address).matches(SIMPLE_IP_ADDRESS_REGEXP)
