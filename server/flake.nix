{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    gradle2nix = {
      url = "github:tnichols217/gradle2nix/v2";
      inputs.nixpkgs.follows = "nixpkgs";
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
      androidSdk = pkgs.androidenv.androidPkgs.androidsdk;
    in 
    {
      packages = rec {
        scrcpy = inputs.gradle2nix.builders.${system}.buildGradlePackage {
          pname = "scrcpy";
          version = "1.0";
          src = ./.;
          lockFile = ./gradle.lock;
          extraGradleFlags = [ "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2" ];
          # gradleInstallFlags = [ "installDist" ];
        };
        default = scrcpy;
      };
      devShells = rec {
        gradle = pkgs.callPackage ./shell.nix {};
        default = gradle;
      };
    });
}