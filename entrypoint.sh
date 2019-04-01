#!/usr/bin/env sh
set -e

if [ ! -z "$PRIVATE_SSH_KEY" ] && [ ! -f /root/.ssh/id_rsa ]; then
  mkdir -p /root/.ssh

  echo -n $PRIVATE_SSH_KEY > /root/.ssh/id_rsa

  chmod 700 /root/.ssh
  chmod 600 /root/.ssh/*
fi

if [ -f /root/.ssh/id_rsa ]; then
  eval "$(ssh-agent -s)"
  ssh-add /root/.ssh/id_rsa
fi

exec "$@"
