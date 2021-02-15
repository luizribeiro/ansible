import os

from pyexpect import expect
from testinfra.host import Host
from testinfra.utils.ansible_runner import AnsibleRunner


testinfra_hosts = AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


def test_docker_is_installed(host: Host) -> None:
    assert host.package("docker").is_installed


def test_docker_is_running_and_enabled(host: Host) -> None:
    docker_service = host.service("docker")
    expect(docker_service.is_running).is_true()
    expect(docker_service.is_enabled).is_true()
