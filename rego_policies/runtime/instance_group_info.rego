package aap_policy_examples

import rego.v1

default instance_group_info := {
	"allowed": true,
	"violations": [],
}

instance_group_info := result if {
	ig := object.get(input, ["instance_group"], {})
	forks := object.get(input, ["forks"], {})

	result := {
		"allowed": false,
		"violations": [
			sprintf("Instance group name: %s", [ig.name]),
			sprintf("Instance group capacity: %v", [ig.capacity]),
			sprintf("Forks: %v", [forks])
		],
	}
}