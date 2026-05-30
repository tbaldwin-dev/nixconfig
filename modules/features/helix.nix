{
  self,
  ...
}:
{
  flake.homeModules.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.helix;
        defaultEditor = true;
      };
    };

  flake.wrappers.helix =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.helix ];
      runtimePkgs = [
        # Nix
        pkgs.nil
        pkgs.nixd

        # Python
        (pkgs.python3.withPackages (
          p: with p; [
            python-lsp-server
            python-lsp-ruff
          ]
        ))
        pkgs.pyright

        # Bash
        pkgs.bash-language-server

        # Markdown
        pkgs.marksman

        # Dockerfile
        pkgs.dockerfile-language-server

        # Yaml
        pkgs.yaml-language-server

        # C
        pkgs.clang-tools

        # Protobuf
        pkgs.buf

        # Java
        pkgs.jdt-language-server

        # Assembly
        pkgs.asm-lsp

        # Dot
        pkgs.dot-language-server

        # Rust
        pkgs.rust-analyzer
      ];

      settings = {
        editor.file-picker = {
          git-ignore = false;
          hidden = false;
        };
        theme = "dark_plus";
      };

      languages = {
        language = [
          {
            name = "python";
            language-servers = [
              "pyright"
              "pylsp"
            ];
          }
        ];

        language-server = {
          clangd.command = "clangd-unwrapped";
          pylsp.config.pylsp.plugins = {
            ruff.enabled = true;
            pylsp_mypy.enabled = true;
            pylsp_mypy.live_mode = true;
          };
        };
      };
    };
}
