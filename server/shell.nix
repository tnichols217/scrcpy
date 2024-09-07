{ pkgs ? import <nixpkgs> {config.android_sdk.accept_license = true;}, androidSdk ? pkgs.androidenv.androidPkgs.androidsdk }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    androidSdk
    glibc
    gradle
  ];

  ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  # override the aapt2 that gradle uses with the nix-shipped version
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
}