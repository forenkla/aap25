package opa_demo_rules

import rego.v1

# Default policy: allowed
default extra_vars_policy = {
	"allowed": true,
	"violations": [],
}

# Disallow if "delete_lock" is present in extra_vars
extra_vars_policy = result if {
	extra_vars := object.get(input, ["extra_vars"], {})

	"delete_lock" in object.keys(extra_vars)

	result := {
		"allowed": false,
		"violations": ["The extra_var 'delete_lock' is NOT allowed."],
	}
}