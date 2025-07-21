{ ... }: {
  programs.git = {
    enable = true;
    config = {
      mergetool = {
        tool = "vimdiff";
	keepBackup = false;
      };
    };
  };
}
