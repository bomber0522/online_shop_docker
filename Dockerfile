FROM ruby:2.5.1-alpine

ENV RUNTIME_PACKAGES="vim linux-headers libxml2-dev libxslt-dev make gcc libc-dev nodejs tzdata postgresql-dev postgresql" \
    DEV_PACKAGES="build-base curl-dev" \
    HOME="/online_shop_docker"

WORKDIR $HOME

ADD Gemfile      $HOME/Gemfile
ADD Gemfile.lock $HOME/Gemfile.lock

RUN apk update && \
    apk upgrade

RUN apk add --update --no-cache $RUNTIME_PACKAGES && \
    apk add --update --virtual build-dependencies --no-cache $DEV_PACKAGES && \
    bundle install -j4 && \
    apk del build-dependencies

ADD . $HOME

CMD ["rails", "server", "-b", "0.0.0.0"]