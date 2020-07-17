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


def test_firewall_drops_by_default(host: Host) -> None:
    with host.sudo():
        assert host.iptables.rules("filter", "INPUT") == [
            "-P INPUT DROP",
            "-A INPUT -j ufw-before-logging-input",
            "-A INPUT -j ufw-before-input",
            "-A INPUT -j ufw-after-input",
            "-A INPUT -j ufw-after-logging-input",
            "-A INPUT -j ufw-reject-input",
            "-A INPUT -j ufw-track-input",
        ]

        expected_input_rules = {
            "-N ufw-user-input",
            "-A ufw-user-input -p tcp -m tcp --dport 22 -m conntrack"
            + " --ctstate NEW -m recent --set --name DEFAULT"
            + " --mask 255.255.255.255 --rsource",
            "-A ufw-user-input -p tcp -m tcp --dport 22 -m conntrack"
            + " --ctstate NEW -m recent --update --seconds 30 --hitcount 6"
            + " --name DEFAULT --mask 255.255.255.255 --rsource -j ufw-user-limit",
            "-A ufw-user-input -p tcp -m tcp --dport 22 -j ufw-user-limit-accept",
        }
        input_rules = set(host.iptables.rules("filter", "ufw-user-input"))
        assert expected_input_rules & input_rules == expected_input_rules
