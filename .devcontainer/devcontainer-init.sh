#!/bin/bash
set -e

podman pull aap25.containersarelinux.net/ansible-automation-platform-25/ee-supported-rhel9
podman pull aap25.containersarelinux.net/ansible-automation-platform-25/ee-minimal-utm
podman pull aap25.containersarelinux.net/ansible-automation-platform-25/aap-configurator:latest


# Ensure group_vars directory exists
mkdir -p /workspaces/aap25/aap_setup/group_vars/all

# Define source and target for the vault symlink
VAULT_SRC="/workspaces/aap25/vault.yml"
VAULT_LINK="/workspaces/aap25/aap_setup/group_vars/all/vault.yml"

# Ensure the symlink is correct (create or fix it)
if [ ! -L "$VAULT_LINK" ] || [ "$(readlink "$VAULT_LINK")" != "$VAULT_SRC" ]; then
    ln -sf "$VAULT_SRC" "$VAULT_LINK"
fi
