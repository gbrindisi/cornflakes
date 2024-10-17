{ pkgs, lib, self }:

pkgs.writeShellScriptBin "help" ''
  echo "Available apps:"
  for package in ${lib.concatStringsSep " " (lib.attrNames self.apps)}; do
    echo "- $package"
  done
''