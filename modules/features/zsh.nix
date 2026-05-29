{ inputs, ... }:
{
  flake.homeModules.zsh =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "xiong-chiamiov";
          plugins = [
            "colorize"
            "docker"
            "colored-man-pages"
          ];
          extraConfig = ''
            # Autosuggestion config required for zsh-helix-mode
            ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
              zhm_history_prev
              zhm_history_next
              zhm_prompt_accept
              zhm_accept
              zhm_accept_or_insert_newline
            )
            ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
              zhm_move_right
              zhm_clear_selection_move_right
            )
            ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
              zhm_move_next_word_start
              zhm_move_next_word_end
            )
          '';
        };
        plugins = [
          {
            name = "zsh-helix-mode";
            src = inputs.zsh-helix-mode.packages.${pkgs.stdenv.system}.zsh-helix-mode;
            file = "share/zsh-helix-mode/zsh-helix-mode.plugin.zsh";
          }
        ];
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
}
