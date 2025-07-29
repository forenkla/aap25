#!/bin/bash
set -e

podman pull aap25.containersarelinux.net/ansible-automation-platform-25/ee-supported-rhel9
podman pull aap25.containersarelinux.net/ansible-automation-platform-25/ee-minimal-utm
podman pull aap25.containersarelinux.net/ansible-automation-platform-25/aap-configurator:latest