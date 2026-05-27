{
  ...
}:
{
  flake.homeModules.git =
    {
      ...
    }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user = {
            name = "Trent Baldwin";
            email = "trent.baldwin@proton.me";
            signingkey = "~/.ssh/id_rsa.pub";
          };
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
          commit.gpgsign = true;
          tag.gpgSign = true;
          column.ui = "auto";
          branch.sort = "committerdate";
        };
      };

      programs.difftastic = {
        enable = true;
        git = {
          enable = true;
          diffToolMode = true;
        };
      };
    };
}
