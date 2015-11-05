FROM ruby:2.2.3

# Basic parts
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev; apt-get clean

# JS runtime
RUN apt-get install -y curl; apt-get clean
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs; apt-get clean

# Supervisor
RUN apt-get install -y supervisor; apt-get clean
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# App install
ENV APP_HOME /app/backend
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install --jobs=4

# Delete server pid if it was created when running localy
RUN test -f $APP_HOME/tmp/pids/server.pid && rf $APP_HOME/tmp/pids/server.pid; true
ADD . $APP_HOME
RUN chown -R 700 $APP_HOME

EXPOSE 3000
CMD ["/usr/bin/supervisord"]