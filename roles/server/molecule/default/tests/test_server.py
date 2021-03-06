import os

from pyexpect import expect
from testinfra.host import Host
from testinfra.utils.ansible_runner import AnsibleRunner


testinfra_hosts = AnsibleRunner(os.environ["MOLECULE_INVENTORY_FILE"]).get_hosts("all")


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
    expect(input_rules).equals(expected_input_rules)


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
    expect(expected_input_rules & input_rules).equals(expected_input_rules)
