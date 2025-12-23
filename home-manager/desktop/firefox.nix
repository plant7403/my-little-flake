{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  /*
    !!!
    https://wiki.nixos.org/wiki/Cheatsheet
    !!!
  */

  imports = [ ./ffpwa.nix ];

  stylix.targets.librewolf = {
    enable = true;
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
    profileNames = [ "default" ];
  }; # !!! remove it from here !!!

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
    };
  };
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "es-ES"
      "en-US"
    ];
    nativeMessagingHosts =
      with pkgs;
      with inputs.firefox-addons.packages.${pkgs.system};
      [
        keepassxc-browser
      ];
    profiles.default = lib.mkForce {
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;

        "font.size.variable.x-western" = 20;
        "browser.toolbars.bookmarks.visibility" = "always";
        "privacy.resisttFingerprinting.letterboxing" = true;
        "network.http.referer.XOriginPolicy" = 2;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "gfx.webrender.software.opengl" = false;
        "webgl.disabled" = true;

        /*
          "font.size.variable.x-western" = 20;
          "browser.toolbars.bookmarks.visibility" = "always";
          "privacy.resisttFingerprinting.letterboxing" = true;
          "network.http.referer.XOriginPolicy" = 2;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "gfx.webrender.software.opengl" = false;
          "webgl.disabled" = true;
        */

        "privacy.clearOnShutdown_v2.cache" = 0;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = 0;
        #"extensions.activeThemeID" = "coffee_theme_firefox";
        "browser.theme.toolbar-theme" = 0;
        "privacy.resistFingerprinting.letterboxing" = false;
        "middlemouse.paste" = false;
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 20;
          newElementCount = 23;
          dirtyAreaCache = [
            "nav-bar"
            "unified-extensions-area"
            "PersonalToolbar"
            "TabsToolbar"
            "widget-overflow-fixed-list"
            "toolbar-menubar"
          ];
          seen = [
            "developer-button"
            "_0050e3fa-15cc-4fb6-9c73-7354489a810b_-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "_a138007c-5ff6-4d10-83d9-0afaf0efbe5e_-browser-action"
          ];
          placements = {
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "unified-extensions-button"
              "fxa-toolbar-menu-button"
            ];
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "alltabs-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            unified-extensions-area = [
              "ublock0_raymondhill_net-browser-action"
              "_0050e3fa-15cc-4fb6-9c73-7354489a810b_-browser-action"
              "_a138007c-5ff6-4d10-83d9-0afaf0efbe5e_-browser-action"
            ];
            widget-overflow-fixed-list = [
              "downloads-button"
              "developer-button"
              "firefox-view-button"
              "characterencoding-button"
            ];
          };
        };
        # Default to dark theme in DevTools panel
        "devtools.theme" = "dark";
        # Set browser to dark theme
        #"extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        # set default perefered color scheme to dark
        "layout.css.prefers-color-scheme.content-override" = 0;
        # Set browser font to Roboto
        "font.name.serif.x-western" = "Roboto";
        "font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
        "font.name.sans-serif.x-western" = "Noto Sans";
        # Fix dpi (I have a high res dispaly 1440p)
        "layout.css.devPixelsPerPx" = "1.2";
        # Enable ETP for decent security (makes librewolf containers and many
        # common security/privacy add-ons redundant).
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.purge_trackers.enabled" = true;
        # Your customized toolbar settings are stored in
        # 'browser.uiCustomization.state'. This tells librewolf to sync it between
        # machines. WARNING: This may not work across OSes. Since I use NixOS on
        # all the machines I use Librewolf on, this is no concern to me.
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        # Enable userContent.css and userChrome.css for our theme modules
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Stop creating ~/Downloads!
        #"browser.download.dir" = "${config.users.home}/Downloads";
        # Don't use the built-in password manager. A nixos user is more likely
        # using an external one (you are using one, right?).
        "signon.rememberSignons" = false;
        # Do not check if Librewolf is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        # Disable the "new tab page" feature and show a blank tab instead
        # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
        # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        # Disable Activity Stream
        # https://wiki.mozilla.org/Librewolf/Activity_Stream
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # Disable new tab tile ads & preload
        # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
        # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
        # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Reduce search engine noise in the urlbar's completion window. The
        # shortcuts and suggestions will still work, but Librewolf won't clutter
        # its UI with reminders that they exist.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # https://bugzilla.mozilla.org/1642623
        "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
        # https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" = true; # "Looks like you haven't started Librewolf in a while."
        "browser.onboarding.enabled" = false; # "New to Librewolf? Let's get started!" tour
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "reader.parse-on-load.enabled" = false; # "reader view"

        # Security-oriented defaults
        "security.family_safety.mode" = 0;
        # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
        "security.pki.sha1_enforcement_level" = 1;
        # https://github.com/tlswg/tls13-spec/issues/1001
        "security.tls.enable_0rtt_data" = false;
        # Use Mozilla geolocation service instead of Google if given permission
        "geo.provider.network.url" =
          "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.use_gpsd" = false;
        # https://support.mozilla.org/en-US/kb/extension-recommendations
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.getAddons.showPane" = false; # uses Google Analytics
        "browser.discovery.enabled" = false;
        # Reduce File IO / SSD abuse
        # Otherwise, Librewolf bombards the HD with writes. Not so nice for SSDs.
        # This forces it to write every 30 minutes, rather than 15 seconds.
        "browser.sessionstore.interval" = "1800000";
        # Disable battery API
        # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
        "dom.battery.enabled" = false;
        # Disable "beacon" asynchronous HTTP transfers (used for analytics)
        # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
        "beacon.enabled" = false;
        # Disable pinging URIs specified in HTML <a> ping= attributes
        # http://kb.mozillazine.org/Browser.send_pings
        "browser.send_pings" = false;
        # Disable gamepad API to prevent USB device enumeration
        # https://www.w3.org/TR/gamepad/
        # https://trac.torproject.org/projects/tor/ticket/13023
        "dom.gamepad.enabled" = false;
        # Don't try to guess domain names when entering an invalid domain name in URL bar
        # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
        "browser.fixup.alternate.enabled" = false;
        # Disable telemetry
        # https://wiki.mozilla.org/Platform/Features/Telemetry
        # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
        # https://wiki.mozilla.org/Telemetry
        # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
        # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
        # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
        # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
        # https://wiki.mozilla.org/Telemetry/Experiments
        # https://support.mozilla.org/en-US/questions/1197144
        # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        # https://mozilla.github.io/normandy/
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        # Disable health reports (basically more telemetry)
        # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
        # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        # Disable proxy
        "network.proxy.type" = 0;

        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports

        # Disable Form autofill
        # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;

        # Disable first run intro
        "app.normandy.first_run" = false;

        # Disable smooth scrolling (hate this feature on web browsers)
        "general.smoothScroll" = false;

        # Disable tailored performance settings and enable hw accel
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "layers.acceleration.disabled" = false;
        "layers.acceleration.force-enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        "media.ffmpeg.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "widget.dmabuf.force-enabled" = true;

        # Set homepage to selfhosted Bento and new tab to homepage
        #"browser.startup.homepage" = "https://start.server.com/";

        # Disable search suggestions
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;

        # Default permissions
        "permissions.default.geo" = 2;
        "permissions.default.camera" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.xr" = 2;

        # Disable middle click paste, just don't like the option
        #"middlemouse.paste" = false;

        # Enable ipv6
        "network.dns.disableIPv6" = false;

        # Set cookie behaviour
        "network.cookie.cookieBehavior" = 5;

        # Disable drm
        "media.eme.enabled" = false;

        # Other privacy focused settings
        "accessibility.force_disabled" = 1;
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.search.suggest.enabled" = false;
        "browser.search.update" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "places.history.enabled" = false;
        "privacy.history.custom" = true;
        "privacy.cpd.history" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "layout.spellcheckDefault" = 0;
        "dom.event.clipboardevents.enabled" = true; # without it copy and pasting in apps like Trilium doesn't work
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "network.http.sendRefererHeader" = 0; # Might break some sites such as WordPress
        "security.pki.crlite_mode" = 2; # advance ssl certificate check
        #"network.http.referer.XOriginPolicy" = 2; # send hostnames when there is a full match
        "privacy.clearOnShutdown.cache" = true; # clear cache on shutdown
        #"privacy.clearOnShutdown.history" = true;
        #"privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.sessions" = true;
        #"privacy.clearOnShutdown.cookies" = false; # don't clear so we stay logged in
        "privacy.clearOnShutdown.offlineApps" = false; # don't clear so we stay logged in
        "dom.push.enabled" = false; # I don't even know why you would want this.

        # Performance
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;

        # Mitigate fingerprinting
        "media.peerconnection.enabled " = false;
        "geo.enabled" = false;
        "privacy.firstparty.isolate" = true;
        "media.navigator.enabled" = false; # this block websites from getting your camera and mic status

        # Security
        "browser.download.always_ask_before_handling_new_types" = true; # chose with what to open new file types

        # Misc
        "dom.event.contextmenu.enabled" = false; # don't allow websites to mess with context menu
        "network.IDN_show_punycode" = true;
        "dom.security.https_only_mode_send_http_background_request" = false; # disable https timeout

        # For theme
        "gfx.webrender.all and svg.context-properties.content.enabled" = true;

        # Extensions
        "browser.policies.runOncePerModification.extensionsInstall" =
          "[\"https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi\"]";
      };
      /*
        userChrome = ''
          @-moz-document url(chrome://browser/content/browser.xul), url(chrome://browser/content/browser.xhtml) {
            #TabsToolbar {
              visibility: collapse !important;
              margin-bottom: 21px !important;
            }

            #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
              visibility: collapse !important;
            }
          }
        '';
      */
      userContent = ''
        /* Hide scrollbar in FF Quantum */
        *{scrollbar-width:none !important}
      '';
      #containersForce = true;
      extensions = {
        force = true;
        packages =
          with pkgs;
          with inputs.firefox-addons.packages.${pkgs.system};
          [
            darkreader
            ublock-origin
            libredirect
            keepassxc-browser
          ];
        settings = {
          "uBlock0@raymondhill.net".settings = {
            force = true;
            privateAllowed = true;
            settings = {
              force = true;
              selectedFilterLists = [
                "user-filters"
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-unbreak"
                "ublock-quick-fixes"
                "easylist"
                "easyprivacy"
                "urlhaus-1"
                "plowe-0"

                # Cookies
                "ublock-cookies-easylist"
                "adguard-cookies"
                "ublock-cookies-adguard"
                "fanboy-cookiemonster"

                # Social
                "fanboy-social"
                "adguard-social"
                "fanboy-thirdparty_social"

                # Don't like it
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                "easylist-annoyances"
                "adguard-other-annoyances"
                "adguard-popup-overlays"
                "adguard-widgets"
                "ublock-annoyances"
              ];
            };
            permissions = [
              "alarms"
              "dns"
              "menus"
              "privacy"
              "storage"
              "tabs"
              "unlimitedStorage"
              "webNavigation"
              "webRequest"
              "webRequestBlocking"
              "<all_urls>"
              "http://*/*"
              "https://*/*"
              "file://*/*"
              "https://easylist.to/*"
              "https://*.fanboy.co.nz/*"
              "https://filterlists.com/*"
              "https://forums.lanik.us/*"
              "https://github.com/*"
              "https://*.github.io/*"
              "https://github.com/uBlockOrigin/*"
              "https://ublockorigin.github.io/*"
              "https://*.reddit.com/r/uBlockOrigin/*"
            ];
          };
          "keepassxc-browser@keepassxc.org".settings = {
            force = true;
            settings = {
              force = true;
              "autoReconnect" = true;
              "afterFillSorting" = "sortByMatchingCredentials";
              "afterFillSortingTotp" = "sortByRelevantEntry";
              "autoCompleteUsernames" = true;
              "autoFillAndSend" = true;
              "autoFillSingleEntry" = true;
              "autoFillRelevantCredential" = true;
              "autoFillSingleTotp" = true;
              "autoRetrieveCredentials" = true;
              "autoSubmit" = false;
              "bannerPosition" = 1;
              "checkUpdateKeePassXC" = 0;
              "clearCredentialsTimeout" = 10;
              "colorTheme" = "system";
              "credentialSorting" = "sortByGroupAndTitle";
              "debugLogging" = false;
              "defaultGroup" = "";
              "defaultPasskeyGroup" = "";
              "defaultPasswordManager" = true;
              "defaultGroupAlwaysAsk" = false;
              "downloadFaviconAfterSave" = true;
              "passkeys" = true;
              "passkeysFallback" = true;
              "redirectAllowance" = 1;
              "saveDomainOnly" = true;
              "showGettingStartedGuideAlert" = true;
              "showGroupNameInAutocomplete" = true;
              "showLoginFormIcon" = true;
              "showLoginNotifications" = true;
              "showNotifications" = true;
              "showOTPIcon" = true;
              "showTroubleshootingGuideAlert" = true;
              "useCompactMode" = false;
              "useMonochromeToolbarIcon" = false;
              "useObserver" = true;
              "usePredefinedSites" = true;
              "usePasswordGeneratorIcons" = true;
              "sitePreferences" = [ ];
            };
          };
          "7esoorv3@alefvanoon.anonaddy.me".settings = {

            youtube = {
              enabled = false;
              redirectType = "main_frame";
              frontend = "invidious";
              embedFrontend = "invidious";
              unsupportedUrls = "bypass";
              redirectOnlyInIncognito = false;
            };
            invidious = [

            ];
            materialious = [
              "https://app.materialio.us"
            ];
            piped = [
              "https://pipedapi-libre.kavin.rocks"
            ];
            pipedMaterial = [
              "https://piped-material.xn--17b.net"
            ];
            poketube = [
              "https://poketube.fun"
            ];
            cloudtube = [
              "https://tube.cadence.moe"
            ];
            lightTube = [
              "https://tube.kuylar.dev"
            ];
            tuboYoutube = [
              "https://tubo.media"
            ];
            viewtube = [
              "https://viewtube.io"
            ];
            ytify = [
              "https://ytify.pp.ua"
            ];
            youtubeMusic = {
              enabled = false;
              frontend = "hyperpipe";
              unsupportedUrls = "bypass";
              redirectOnlyInIncognito = false;
            };
            hyperpipe = [
              "https://hyperpipe.surge.sh"
            ];
            invidiousMusic = [

            ];
            twitter = {
              enabled = false;
              redirectType = "main_frame";
              unsupportedUrls = "bypass";
              frontend = "nitter";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            nitter = [
              "https://nitter.privacydev.net"
            ];
            chatGpt = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "duckDuckGoAiChat";
              redirectOnlyInIncognito = false;
            };
            bluesky = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "skyview";
              redirectOnlyInIncognito = false;
            };
            skyview = [
              "https://skyview.social"
            ];
            reddit = {
              enabled = true;
              frontend = "redlib";
              unsupportedUrls = "bypass";
              instance = "public";
              redirectOnlyInIncognito = false;
              redirectType = "main_frame";
            };
            libreddit = [

            ];
            redlib = [
              "https://safereddit.com"
              "https://redlib.orangenet.cc"
              "https://redlib.privacyredirect.com"
            ];
            teddit = [

            ];
            eddrit = [
              "https://eddrit.com"
            ];
            tumblr = {
              enabled = false;
              redirectType = "main_frame";
              unsupportedUrls = "bypass";
              frontend = "priviblur";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            priviblur = [
              "https://pb.bloat.cat"
            ];
            twitch = {
              enabled = false;
              redirectType = "main_frame";
              unsupportedUrls = "bypass";
              frontend = "safetwitch";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            safetwitch = [
              "https://safetwitch.drgns.space"
            ];
            twineo = [
              "https://twineo.exozy.me"
            ];
            tiktok = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "proxiTok";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            proxiTok = [
              "https://proxitok.pabloferreiro.es"
            ];
            offtiktok = [
              "https://www.offtiktok.com"
            ];
            instagram = {
              enabled = false;
              frontend = "proxigram";
              unsupportedUrls = "bypass";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            proxigram = [
              "https://ig.opnxng.com"
            ];
            imdb = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "libremdb";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            libremdb = [
              "https://libremdb.iket.me"
            ];
            bilibili = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "mikuInvidious";
              redirectOnlyInIncognito = false;
            };
            mikuInvidious = [

            ];
            pixiv = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "pixivFe";
              redirectOnlyInIncognito = false;
            };
            pixivFe = [
              "https://pixiv.perennialte.ch"
            ];
            liteXiv = [
              "https://litexiv.465321.best"
              "https://litexiv.bloat.cat"
            ];
            vixipy = [
              "https://vx.maid.zone"
            ];
            pixivViewer = [
              "https://pixiv.pictures"
            ];
            fandom = {
              enabled = false;
              unsupportedUrls = "bypass";
              instance = "public";
              frontend = "breezeWiki";
              redirectOnlyInIncognito = false;
            };
            breezeWiki = [
              "https://breezewiki.com"
            ];
            imgur = {
              enabled = false;
              redirectType = "main_frame";
              unsupportedUrls = "bypass";
              frontend = "rimgo";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            rimgo = [
              "https://rimgo.vern.cc"
            ];
            pinterest = {
              enabled = false;
              unsupportedUrls = "bypass";
              redirectType = "main_frame";
              frontend = "binternet";
              redirectOnlyInIncognito = false;
            };
            binternet = [
              "https://bn.bloat.cat"
            ];
            painterest = [
              "https://pt.bloat.cat"
            ];
            soundcloud = {
              enabled = false;
              redirectType = "main_frame";
              frontend = "tuboSoundcloud";
              unsupportedUrls = "bypass";
              redirectOnlyInIncognito = false;
            };
            tuboSoundcloud = [
              "https://tubo.media"
            ];
            soundcloak = [
              "https://soundcloak.fly.dev"
            ];
            bandcamp = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "tent";
              redirectOnlyInIncognito = false;
            };
            tent = [
              "https://tent.sny.sh"
            ];
            tekstowo = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "tekstoLibre";
              redirectOnlyInIncognito = false;
            };
            tekstoLibre = [
              "https://davilarek.github.io/TekstoLibre"
            ];
            genius = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "dumb";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            dumb = [
              "https://dm.vern.cc"
            ];
            intellectual = [
              "https://intellectual.insprill.net"
            ];
            medium = {
              frontend = "scribe";
              enabled = false;
              unsupportedUrls = "bypass";
              redirectOnlyInIncognito = false;
            };
            scribe = [
              "https://scribe.rip"
            ];
            libMedium = [
              "https://md.vern.cc"
            ];
            small = [
              "https://small.bloat.cat"
            ];
            freedium = [
              "https://freedium.cfd"
            ];
            quora = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "quetre";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            quetre = [
              "https://quetre.iket.me"
            ];
            github = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "gothub";
              redirectOnlyInIncognito = false;
            };
            gothub = [

            ];
            gitlab = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "laboratory";
              redirectOnlyInIncognito = false;
            };
            laboratory = [
              "https://lab.vern.cc"
            ];
            stackOverflow = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "anonymousOverflow";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            anonymousOverflow = [
              "https://code.whatever.social"
            ];
            reuters = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "neuters";
              redirectOnlyInIncognito = false;
            };
            neuters = [
              "https://neuters.de"
            ];
            snopes = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "suds";
              redirectOnlyInIncognito = false;
            };
            suds = [
              "https://sd.vern.cc"
            ];
            ifunny = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "unfunny";
              redirectOnlyInIncognito = false;
            };
            unfunny = [
              "https://uf.vern.cc"
            ];
            tenor = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "soprano";
              redirectOnlyInIncognito = false;
            };
            soprano = [
              "https://sp.vern.cc"
            ];
            knowyourmeme = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "meme";
              redirectOnlyInIncognito = false;
            };
            meme = [
              "https://mm.vern.cc"
            ];
            urbanDictionary = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "ruralDictionary";
              redirectOnlyInIncognito = false;
            };
            ruralDictionary = [
              "https://rd.vern.cc"
            ];
            goodreads = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "biblioReads";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            biblioReads = [

            ];
            wolframAlpha = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "wolfreeAlpha";
              redirectOnlyInIncognito = false;
            };
            wolfreeAlpha = [

            ];
            instructables = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "structables";
              redirectOnlyInIncognito = false;
            };
            structables = [
              "https://structables.private.coffee"
            ];
            destructables = [
              "https://ds.vern.cc"
            ];
            indestructables = [
              "https://indestructables.private.coffee"
            ];
            wikipedia = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "wikiless";
              redirectOnlyInIncognito = false;
            };
            wikiless = [

            ];
            wikimore = [
              "https://wikimore.private.coffee"
            ];
            waybackMachine = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "waybackClassic";
              redirectOnlyInIncognito = false;
            };
            waybackClassic = [
              "https://wayback-classic.net"
            ];
            pastebin = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "pasted";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            pasted = [
              "https://pasted.drakeerv.com"
            ];
            search = {
              enabled = false;
              frontend = "searxng";
              unsupportedUrls = "bypass";
              redirectGoogle = false;
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            searxng = [
              "https://nyc1.sx.ggtyler.dev"
            ];
            searx = [

            ];
            whoogle = [

            ];
            librey = [

            ];
            "4get" = [
              "https://4get.ca"
            ];
            websurfx = [
              "https://alamin655-spacex.hf.space"
            ];
            translate = {
              enabled = false;
              frontend = "simplyTranslate";
              unsupportedUrls = "bypass";
              instance = "public";
              redirectOnlyInIncognito = false;
            };
            simplyTranslate = [
              "https://simplytranslate.org"
            ];
            mozhi = [
              "https://mozhi.aryak.me"
            ];
            libreTranslate = [
              "https://libretranslate.com"
            ];
            translite = [
              "https://tl.bloat.cat"
            ];
            maps = {
              redirectType = "main_frame";
              enabled = false;
              frontend = "osm";
              unsupportedUrls = "bypass";
              redirectOnlyInIncognito = false;
            };
            osm = [
              "https://www.openstreetmap.org"
            ];
            meet = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "jitsi";
              redirectOnlyInIncognito = false;
            };
            jitsi = [

            ];
            sendFiles = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "send";
              redirectOnlyInIncognito = false;
            };
            send = [

            ];
            textStorage = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "privateBin";
              redirectOnlyInIncognito = false;
            };
            privateBin = [

            ];
            pasty = [
              "https://pasty.lus.pm"
            ];
            office = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "cryptPad";
              redirectOnlyInIncognito = false;
            };
            cryptPad = [
              "https://cryptpad.org"
            ];
            ultimateGuitar = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "freetar";
              redirectOnlyInIncognito = false;
            };
            freetar = [
              "https://freetar.de"
            ];
            baiduTieba = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "ratAintTieba";
              redirectOnlyInIncognito = false;
            };
            ratAintTieba = [
              "https://rat.fis.land"
            ];
            threads = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "shoelace";
              redirectOnlyInIncognito = false;
            };
            shoelace = [
              "https://shoelace.mint.lgbt"
            ];
            deviantArt = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "skunkyArt";
              redirectOnlyInIncognito = false;
            };
            skunkyArt = [
              "https://skunky.bloat.cat"
            ];
            geeksForGeeks = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "nerdsForNerds";
              redirectOnlyInIncognito = false;
            };
            nerdsForNerds = [
              "https://nn.vern.cc"
            ];
            ducksForDucks = [
              "https://ducksforducks.private.coffee"
            ];
            coub = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "koub";
              redirectOnlyInIncognito = false;
            };
            koub = [
              "https://koub.clovius.club"
            ];
            chefkoch = {
              enabled = false;
              unsupportedUrls = "bypass";
              frontend = "gocook";
              redirectOnlyInIncognito = false;
            };
            gocook = [
              "https://cook.adminforge.de"
            ];
            exceptions = {
              url = [

              ];
              regex = [

              ];
            };
            theme = "detect";
            popupServices = [
              "youtube"
              "tiktok"
              "imgur"
              "reddit"
              "quora"
              "translate"
              "maps"
            ];
            fetchInstances = "github";
            redirectOnlyInIncognito = false;
            troddit = [
              "https://www.troddit.com"
            ];
            ultimateTab = [
              "https://ultimate-tab.com"
            ];
            version = "3.2.0";
          };
        };
      };
    };
    search = {
      force = true;
      default = "Startpage";
      privateDefault = "Startpage";
      order = [ "Startpage" ];
      engines = {
        "Startpage" = {
          urls = [ { template = "https://www.startpage.com/rvd/search?query={searchTerms}&language=auto"; } ];
          icon = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@s" ];
        };
        nix-packages = {
          name = "Nix Packages";
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        nixos-wiki = {
          name = "NixOS Wiki";
          urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
          iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
          definedAliases = [ "@nw" ];
        };

        home-manager = {
          name = "Home-Manager";
          urls = [
            { template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }
          ];
          iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
          definedAliases = [ "@hm" ];
        };

        nixpkgs-issues = {
          name = "nixpkgs-issues";
          urls = [
            {
              template = "https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue%20state%3Aopen%20{searchTerms}";
            }
          ];
          iconMapObj."16" = "https://github.com/favicon.ico";
          definedAliases = [ "@ni" ];
        };

        sourcegraph = {
          name = "sourcegraph";
          urls = [
            {
              template = "https://sourcegraph.com/search?q=context:global+file:%5C.nix+{searchTerms}&patternType=keyword&sm=0";
            }
          ];
          iconMapObj."16" = "https://sourcegraph.com/favicon.ico";
          definedAliases = [ "@sg" ];
        };

        bing.metaData.hidden = true;
        google.metaData.alias = "@g";
      };
    };
    bookmarks = [
      {
        name = "Nix sites";
        #force = true;
        toolbar = true;
        bookmarks = [
          {
            name = "homepage";
            url = "https://nixos.org/";
          }
          {
            name = "wiki";
            tags = [
              "wiki"
              "nix"
            ];
            url = "https://wiki.nixos.org/";
          }
          {
            name = "search";
            tags = [
              "search"
              "nix"
            ];
            url = "https://search.nixos.org/";
          }
          {
            name = "cheatsheet";
            tags = [
              "search"
              "nix"
            ];
            url = "https://wiki.nixos.org/wiki/Cheatsheet";
          }
        ];
      }
      {
        name = "Pak Unity";
        toolbar = true;
        bookmarks = [
          {
            name = "pak academy";
            url = "https://pak.academy/";
          }
          {
            name = "expat food";
            url = "https://expat.food/";
          }
        ];
      }
    ];

  };

}
