#!/bin/sh
docker image load -i $(nix-build -A container --no-out-link)
