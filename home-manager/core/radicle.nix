{
  programs = {
    radicle.enable = true;
    radicle.settings.node.alias = "stellar";
    radicle.settings.node.listen = [ "127.0.0.1:58776" ];
    #programs.radicle.settings.publicExplorer
    radicle.uri.rad.browser.enable = true;
    #programs.radicle.uri.rad.browser.preferredNode
    #radicle.uri.rad.vscode.enable = true;
    #programs.radicle.uri.rad.vscode.extension
    radicle.uri.web-rad.browser = "librewolf.desktop";
    radicle.uri.web-rad.enable = true;
  };
  services.radicle = {
    #services.radicle.node.args
    node.enable = true;
    /*
      node.environment = {
        RUST_BACKTRACE = "full";
      };
    */
    node.lazy.enable = true;
    node.lazy.exitIdleTime = "30min";
  };

}
