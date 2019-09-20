rec {
  pkgs = import ./nixpkgs {};

  nixos-icon = "${pkgs.nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png";

  indexHtml =
    pkgs.writeTextDir "index.html" ''
      <!doctype htm>
      <h1>Hello from Nix</h1>
      <img src="${nixos-icon}" alt="NixOS" />
      <h2>A Minimal docker image</h2>
    '';

  nginxConfig = pkgs.writeText "nginx.conf" ''
    daemon off;
    http {
      server 80;
      location / {
        root ${indexHtml}
      };
    }
  '';

  runNginx = pkgs.writeScriptBin "run-nginx" ''
    ${pkgs.nginx}/bin/nginx -c ${nginxConfig}
  '';

  nginxContainer = pkgs.dockerTools.buildLayeredImage {
    name = "nginx-container";
    config = {
      Cmd = [ runNginx ];
    };
  };

  redisConfig = pkgs.writeText "redis.conf" ''
    port 6379
  '';

  redisContainer = pkgs.dockerTools.buildLayeredImage {
    name = "redis-container";
    config = { 
      Cmd = [ "${pkgs.redis}/bin/redis-server" "${redisConfig}" ];
    };
  };
}
