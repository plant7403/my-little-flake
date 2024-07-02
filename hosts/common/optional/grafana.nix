{
  config,
  pkgs,
  ...
}: {
  # MONITORING: services run on loopback interface
  #             nginx reverse proxy exposes services to network
  #             - grafana:3010
  #             - prometheus:3020
  #             - loki:3030
  #             - promtail:3031

  # prometheus: port 3020 (8020)
  #
  services.prometheus = {
    port = 3020;
    enable = true;

    exporters = {
      node = {
        port = 3021;
        enabledCollectors = ["systemd"];
        enable = true;
      };
      graphite.enable = true;
    };

    # ingest the published nodes
    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
    ];
  };

  # loki: port 3030 (8030)
  #
  services.loki = {
    enable = true;
    configuration = {
      # Basic stuff
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
        log_level = "warn";
      };
      common = {
        path_prefix = config.services.loki.dataDir;
        storage.filesystem = {
          chunks_directory = "${config.services.loki.dataDir}/chunks";
          rules_directory = "${config.services.loki.dataDir}/rules";
        };
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
        ring.instance_addr = "127.0.0.1";
      };

      ingester.chunk_encoding = "snappy";

      limits_config = {
        retention_period = "120h";
        ingestion_burst_size_mb = 16;
        reject_old_samples = true;
        reject_old_samples_max_age = "12h";
      };

      table_manager = {
        retention_deletes_enabled = true;
        retention_period = "120h";
      };

      compactor = {
        retention_enabled = true;
        compaction_interval = "10m";
        working_directory = "${config.services.loki.dataDir}/compactor";
        delete_request_cancel_period = "10m"; # don't wait 24h before processing the delete_request
        retention_delete_delay = "2h";
        retention_delete_worker_count = 150;
        delete_request_store = "filesystem";
      };

      schema_config.configs = [
        {
          from = "2020-11-08";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index.prefix = "index_";
          index.period = "24h";
        }
      ];

      ruler = {
        storage = {
          type = "local";
          local.directory = "${config.services.loki.dataDir}/ruler";
        };
        rule_path = "${config.services.loki.dataDir}/rules";
        alertmanager_url = "http://alertmanager.r";
      };

      query_range.cache_results = true;
      limits_config.split_queries_by_interval = "24h";
    };
  };

  # promtail: port 3031 (8031)
  #
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "immortal";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];
    };
    # extraFlags
  };

  # grafana: port 3010 (8010)
  #
  services.grafana = {
    enable = true;
    settings.analytics.reporting_enabled = false;
    settings.server = {
      http_port = 3010;
      root_url = "http://192.168.1.100:8010"; # helps with nginx / ws / live
      protocol = "http";
      http_addr = "127.0.0.1";
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];
    };
  };

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    # recommendedTlsSettings = true;

    upstreams = {
      "grafana" = {
        servers = {
          "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = {};
        };
      };
      "prometheus" = {
        servers = {
          "127.0.0.1:${toString config.services.prometheus.port}" = {};
        };
      };
      "loki" = {
        servers = {
          "127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}" = {};
        };
      };
      "promtail" = {
        servers = {
          "127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}" = {};
        };
      };
    };

    virtualHosts.grafana = {
      locations."/" = {
        proxyPass = "http://grafana";
        proxyWebsockets = true;
      };
      listen = [
        {
          addr = "192.168.1.100";
          port = 8010;
        }
      ];
    };

    virtualHosts.prometheus = {
      locations."/".proxyPass = "http://prometheus";
      listen = [
        {
          addr = "192.168.1.100";
          port = 8020;
        }
      ];
    };

    # confirm with http://192.168.1.100:8030/loki/api/v1/status/buildinfo
    #     (or)     /config /metrics /ready
    virtualHosts.loki = {
      locations."/".proxyPass = "http://loki";
      listen = [
        {
          addr = "192.168.1.100";
          port = 8030;
        }
      ];
    };

    virtualHosts.promtail = {
      locations."/".proxyPass = "http://promtail";
      listen = [
        {
          addr = "192.168.1.100";
          port = 8031;
        }
      ];
    };
  };
  services.nginx.virtualHosts."graf.egor.wtf" = {
    forceSSL = true;
    useACMEHost = "egor.wtf";
    extraConfig = ''
      ${builtins.readFile ./nginx/authelia/vh.conf}
    '';
    locations."/" = {
      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        ${builtins.readFile ./nginx/authelia/locations.conf}
      '';
    };
  };
  environment.persistence."/persist".directories = [
    "/var/lib/grafana"
    "/var/lib/prometheus2"
  ];
}
