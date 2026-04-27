{ lib, ... }:

let
  # Namespace = command that gets wrapped.
  # Add secrets here; rebuild + `secrets-sync` to apply.
  opAccount = "my.1password.com";

  secrets = {
    opencode = {
      CONTEXT7_API_KEY = "op://Private/Context7 API/credential";
    };
  };

  keychain = ns: var: "secrets/${ns}/${var}";

  mkSyncFunction =
    let
      entries = lib.concatStringsSep " \\\n      " (
        lib.concatLists (
          lib.mapAttrsToList (
            ns: vars:
            lib.mapAttrsToList (var: ref: ''"${keychain ns var} ${ref}"'') vars
          ) secrets
        )
      );
    in
    ''
      set -l entries \
        ${entries}

      set -l synced 0
      for entry in $entries
        set -l parts (string split -m1 " " -- $entry)
        set -l svc $parts[1]
        set -l ref $parts[2]

        set -l val (op read --account ${opAccount} $ref 2>/dev/null)
        if test $status -ne 0
          echo "Failed: $svc" >&2
          continue
        end

        security delete-generic-password -s $svc 2>/dev/null
        security add-generic-password -s $svc -a $svc -w "$val"
        set synced (math $synced + 1)
      end
      echo "Synced $synced secrets"
    '';

  mkWrapper = name: vars:
    let
      exports = lib.concatMapStringsSep "\n  " (
        var:
        ''set -lx ${var} (security find-generic-password -s "${keychain name var}" -w 2>/dev/null)''
      ) (builtins.attrNames vars);
    in
    ''
      ${exports}
      command ${name} $argv
    '';

  wrappers = lib.mapAttrs mkWrapper secrets;
in
{
  programs.fish.functions = { secrets-sync = mkSyncFunction; } // wrappers;
}
