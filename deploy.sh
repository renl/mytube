mix deps.get --only prod
MIX_ENV=prod mix compile

cd assets
node node_modules/brunch/bin/brunch build --production
cd ..

mix phx.digest

# Custom tasks (like DB migrations)
MIX_ENV=prod mix ecto.migrate

# Finally run the server
PORT=4001 MIX_ENV=prod elixir --detached -S mix phx.server
