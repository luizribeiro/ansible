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
        monitrc = host.file("/etc/monitrc")
        assert monitrc.is_file
        assert monitrc.user == "root"
        assert monitrc.group == "root"
        assert oct(monitrc.mode) == "0o700"

        output = host.run("monit -t -c /etc/monitrc")
        assert output.rc == 0


def test_firewall_drops_by_default(host: Host) -> None:
    expected_input_rules = [
        "-P INPUT DROP",
        "-A INPUT -j ufw-before-logging-input",
        "-A INPUT -j ufw-before-input",
        "-A INPUT -j ufw-after-input",
        "-A INPUT -j ufw-after-logging-input",
        "-A INPUT -j ufw-reject-input",
        "-A INPUT -j ufw-track-input",
    ]
    with host.sudo():
        input_rules = host.iptables.rules("filter", "INPUT")
    assert expected_input_rules == input_rules


def test_firewall_input_rules_for_ssh_and_mosh(host: Host) -> None:
    expected_input_rules = {
        "-N ufw-user-input",
        # always allow SSH connections on testing environment (not rate limited)
        "-A ufw-user-input -p udp -m udp --dport 22 -j ACCEPT",
        "-A ufw-user-input -p tcp -m tcp --dport 22 -j ACCEPT",
        # mosh connections are still rate limited though
        "-A ufw-user-input -p udp -m multiport --dports 60001:60999 -j ufw-user-limit-accept",
    }
    with host.sudo():
        input_rules = set(host.iptables.rules("filter", "ufw-user-input"))
    assert expected_input_rules & input_rules == expected_input_rules
