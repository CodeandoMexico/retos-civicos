#!/bin/bash

set -e

echo "Initializing"

echo "\nMigrate db ----------------------------------------------------------\n"
bundle exec rake db:migrate

echo "\nPrecompile assets ---------------------------------------------------\n"
bundle exec rake assets:precompile

echo "\nRun server ----------------------------------------------------------\n"
exec bundle exec unicorn -p 3000 -c ./config/unicorn.rb
