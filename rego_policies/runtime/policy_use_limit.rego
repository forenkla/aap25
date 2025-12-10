package opa_demo_rules

import rego.v1

#
# CONFIG
#

# If an inventory has more than this number of hosts,
# the user MUST set a limit.
max_inventory_hosts_without_limit := 1  # change to whatever threshold you want

#
# DEFAULT RESULT: ALLOW
#

default policy_limit_hosts_count = {
    "allowed": true,
    "violations": [],
}

#
# OVERRIDE WHEN:
#  - inventory.total_hosts > max_inventory_hosts_without_limit
#  - AND limit is empty
#

policy_use_limit = result if {
    # be a little defensive in case pieces are missing
    inv_total := object.get(input, ["inventory", "total_hosts"], 0)

    inv_total > max_inventory_hosts_without_limit

    limit := trim(object.get(input, ["limit"], ""))

    limit == ""  # require some limit when inventory is "large"

    inv_name := object.get(input, ["inventory", "name"], "<unknown>")

    result := {
        "allowed": false,
        "violations": [
            sprintf(
                "Inventory %q has %v hosts; you must set a limit (for example 'aap' or 'web') before running this job.",
                [inv_name, inv_total],
            ),
        ],
    }
}