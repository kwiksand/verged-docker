#!/bin/sh
set -e
VERGE_DATA=/home/verge/.VERGE
cd /home/verge/verged

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for verged"

  set -- verged "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "verged" ]; then
  mkdir -p "$VERGE_DATA"
  chmod 700 "$VERGE_DATA"
  chown -R verge "$VERGE_DATA"

  echo "$0: setting data directory to $VERGE_DATA"

  set -- "$@" -datadir="$VERGE_DATA"
fi

if [ "$1" = "verged" ] || [ "$1" = "verge-cli" ] || [ "$1" = "verge-tx" ]; then
  echo
  exec gosu verge "$@"
fi

echo
exec "$@"
