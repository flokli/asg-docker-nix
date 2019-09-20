with import <nixpkgs> {};
pkgs.mkShell {
  name = "shell";
  buildInputs = with pkgs; [
    graphviz
    python3.pkgs.xdot
    gnumake
    dive
  ];
}
