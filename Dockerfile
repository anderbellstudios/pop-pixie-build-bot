FROM ruby:3.1.2-alpine

RUN apk add --no-cache --update unzip

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN echo "WARNING: This image is intended for development purposes only. Do not use it in production." >&2
CMD ["bundle", "exec", "rake", "test"]
