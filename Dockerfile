FROM ruby:1.9
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev postgresql-client
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . .
