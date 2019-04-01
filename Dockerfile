FROM ruby:2-stretch

RUN set -eux; \
  \
   mkdir -p /usr/share/man/man1 /usr/share/man/man7; \
  \
  # install running dependencies
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ssh \
  ; \
  \
  gem update --system; \
  gem install bundler; \
  \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /tmp/* /var/lib/apt/lists/* $GEM_HOME/cache/* $HOME/.bundle/cache/*

RUN set -eux; \
  sed -ri -e "s@#   ForwardAgent no@  ForwardAgent yes@g" /etc/ssh/ssh_config; \
  sed -ri -e "s@#   StrictHostKeyChecking .+@  StrictHostKeyChecking no@g" /etc/ssh/ssh_config

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod 775 /root/entrypoint.sh

WORKDIR /app

ENTRYPOINT [ "/root/entrypoint.sh" ]
