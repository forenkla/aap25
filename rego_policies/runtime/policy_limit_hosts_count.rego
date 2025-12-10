package aap_policy_examples

import rego.v1

#
# CONFIG
#

# Global hard cap for number of hosts a job may target
max_hosts := 1

#
# CORE LOGIC
#

# True if this job exceeds the host cap
too_many_hosts if {
    # hosts_count is provided by AAP as part of the input JSON
    # see POLICY_INPUT_DATA.md in the example repo
    input.hosts_count > max_hosts
}

# Collect all violation messages into a list
violations := v if {
    too_many_hosts
    v := [sprintf(
        "Job targets %v hosts, which exceeds the limit of %v hosts",
        [input.hosts_count, max_hosts],
    )]
}

# When no conditions are violated, violations is an empty list
violations := [] if {
    not too_many_hosts
}

#
# ENTRYPOINT FOR AAP
#

allowed := {
    "allowed": not too_many_hosts,
    "violations": violations,
}