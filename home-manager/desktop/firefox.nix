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

  stylix.targets.firefox = {
    enable = true;
    /*
      colorTheme.enable = true;
      firefoxGnomeTheme.enable = true;
    */
    profileNames = [ "default" ];
  };

  /*
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
    };
  */
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
        "accessibility.force_disabled" = 1;
        "accessibility.typeaheadfind.flashBar" = 0;
        "app.normandy.api_url" = "";
        "app.normandy.enabled" = false;
        "app.normandy.first_run" = false;
        "app.shield.optoutstudies.enabled" = false;
        "beacon.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "browser.contentblocking.category" = "strict";
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports
        "browser.disableResetPrompt" = true; # "Looks like you haven't started Librewolf in a while."
        "browser.discovery.enabled" = false;
        "browser.download.always_ask_before_handling_new_types" = true; # chose with what to open new file types
        "browser.fixup.alternate.enabled" = false;
        "browser.formfill.enable" = false;
        "browser.newtab.preload" = false;
        "browser.newtab.url" = "about:blank";
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        #"browser.newtabpage.enabled" = false;
        #"browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.onboarding.enabled" = false; # "New to Librewolf? Let's get started!" tour
        "browser.ping-centre.telemetry" = false;
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        #"browser.search.suggest.enabled" = false;
        "browser.search.update" = false;
        "browser.send_pings" = false;
        "browser.sessionstore.interval" = "1800000";
        "browser.shell.checkDefaultBrowser" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        #"browser.theme.toolbar-theme" = 0;
        #"browser.toolbars.bookmarks.visibility" = "always";
        "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        #"browser.urlbar.suggest.bookmark" = false;
        #"browser.urlbar.suggest.history" = false;
        #"browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        #"browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;
        #"browser.urlbar.trimURLs" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        #"devtools.theme" = "dark";
        "dom.battery.enabled" = false;
        "dom.event.clipboardevents.enabled" = true; # without it copy and pasting in apps like Trilium doesn't work
        "dom.event.contextmenu.enabled" = false; # don't allow websites to mess with context menu
        "dom.gamepad.enabled" = false;
        "dom.push.enabled" = false; # I don't even know why you would want this.
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_only_mode_send_http_background_request" = false; # disable https timeout
        "dom.security.https_only_mode" = true;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;
        "extensions.autoDisableScopes" = 0;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        "extensions.getAddons.showPane" = false; # uses Google Analytics
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
        # "font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
        # "font.name.sans-serif.x-western" = "Noto Sans";
        # "font.name.serif.x-western" = "Roboto";
        # "general.smoothScroll" = false;
        "geo.enabled" = false;
        "geo.provider.use_gpsd" = false;
        "gfx.webrender.all and svg.context-properties.content.enabled" = true;
        "gfx.webrender.software.opengl" = false;
        "gfx.x11-egl.force-enabled" = true;
        "layers.acceleration.disabled" = false;
        "layers.acceleration.force-enabled" = true;
        #"layout.css.devPixelsPerPx" = "1.2";
        "layout.css.prefers-color-scheme.content-override" = 0;
        "layout.spellcheckDefault" = 0;
        "media.eme.enabled" = false;
        "media.ffmpeg.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        # !!! "media.navigator.enabled" = false; # this block websites from getting your camera and mic status
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        # "media.peerconnection.enabled " = false;
        "media.rdd-ffmpeg.enabled" = true;
        "media.rdd-vpx.enabled" = false;
        "middlemouse.paste" = false;
        "network.cookie.cookieBehavior" = 5;
        "network.dns.disableIPv6" = false;
        "network.dns.disablePrefetch" = true;
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.sendRefererHeader" = 0; # Might break some sites such as WordPress
        "network.IDN_show_punycode" = true;
        "network.prefetch-next" = false;
        "network.proxy.type" = 0;
        "permissions.default.camera" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.xr" = 2;
        "places.history.enabled" = false;
        "privacy.clearOnShutdown_v2.cache" = 1;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = 1;
        "privacy.clearOnShutdown.cache" = true; # clear cache on shutdown
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.cpd.history" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.firstparty.isolate" = true;
        "privacy.history.custom" = true;
        "privacy.purge_trackers.enabled" = true;
        "privacy.resisttFingerprinting.letterboxing" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "reader.parse-on-load.enabled" = false; # "reader view"
        "security.family_safety.mode" = 0;
        "security.pki.crlite_mode" = 2; # advance ssl certificate check
        "security.pki.sha1_enforcement_level" = 1;
        "security.tls.enable_0rtt_data" = false;
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        "signon.rememberSignons" = false;
        "toolkit.coverage.endpoint.base" = "";
        "toolkit.coverage.opt-out" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.unified" = false;
        "webgl.disabled" = true;
        "widget.dmabuf.force-enabled" = true;

        "geo.provider.network.url" =
          "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        # Extensions
        "browser.policies.runOncePerModification.extensionsInstall" =
          "[\"https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi\", \"https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi\"]";

        /*
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
        */

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
            force = false;
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
              enabled = true;
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
              enabled = true;
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
              enabled = true;
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
              enabled = true;
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
              enabled = true;
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
              enabled = true;
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
              enabled = true;
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
              enabled = true;
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
              name = "git.pak.academy";
              url = "https://git.pak.academy/";
            }
            {
              name = "dash.pak.academy";
              url = "https://dash.pak.academy/";
            }
                        {
              name = "passwords.pak.academy";
              url = "https://passwords.pak.academy/";
            }
                        {
              name = "tasks.pak.academy";
              url = "https://git.pak.academy/";
            }
            {
              name = "expat food";
              url = "https://expat.food/";
            }
          ];
        }
      ];
    };
  };

}
