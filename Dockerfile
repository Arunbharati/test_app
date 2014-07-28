FROM fcat/ubuntu-universe:12.04

RUN apt-get -qy install git vim tmux
RUN apt-get -qy install ruby1.9.1 ruby1.9.1-dev build-essential libpq-dev libv8-dev libsqlite3-dev
RUN gem install bundler
RUN adduser --disabled-password --home=/rails --gecos "" rails

ADD docrails/guides/code/getting_started /rails
ADD scripts/start /start
ADD scripts/setup /setup
RUN su rails -c /setup

EXPOSE 3000
USER rails
CMD /start