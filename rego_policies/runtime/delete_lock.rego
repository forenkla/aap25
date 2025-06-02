package aap_policy

import future.keywords.in
import future.keywords.if
import future.keywords.contains

deny[msg] {
  some task in input.tasks
  task.name == "Delete VM via Swift endpoint"

  task.uri.method == "POST"
  task.uri.url != ""

  # VM name is templated
  regex.match(`{{\s*existing_vm\s*}}.*{{\s*vm_suffix\s*}}`, task.uri.body.name)

  # Ensure `when` clause exists and is a list
  when_clauses := task.when

  "vm_action == \"Shutdown and Delete\"" in when_clauses

  some clause in when_clauses
  contains(clause, "hostvars[existing_vm].delete_lock")
  contains(clause, "!= \"Yes\"")

  msg := "VM delete task may bypass delete_lock enforcement; review conditions."
}