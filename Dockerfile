FROM zumbrunnen/base
MAINTAINER David Zumbrunnen <zumbrunnen@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV APP_RUBY_VERSION 2.1.2
ENV RAILS_ENV production
ENV DB_USERNAME docker
ENV DB_PASSWORD docker

RUN apt-get -qq update
RUN apt-get -yqq upgrade
RUN apt-get -yqq install curl libpq-dev

RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN su root -c 'source /usr/local/rvm/scripts/rvm && rvm install $APP_RUBY_VERSION --default'


EXPOSE 3000

CMD ["/usr/bin/supervisord"]