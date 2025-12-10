package opa_demo_rules

import rego.v1

#
# CONFIG
#

max_hosts := 50

#
# CORE LOGIC
#

too_many_hosts if {
    input.hosts_count > max_hosts
}

violations := [msg] if {
    too_many_hosts
    msg := sprintf(
        "Job targets %v hosts, which exceeds the limit of %v hosts",
        [input.hosts_count, max_hosts],
    )
}

violations := [] if {
    not too_many_hosts
}

#
# ENTRYPOINT
#

# AAP will query aap_policy_examples/allowed
allowed := {
    "allowed": true,
    "violations": [],
} if {
    not too_many_hosts
}

allowed := {
    "allowed": false,
    "violations": violations,
} if {
    too_many_hosts
}