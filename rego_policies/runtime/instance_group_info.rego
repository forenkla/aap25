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
			sprintf("ig.name: %s", [ig.name]),
			sprintf("ig.capacity: %v", [ig.capacity]),
			sprintf("ig.jobs_running: %v", [ig.jobs_running]),
			sprintf("ig.jobs_total: %v", [ig.jobs_total]),
			sprintf("ig.max_concurrent_jobs: %v", [ig.max_concurrent_jobs]),
			sprintf("ig.max_forks: %v", [ig.max_forks]),
			sprintf("Forks: %v", [forks])
		],
	}
}