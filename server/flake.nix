{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
    let 
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
      pkgs = import inputs.nixpkgs {inherit system config;};
    in 
    {
      devShells = rec {
        gradle = pkgs.callPackage ./shell.nix {};
        default = gradle;
      };
    });
}