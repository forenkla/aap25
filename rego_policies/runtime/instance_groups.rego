package opa_demo_rules

import rego.v1

default result = {
	"allowed": true,
	"violations": [],
}

result := output if {
	ig := object.get(input, ["instance_group"], null)
	forks := object.get(input, ["forks"], null)

	output := {
		"allowed": true,
		"violations": [
			sprintf("Instance group name: %s", [ig.name]),
			sprintf("Instance group capacity: %v", [ig.capacity]),
			sprintf("Forks: %v", [forks])
		]
	}
}