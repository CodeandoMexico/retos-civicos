FROM docker.io/ruby:2.7.7

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs

RUN useradd --system --create-home --user-group \
    --uid 900 --home-dir /var/lib/retos \
    --shell /bin/false \
    retos

RUN gem install bundler:2.4.3

USER retos
WORKDIR /var/lib/retos

COPY --chown=retos .bundle .bundle/
COPY --chown=retos Gemfile ./
COPY --chown=retos Gemfile.lock ./

RUN bundle install

COPY config ./config
COPY container/retos/database.yml ./config/database.yml
COPY config.ru ./
COPY db ./db
COPY lib ./lib
COPY public ./public
COPY Rakefile ./
COPY script ./script
COPY --chown=retos --chmod=755 container/initialize-and-start.sh ./
COPY app ./app

ENV RAILS_ENV=production

CMD ["./initialize-and-start.sh"]
