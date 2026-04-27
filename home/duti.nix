{ pkgs, ... }:

let
  bundleId = "dev.zed.Zed";
  duti = "${pkgs.duti}/bin/duti";

  extensions = [
    "bash"
    "c"
    "cc"
    "conf"
    "cpp"
    "css"
    "csv"
    "cxx"
    "dockerfile"
    "dockerignore"
    "editorconfig"
    "env"
    "eslintrc"
    "gitignore"
    "go"
    "gql"
    "graphql"
    "h"
    "hpp"
    "ini"
    "java"
    "js"
    "json"
    "jsonc"
    "jsx"
    "just"
    "lock"
    "log"
    "md"
    "mdc"
    "mdx"
    "mjs"
    "mts"
    "nix"
    "php"
    "prisma"
    "proto"
    "py"
    "rb"
    "rs"
    "sass"
    "sh"
    "sol"
    "sql"
    "svg"
    "toml"
    "ts"
    "tsx"
    "txt"
    "xml"
    "yaml"
    "yml"
    "zsh"
  ];

  dutiCmds = builtins.concatStringsSep "\n" (
    map (ext: "${duti} -s ${bundleId} .${ext} all 2>/dev/null || true") extensions
  );
in
{
  home.activation.setFileAssociations = ''
    ${dutiCmds}
  '';
}
