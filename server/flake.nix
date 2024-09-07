{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = import nixpkgs {inherit system;};
    in 
    {
      devShells = rec {
        gradle = pkgs.callPackage ./shell.nix {};
        default = gradle;
      };
    });
}