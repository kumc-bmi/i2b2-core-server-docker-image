#!/bin/bash

set -euxo pipefail

: "$i2b2_wildfly_admin_pass"
: "$TZ"

ansible-playbook configure_datasources.yml -e @datasource_vars.yml

~/wildfly/bin/add-user.sh -u admin -e -p "$i2b2_wildfly_admin_pass"
exec ~/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
