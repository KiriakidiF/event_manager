#!/bin/bash

export MIX_ENV=prod
export PORT=4796

CFGD=$(readlink -f ~/.config/event_manager)

if [ ! -e "$CFGD/base" ]; then
    echo "run deploy first"
    exit 1
fi

DB_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://event_manager:$DB_PASS@localhost/event_manager_prod

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

_build/prod/rel/event_manager/bin/event_manager start