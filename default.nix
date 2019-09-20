rec {
  pkgs = import ./nixpkgs {};

  userSetup = pkgs.runCommand "user-setup" { } ''
    mkdir -p $out/etc/
    echo "root:x:0:0:root user:/root:${pkgs.bash}/bin/bash" > $out/etc/passwd
    echo "nobody:x:65534:65534:nobody:/var/empty:${pkgs.bash}/bin/bash" >> $out/etc/passwd
    echo "root:x:0:" > $out/etc/group
    echo "nogroup:x:65534:" >> $out/etc/group
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

  nginxContainer = pkgs.dockerTools.buildLayeredImage {
    name = "nginx-container";
    contents = [ userSetup ];
    config = {
      Cmd = [ "${pkgs.nginx}/bin/nginx" "-c" "${nginxConfig}" ];
      ExposedPorts."80" = {};
    };
  };

  redisConfig = pkgs.writeText "redis.conf" ''
    port 6379
  '';

  redisContainer = pkgs.dockerTools.buildLayeredImage {
    name = "redis-container";
    config = {
      Cmd = [ "${pkgs.redis}/bin/redis-server" "${redisConfig}" ];
      ExposedPorts."6379" = {};
    };
  };
}
