package opa_demo_rules

import rego.v1

#
# CONFIG
#

# Hard cap on how many hosts a job may target
max_hosts := 1

#
# DEFAULT RESULT: ALLOW
#

default policy_limit_hosts_count = {
    "allowed": true,
    "violations": [],
}

#
# OVERRIDE WHEN HOST CAP IS EXCEEDED
#

policy_limit_hosts_count = result if {
    # hosts_count may or may not be present – be defensive
    hosts_count := input.hosts_count

    hosts_count > max_hosts

    result := {
        "allowed": false,
        "violations": [
            sprintf(
                "Job targets %v hosts, which exceeds the limit of %v hosts",
                [hosts_count, max_hosts],
            ),
        ],
    }
}