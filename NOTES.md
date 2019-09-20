 - Dockerfiles are a sequence of commands that build things inside containers
 - Intermediate build products and toolchain might end up in your container images
 - Also, by inheriting from a distro image, a lot of things that aren't used end up in there too
 - Versioning is hard, can you checkout a commit from 1 year ago, and use your Dockerfile to build the same image with the same versions of dependencies?
 - Layers per command in a Dockerfile are a bad approximation of sharing and caching
 - What if put something else inside those layers?

 - Enter Nix(pkgs), a collection of packages maintained by the NixOS community

 - We can use those recipies to compose our own images, only containing the exact runtime dependencies of the application we want to ship. Everything in these recipies is built in a sandboxed, offline environment, everything is pinned by hashes

  - DEMO: Show default.nix, show build graphs + reuse of glibc, dive into the image
  - Talk by Franz Pletz tomorrow afternoon, "Purely functional package management"
