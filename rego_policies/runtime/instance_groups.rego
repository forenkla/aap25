package opa_demo_rules

import rego.v1

default instance_group_info = {
	"allowed": true,
	"violations": [],
}

instance_group_info = result if {
	instance_group := object.get(input, ["instance_group"], null)
	forks := object.get(input, ["forks"], null)

	result := {
		"allowed": true,
		"violations": [
			sprintf("Instance group: %v", [instance_group]),
			sprintf("Forks: %v", [forks])
		]
	}
}