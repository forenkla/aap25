package opa_demo_rules

import rego.v1

# DEBUG POLICY: always deny and print out what AAP is actually sending

debug_hosts_count = result if {
    hosts_count := object.get(input, ["hosts_count"], "MISSING")
    inv_total   := object.get(input, ["inventory", "total_hosts"], "MISSING")
    limit       := object.get(input, ["limit"], "MISSING")

    msg := sprintf(
        "DEBUG: hosts_count=%v, inventory.total_hosts=%v, limit=%v, raw_input=%v",
        [hosts_count, inv_total, limit, json.marshal(input)],
    )

    result := {
        "allowed": false,
        "violations": [msg],
    }
}