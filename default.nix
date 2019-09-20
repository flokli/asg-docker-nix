rec {
  # pin a specific nixpgks checkout
  pkgs = import (fetchTarball rec {
    sha256 = "1hz2qrqzzfk41hhsiakailhl830a4q01xw9gr9ffql020qcq6ms0";
    url = "https://github.com/flokli/nixpkgs/archive/b5650cd1c50dff382b2995e569235ecc6a3eaa89.tar.gz";
  }) {};

  etcPasswd = pkgs.writeTextDir "etc/passwd" ''
    root:x:0:0:root user:/root:${pkgs.bash}/bin/bash
    nobody:x:65534:65534:nobody:/var/empty:${pkgs.bash}/bin/bash
  '';

  etcGroup = pkgs.writeTextDir "etc/group" ''
    root:x:0:
    nogroup:x:65534:
  '';

  indexHtml =
    pkgs.writeTextDir "index.html" ''
      <!doctype htm>
      <h1>Hello from Nix</h1>
      <img src="/img.png" alt="NixOS" />
      <h2>A Minimal docker image</h2>
    '';

  nginxConfig = pkgs.writeText "nginx.conf" ''
    daemon off;

    events { worker_connections 1024; }
    http {
      server {
        listen 80;
        location /img.png {
          alias ${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png;
        }
        location / {
          root ${indexHtml};
        }
      }
    }
  '';

  redisConfig = pkgs.writeText "redis.conf" ''
    port 6379
  '';

  nginxContainer = pkgs.dockerTools.buildLayeredImage {
    name = "nginx-container";
    contents = [ etcPasswd etcGroup ];
    config = {
      Cmd = [ "${pkgs.nginx}/bin/nginx" "-c" "${nginxConfig}" ];
      ExposedPorts."80" = {};
    };
  };

  redisContainer = pkgs.dockerTools.buildLayeredImage {
    name = "redis-container";
    config = {
      Cmd = [ "${pkgs.redis}/bin/redis-server" "${redisConfig}" ];
      ExposedPorts."6379" = {};
    };
  };
}
