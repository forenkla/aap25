from __future__ import absolute_import, division, print_function
__metaclass__ = type

import json
import urllib.request
from ansible.plugins.inventory import BaseInventoryPlugin
from ansible.errors import AnsibleError

DOCUMENTATION = r'''
name: utm
plugin_type: inventory
short_description: Ansible inventory plugin for UTM daemon
description:
  - Retrieves inventory from a local Swift-based UTM daemon.
options:
  plugin:
    description: Token that ensures this is a source file for the 'utm' plugin.
    required: true
    choices: ['utm', 'jboivie.utm_inventory_plugin.utm']
  url:
    description: The URL of the UTM daemon’s inventory endpoint.
    required: true
    type: string
'''

class InventoryModule(BaseInventoryPlugin):
    NAME = 'utm'

    def verify_file(self, path):
        return path.endswith(('.yml', '.yaml'))

    def parse(self, inventory, loader, path, cache=True):
        super(InventoryModule, self).parse(inventory, loader, path)

        config_data = self._read_config_data(path)
        self.url = self.get_option('url')

        try:
            with urllib.request.urlopen(self.url) as response:
                data = json.load(response)
        except Exception as e:
            raise AnsibleError(f"Failed to fetch inventory from {self.url}: {e}")

        for host in data.get('all', {}).get('hosts', []):
            self.inventory.add_host(host)
            for var, value in data.get('_meta', {}).get('hostvars', {}).get(host, {}).items():
                self.inventory.set_variable(host, var, value)

def get_plugin_type():
    return 'inventory'