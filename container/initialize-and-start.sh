#!/bin/bash

set -e

echo "Initializing"

echo "Migrate db --------------------------------------------------------------"
bundle exec rake db:migrate
echo "Precompile assets -------------------------------------------------------"
bundle exec rake assets:precompile

echo "Run server --------------------------------------------------------------"
exec bundle exec unicorn -p 3000 -c ./config/unicorn.rb
