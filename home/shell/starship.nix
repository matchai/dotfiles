{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      format = "$battery$username$hostname$directory$git_branch$git_status$git_state$cmd_duration$line_break$character";

      directory.read_only = " ";
      battery = {
        full_symbol = "•";
        charging_symbol = "⇡";
        discharging_symbol = "⇣";
      };
      git_branch = {
        format = "([$branch]($style) )";
        style = "bright-black";
      };
      git_status = {
        format = "([[(*$conflicted$untracked$modified$staged$renamed$deleted)](bright-black)($ahead_behind$stashed)]($style) )";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style) )";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };
}
