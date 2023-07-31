# STEP 1: setup environment
FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /api
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock
RUN bundle install
# STEP 2: setup application
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
# STEP 3: Run application
ENTRYPOINT ["rails", "server", "-b", "0.0.0.0"]