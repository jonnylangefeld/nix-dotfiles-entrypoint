{
  description = "Example flake that prints output";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      defaultApp = {
        type = "app";
        program = "${pkgs.runtimeShell} -c 'echo Hello, World!'";
      };
    });
}
