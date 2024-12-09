{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: {
    packages = {
      hello = nixpkgs.legacyPackages.${system}.hello;
    };

    defaultPackage = self.packages.${system}.hello;
  });
}
