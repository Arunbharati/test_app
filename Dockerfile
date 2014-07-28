# Dockerfile for RentalGeek Hamilton
# Modeled after https://github.com/substantial/substantial-dash-server/blob/master/Dockerfile
FROM fcat/ubuntu-universe:12.04

MAINTAINER Mike Mooring <mdmooring@rentalgeek.com>

RUN apt-key update -y && apt-get update -y && apt-get upgrade -y

#-----------------------------------------------------------------------
# basic utils
#-----------------------------------------------------------------------
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl git htop unzip nano wget

#-----------------------------------------------------------------------
# ssh server install
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Supervisor install
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Ruby install
# https://index.docker.io/u/paintedfox/ruby/
#-----------------------------------------------------------------------
# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Install ruby.
# Solution from: http://stackoverflow.com/a/16224372
ADD http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz /tmp/
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev && \
    tar -xzf /tmp/ruby-2.1.1.tar.gz && \
    (cd ruby-2.1.1/ && ./configure --disable-install-doc && make && make install) && \
    rm -rf ruby-2.1.1/ && \
    rm -f /tmp/ruby-2.1.1.tar.gz

#-----------------------------------------------------------------------
# Rails app 
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-eploying#-a-rails-app-to-docker/
#-----------------------------------------------------------------------
RUN gem update --system
RUN gem install bundler

# Cache bundle by running install before adding the app itself.
# Installs into the system rubygems instead of vendor/bundle.
WORKDIR /tmp 
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
WORKDIR /

# Now copy the app into the image.
ADD . /opt/rails_app
# Clear origin's bundle config & cache, so there's
# no confusion with the Docker-cached bundle.
RUN rm -rf /opt/rails_app/.bundle
RUN rm -rf /opt/rails_app/vendor/bundle
# Clear cruft from origin dev environment.
RUN rm -rf /opt/rails_app/log/*
RUN rm -rf /opt/rails_app/tmp/*

#-----------------------------------------------------------------------
# initialize environment
#-----------------------------------------------------------------------
# Import all configurations

# Set the final working dir to the Rails app's location.
WORKDIR /opt/rails_app

# Persist data between containers
RUN adduser --disabled-password --home=/rails --gecos "" rails
ADD scripts/start /start
ADD scripts/setup /setup
#-----------------------------------------------------------------------
# Container config
#-----------------------------------------------------------------------
EXPOSE 3000
USER rails
CMD /start