#!/bin/bash -e

# forked from https://github.com/grafana/grafana-docker/blob/master/run.sh

echo 'Setting up environment defaults'
: "${GF_PATHS_DATA:=/var/lib/grafana}"
: "${GF_PATHS_LOGS:=/var/log/grafana}"
: "${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}"
echo '...done'

#chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_LOGS"
#chown -R grafana:grafana /etc/grafana

if [ ! -z ${GF_AWS_PROFILES+x} ]; then
    echo 'Arranging for AWS'

    mkdir -p ~grafana/.aws/
    touch ~grafana/.aws/credentials

    for profile in ${GF_AWS_PROFILES}; do
        access_key_varname="GF_AWS_${profile}_ACCESS_KEY_ID"
        secret_key_varname="GF_AWS_${profile}_SECRET_ACCESS_KEY"
        region_varname="GF_AWS_${profile}_REGION"

        if [ ! -z "${!access_key_varname}" -a ! -z "${!secret_key_varname}" ]; then
            echo "[${profile}]" >> ~grafana/.aws/credentials
            echo "aws_access_key_id = ${!access_key_varname}" >> ~grafana/.aws/credentials
            echo "aws_secret_access_key = ${!secret_key_varname}" >> ~grafana/.aws/credentials
            if [ ! -z "${!region_varname}" ]; then
                echo "region = ${!region_varname}" >> ~grafana/.aws/credentials
            fi
        fi
    done

    chown grafana:grafana -R ~grafana/.aws
    chmod 600 ~grafana/.aws/credentials

    echo '...done'
fi

if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then
  echo 'Installing plugins'

  OLDIFS=$IFS
  IFS=','
  for plugin in ${GF_INSTALL_PLUGINS}; do
    grafana-cli  --pluginsDir "${GF_PATHS_PLUGINS}" plugins install ${plugin}
  done
  IFS=$OLDIFS

  echo '...done'
fi

echo 'Running Grafana'
exec /usr/sbin/grafana-server      \
  --homepath=/usr/share/grafana                 \
  --config=/etc/grafana/grafana.ini             \
  cfg:default.paths.data="$GF_PATHS_DATA"       \
  cfg:default.paths.logs="$GF_PATHS_LOGS"       \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS" \
  "$@"
