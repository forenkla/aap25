package opa_demo_rules

import future.keywords.in
import future.keywords.if

deny_delete_locked_vm[msg] {
  some task in input.tasks
  task.name == "Delete VM via Swift endpoint"

  # Check the HTTP method and URL structure
  task.uri.method == "POST"
  task.uri.url != ""

  # The VM to delete (constructed as var1 + var2)
  vm_name_expr := task.uri.body.name
  regex.match(`{{\s*existing_vm\s*}}.*{{\s*vm_suffix\s*}}`, vm_name_expr)

  # Check conditions that make the task active
  when_clauses := task.when

  # Must match both expected condition clauses
  "vm_action == \"Shutdown and Delete\"" in when_clauses
  any_clause_dangerous := [
    clause |
    clause in when_clauses
    contains(clause, "hostvars[existing_vm].delete_lock")
    contains(clause, "!= \"Yes\"")
  ]
  count(any_clause_dangerous) > 0

  msg := "Playbook tries to delete a VM even though delete_lock may be bypassed."
}