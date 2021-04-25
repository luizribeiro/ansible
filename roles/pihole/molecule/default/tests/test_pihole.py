import os
import re
from typing import Optional, Tuple

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


def _resolve(host: Host, domain: str) -> Tuple[str, Optional[str]]:
    dig_full = host.run(f"dig @127.0.0.1 {domain}")
    status_search = re.search(r"status: ([A-Z]+)", dig_full.stdout)
    if status_search is None:
        raise Exception("Could not parse dig response")
    status = status_search.group(1)

    dig_short = host.run(f"dig +short @127.0.0.1 {domain}")
    try:
        ip_address = str(dig_short.stdout.split("\n")[-2])
    except IndexError:
        ip_address = None

    return (status, ip_address)


def test_dns_resolving(host: Host) -> None:
    status, ip_address = _resolve(host, "www.google.com")
    expect(status).equals("NOERROR")
    expect(ip_address).matches(SIMPLE_IP_ADDRESS_REGEXP)


def test_dns_resolving_for_a_blocked_domain(host: Host) -> None:
    status, ip_address = _resolve(host, "app-measurement.com")
    expect(status).equals("NXDOMAIN")
    expect(ip_address).equals(None)


def test_dns_resolving_for_a_whitelisted_domain(host: Host) -> None:
    status, ip_address = _resolve(host, "graph.instagram.com")
    expect(status).equals("NOERROR")
    expect(ip_address).matches(SIMPLE_IP_ADDRESS_REGEXP)
