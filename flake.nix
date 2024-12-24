# {
#   description = "Jonny's dotfiles entrypoint";

#   inputs = {
#     flake-utils.url = "github:numtide/flake-utils";
#     home-manager = {
#       url = "github:nix-community/home-manager";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#     nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
#   };

#   outputs = { self, nixpkgs, flake-utils, home-manager }: flake-utils.lib.eachDefaultSystem (system:
#     let
#       pkgs = import nixpkgs { inherit system; };
#     in
#     {
#       homeConfigurations = {
#         common = home-manager.lib.homeManagerConfiguration {
#           inherit pkgs;
#           modules = [
#             {
#               home.packages = with pkgs; [
#                 google-cloud-sdk
#               ];
#             }
#           ];
#         };
#       };
#     });
# }


{
  description = "My Home Manager configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations = {
        common = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [{
            programs.home-manager.enable = true;

            home = {
              packages = with pkgs; [
                google-cloud-sdk
                hello
              ];

              username = "jlangefeld";
              homeDirectory = "/Users/jlangefeld";

              stateVersion = "24.11";

              activation = {
                postActivation = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                  current_user=$(${pkgs.google-cloud-sdk}/google-cloud-sdk/bin/gcloud auth list --filter=status:ACTIVE --format="value(account)")
                  if [ "$current_user" != "jonny.langefeld@gmail.com" ]; then
                    ${pkgs.google-cloud-sdk}/google-cloud-sdk/bin/gcloud auth login --no-launch-browser
                  fi
                  ${pkgs.google-cloud-sdk}/google-cloud-sdk/bin/gcloud secrets versions access latest --secret="foo" --project jonnylangefeld-dotfiles
                '';
              };

            };
          }];
        };
      };

      apps.${system} = {
        default = {
          type = "app";
          program = "${pkgs.home-manager}/bin/home-manager";
        };
      };
    };
}
