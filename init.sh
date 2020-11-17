#!/bin/bash

set -euxo pipefail

: "$i2b2_wildfly_admin_pass"
: "$TZ"

if [ ! -f ~/bootstrapped ] ; then
  ansible-playbook configure_datasources.yml -e @datasource_vars.yml

  if [ -e "$i2b2_ldaps_cert_path" ] ; then
    keytool -import -trustcacerts -alias example.net -keystore /etc/pki/java/cacerts -file "$i2b2_ldaps_cert_path" -storepass changeit -noprompt
  fi

  ~/wildfly/bin/add-user.sh -u admin -e -p "$i2b2_wildfly_admin_pass"
  touch ~/bootstrapped
fi

exec ~/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
