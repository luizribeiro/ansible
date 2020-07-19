import os

from testinfra.host import Host
from testinfra.utils.ansible_runner import AnsibleRunner


testinfra_hosts = AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


def test_pihole_is_installed(host: Host) -> None:
    assert host.package("pi-hole-server").is_installed
    assert host.package("pi-hole-ftl").is_installed
