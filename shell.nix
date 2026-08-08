{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "37" "36" ];
    buildToolsVersions = [ "36.0.0" "35.0.0" ];
    cmakeVersions = [ "3.31.6" ];
    includeEmulator = false;
    includeNDK = true;
    includeSystemImages = false;
  };
in
pkgs.mkShell {
  name = "pebble2-build";

  packages = with pkgs; [
    androidSdk.androidsdk
    jdk17
    gradle
    git
    zlib
    patchelf
    which
  ];

  shellHook = ''
    export ANDROID_HOME="${androidSdk.androidsdk}/libexec/android-sdk"
    export JAVA_HOME="${pkgs.jdk17}/lib/openjdk"
    export GRADLE_OPTS="-Dorg.gradle.jvmargs=-Xmx12g"
    export NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE=1
  '';
}
