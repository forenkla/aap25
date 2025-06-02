package main

import future.keywords.contains
import future.keywords.if
import future.keywords.in

allowed_mariadb_versions = [
  "10.8.6",
  "10.9.4"
]

deny_unapproved_version contains msg if {
  some task in input.tasks
  package_name := task["ansible.builtin.package"].name
  regex.match("MariaDB-server.*", package_name)

  version := split(package_name, "-")[2]
  not version in allowed_mariadb_versions

  msg := sprintf("Version %v of Mariadb-server is not allowed", [version])
}


# Deny if MariaDB-server is installed with no version specified
deny_unapproved_version contains msg if {
  some task in input.tasks
  package_name := task["ansible.builtin.package"].name
  lower(package_name) == "mariadb-server"

  msg := "MariaDB-server must include a version (e.g. mariadb-server-10.9.4)"
}
