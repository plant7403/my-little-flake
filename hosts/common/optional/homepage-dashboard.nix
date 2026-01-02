_:
{
  services.homepage-dashboard = {
    enable = true;
    services = [
      {
        "My First Group" = [
          {
            "My First Service" = {
              description = "Homepage is awesome";
              href = "http://localhost/";
            };
          }
        ];
      }
      {
        "My Second Group" = [
          {
            "My Second Service" = {
              description = "Homepage is the best";
              href = "http://localhost/";
            };
          }
        ];
        widgets = [
          {
            resources = {
              cpu = true;
              disk = "/";
              memory = true;
            };
          }
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
        ];
        bookmarks = [
          {
            Developer = [
              {
                Github = [
                  {
                    abbr = "GH";
                    href = "https://github.com/";
                  }
                ];
              }
            ];
          }
          {
            Entertainment = [
              {
                YouTube = [
                  {
                    abbr = "YT";
                    href = "https://youtube.com/";
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
    settings = {
      title = "My Awesome Homepage";
      startUrl = "https://dash.egor.wtf";
      background = "https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80";
    };
  };
  modules.web.vhosts = [
    {
      domain = "egor.wtf";
      prefix = "dash";
      upstream = "http://127.0.0.1:8082";
      tor.enable = true;
      tor.authelia = false;
    }
  ];
}
