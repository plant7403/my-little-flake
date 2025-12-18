{ pkgs, ... }:
{
  programs.chromium.commandLineArgs = [
    "--enable-logging=stderr"
    "--ignore-gpu-blocklist"
  ];
  programs.chromium.dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
  programs.chromium.enable = true;
  /*
    programs.chromium.extensions.*.crxPath
    programs.chromium.extensions.*.id
    programs.chromium.extensions.*.updateUrl
    programs.chromium.extensions.*.version
  */
  #programs.chromium.finalPackage = pkgs.ungoogled-chromium;
  #programs.chromium.nativeMessagingHosts
  programs.chromium.package = pkgs.ungoogled-chromium;
}
