#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

latestVersionAarch64="$(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-arm64/Packages \
    | sed -r -n 's/^Version: (.*)/\1/p' | head -n1)"
hashAarch64="$(nix hash to-sri --type sha256 \
    $(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-arm64/Packages \
    | sed -r -n 's/^SHA256: (.*)/\1/p' | head -n1)
)"

latestVersionAmd64="$(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-amd64/Packages \
    | sed -r -n 's/^Version: (.*)/\1/p' | head -n1)"
hashAmd64="$(nix hash to-sri --type sha256 \
    $(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-amd64/Packages \
    | sed -r -n 's/^SHA256: (.*)/\1/p' | head -n1)
)"

cat > $SCRIPT_DIR/default.nix << EOF
# Expression generated by update.sh; do not edit it by hand!
{ stdenv, callPackage, ... }@args:

callPackage ./make-brave.nix (removeAttrs args [ "callPackage" ])
  (
    if stdenv.hostPlatform.isAarch64 then
      rec {
        pname = "brave";
        version = "${latestVersionAarch64}";
        url = "https://github.com/brave/brave-browser/releases/download/v\${version}/brave-browser_\${version}_arm64.deb";
        hash = "${hashAarch64}";
        platform = "aarch64-linux";
      }
    else if stdenv.hostPlatform.isx86_64 then
      rec {
        pname = "brave";
        version = "${latestVersionAmd64}";
        url = "https://github.com/brave/brave-browser/releases/download/v\${version}/brave-browser_\${version}_amd64.deb";
        hash = "${hashAmd64}";
        platform = "x86_64-linux";
      }
    else
      throw "Unsupported platform."
  )
EOF
