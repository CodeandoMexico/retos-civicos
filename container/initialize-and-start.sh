#!/bin/bash

set -e

echo "Initializing"

echo -e "\nMigrate db ----------------------------------------------------------\n"
bundle exec rake db:migrate

echo -e "\nPrecompile assets ---------------------------------------------------\n"
bundle exec rake assets:precompile

echo -e "\nRun server ----------------------------------------------------------\n"
exec bundle exec unicorn -p 3000 -c ./config/unicorn.rb
