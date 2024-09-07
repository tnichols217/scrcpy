{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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