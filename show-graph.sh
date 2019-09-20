#!/bin/sh
nix-store --query --graph  $(nix-build -A runNginx)  | dot -Tx11
