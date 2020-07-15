import os

from testinfra.host import Host
from testinfra.utils.ansible_runner import AnsibleRunner


testinfra_hosts = AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


def test_monit_is_installed(host: Host) -> None:
    assert host.package("monit").is_installed


def test_monit_is_running_and_enabled(host: Host) -> None:
    monit_service = host.service("monit")
    assert monit_service.is_running
    assert monit_service.is_enabled


def test_monit_config(host: Host) -> None:
    with host.sudo():
        output = host.run("monit -t -c /etc/monitrc")
        assert output.rc == 0
