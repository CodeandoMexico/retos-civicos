FROM docker.io/ruby:2.7.7

RUN useradd --system --create-home --user-group \
    --uid 900 --home-dir /app \
    --shell /bin/false \
    retos

USER retos

COPY Gemfile ./
COPY Gemfile.lock ./
COPY app ./
COPY config ./
COPY config.ru ./
COPY db ./
COPY lib ./
COPY Procfile ./
COPY public ./
COPY Rakefile ./
COPY script ./

RUN bundle install
