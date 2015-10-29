FROM ruby:2.2.3
# Basic parts
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
# JS runtime
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs
# App install
RUN mkdir /backend
WORKDIR /backend
ADD Gemfile /backend/Gemfile
RUN bundle install --path vendor/bundle
ADD . /backend