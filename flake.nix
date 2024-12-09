{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultApp = {
          type = "app";
          program = "${pkgs.writeShellScript "print-string" ''
            echo "Hello from Nix!"
          ''}";
        };
      });
}
