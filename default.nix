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

  container = pkgs.dockerTools.buildLayeredImage {
    name = "nginx-container";
    config = {
      Cmd = [ runNginx ];
    };
  };
}
