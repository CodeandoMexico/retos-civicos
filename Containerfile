FROM docker.io/ruby:2.7.7

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs

ENV RETOS_HOME=/var/lib/retos
ENV RAILS_ENV=production

RUN useradd --system --create-home --user-group \
    --uid 900 --home-dir $RETOS_HOME \
    --shell /bin/false \
    retos

RUN gem install bundler:2.4.3

USER retos
WORKDIR $RETOS_HOME

COPY --chown=retos .bundle .bundle/
COPY --chown=retos Gemfile ./
COPY --chown=retos Gemfile.lock ./

RUN bundle install

COPY config.ru ./
COPY db ./db
COPY lib ./lib
COPY --chown=retos public ./public
COPY Rakefile ./
COPY script ./script
COPY vendor/assets vendor/assets
COPY --chown=retos --chmod=755 container/initialize-and-start.sh ./
COPY config ./config
COPY app ./app

# Ugly patches that make things work
COPY container/retos/patch/forbidden_attributes_protection.rb vendor/bundle/ruby/2.7.0/gems/activemodel-5.0.7.2/lib/active_model/forbidden_attributes_protection.rb

CMD ["./initialize-and-start.sh"]
