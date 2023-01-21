#!/bin/bash

set -e

export RAILS_ENV=production

bundle exec rake db:migrate

exec bundle exec unicorn -p 3000 -c ./config/unicorn.rb
