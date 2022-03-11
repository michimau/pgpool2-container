#!/bin/sh

set -e

if [ "$1" = 'pgpool' ]; then

  /usr/bin/configure-pgpool2
  cat /etc/pgpool2/pgpool.conf

  #sleep 25
  sed -i "s:socket_dir = '.*':socket_dir = '/var/run/pgpool':g" /etc/pgpool2/pgpool.conf
  sed -i "s:pcp_socket_dir = '.*':pcp_socket_dir = '/var/run/pgpool':g" /etc/pgpool2/pgpool.conf
  #IP_ADDR=$(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
  sed -i "s:listen_addresses = '.*':listen_addresses = '0.0.0.0':g" /etc/pgpool2/pgpool.conf
  #pg_md5 --config-file=/etc/pgpool2/pgpool.conf --md5auth --username=$PCP_USER $PCP_USER_PASSWORD
  echo $PCP_USER:$PCP_USER_PASSWORD > /etc/pgpool2/pool_passwd
  gosu postgres "$@"
  
fi

exec "$@"
