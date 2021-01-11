import os

from pyexpect import expect
from testinfra.host import Host
from testinfra.utils.ansible_runner import AnsibleRunner


testinfra_hosts = AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


def test_monit_is_installed(host: Host) -> None:
    assert host.package("monit").is_installed


def test_monit_is_running_and_enabled(host: Host) -> None:
    monit_service = host.service("monit")
    expect(monit_service.is_running).is_true()
    expect(monit_service.is_enabled).is_true()


def test_monit_config(host: Host) -> None:
    with host.sudo():
        monitrc = host.file("/etc/monitrc")
    expect(monitrc.is_file).is_true()
    expect(monitrc.user).equals("root")
    expect(monitrc.group).equals("root")
    expect(oct(monitrc.mode)).equals("0o700")

    with host.sudo():
        output = host.run("monit -t -c /etc/monitrc")
    expect(output.rc).equals(0)
