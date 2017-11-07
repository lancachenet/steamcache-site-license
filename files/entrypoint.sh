#!/bin/bash

sed -i 's/STEAM_CACHE_SIZE_GB/'"$STEAM_CACHE_SIZE_GB"'/g' steamconsole.cfg
exec "$@"