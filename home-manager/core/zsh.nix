{
  pkgs,
  config,
  lib,
  ...
}:

let
  theme = builtins.fromTOML (builtins.readFile ./pastel.toml);
in

{
  home.file."${config.xdg.cacheHome}/oh-my-zsh/.keep".text = "";

  home.persistence."/persist/home/egor" = {
    directories = [
      ".cache/oh-my-zsh"
      # ".cache/nix-index"
    ];
    files = [
      ".config/zsh/.zsh_history"
      ".zsh_history"
    ];
  };

  home.packages = with pkgs; [
    mosh
    tmux
    zsh-bd
    fzf
    autojump
    sqlite-interactive
  ];

  home.shell = {
    enableZshIntegration = true;
  };
  programs = {
    /*
      nix-index = {
         enable = true;
         enableZshIntegration = true;
       };
    */
    zsh = {
      enable = true;
      #autocd = true;
      envExtra = ''
        umask 077
      '';
      dotDir = "${config.xdg.configHome}/zsh";
      #autosuggestion.enable = true;
      #enableCompletion = true;
      #enableVteIntegration = true;
      #syntaxHighlighting.enable = true;
      /*
        extraConfig = ''
             $env.config.hooks.command_not_found = source ${pkgs.nix-index}/etc/profile.d/command-not-found.zsh
           '';
      */
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          #POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
          #source ~/.p10k.zsh



          # Powerlevel10k Zsh theme  
          #source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme  
          #test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh 


          HISTDB_FILE=''${XDG_DATA_HOME-$HOME/.local/share}/zsh/history.db

          # Do this early so fast-syntax-highlighting can wrap and override this
          if autoload history-search-end; then
            zle -N history-beginning-search-backward-end history-search-end
            zle -N history-beginning-search-forward-end  history-search-end
          fi
          autoload -Uz compinit && compinit
          autoload -U colors && colors
          alias ls='ls -G'

          # history
          setopt share_history
          bindkey '^[[A' history-beginning-search-backward
          bindkey '^[[B' history-beginning-search-forward

          # globbing
          setopt extended_glob

          # zmv
          autoload -Uz zmv
          alias zcp='zmv -C'
          alias zln='zmv -L'

          # fewer keystrokes
          setopt auto_cd auto_pushd
          setopt menu_complete

          # fewer distractions
          unsetopt beep nomatch notify

          eval "$(starship init zsh)"
        '')
      ];

      history = {
        path = "\${XDG_DATA_HOME-$HOME/.local/share}/zsh/history";
        save = 1000500;
        size = 1000000;
        ignoreAllDups = true;
      };
      history.ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ];

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          #{
          #  name = "romkatv/powerlevel10k";
          #  tags = [
          #    "as:theme"
          #    "depth:1"
          #  ];
          #} # Installations with additional options. For the list of options, please refer to Zplug README.
          #{ name = "powerlevel10k-config"; }
          { name = "autojump"; }
          { name = "git"; }
          { name = "colored-man-pages"; }
          { name = "woefe/wbase.zsh"; }
          { name = "junegunn/fzf"; }
          { name = "junegunn/fzf-bin"; }
          {
            name = "sharkdp/fd";
            tags = [
              "from:gh-r"
              "as:command"
              "rename-to:fd" # "use"="*x86_64-unknown-linux-gnu.tar.gz"
            ];
          }
          { name = "zsh-users/zsh-completions"; }
          {
            name = "zsh-users/zsh-autosuggestions";
            tags = [ "depth:1" ];
          }
          { name = "zsh-users/history"; }
          {
            name = " zsh-users/zsh-syntax-highlighting ";
            tags = [
              "defer:2"
              "depth:1"
            ];
          }
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = [ "defer:3" ];
          }
          {
            name = "axieax/zsh-starship";
            /*
              tags = [
                "as:theme"
                "depth:1"
              ];
            */
          }
        ];
      };

      /*
        completionInit = ''

           '';
      */

    };
  };

  /*
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  */
  #programs.starship.configPath

  programs.starship.enableInteractive = true;
  programs.starship.enableTransience = true;
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    "$schema" = "https://starship.rs/config-schema.json";

format = """
[](#9A348E)\
$os\
$username\
[](bg:#DA627D fg:#9A348E)\
$directory\
[](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
[](fg:#86BBD8 bg:#06969A)\
$docker_context\
[](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
""";

# Disable the blank line at the start of the prompt
# add_newline = false

# You can also replace your username with a neat symbol like   or disable this
# and use the os module below
username ={
show_always = true;
style_user = "bg:#9A348E";
style_root = "bg:#9A348E";
format = "[$user ]($style)";
disabled = false;
};

# An alternative to the username module which displays a symbol that
# represents the current operating system
os = {
style = "bg:#9A348E";
disabled = true; # Disabled by default
};

directory = {
style = "bg:#DA627D";
format = "[ $path ]($style)";
truncation_length = 3;
truncation_symbol = "…/";
};

# Here is how you can shorten some long paths by text replacement
# similar to mapped_locations in Oh My Posh:
directory.substitutions = {
"Documents" = "󰈙 ";
"Downloads" = " ";
"Music" = " ";
"Pictures" = " ";};
# Keep in mind that the order matters. For example:
# "Important Documents" = " 󰈙 "
# will not be replaced, because "Documents" was already substituted before.
# So either put "Important Documents" before "Documents" or use the substituted version:
# "Important 󰈙 " = " 󰈙 "

c = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};
cpp = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

docker_context = {
symbol = " ";
style = "bg:#06969A";
format = "[ $symbol $context ]($style)";
};

elixir = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};
elm = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
}
git_branch = {
symbol = "";
style = "bg:#FCA17D";
format = "[ $symbol $branch ]($style)";
};
git_status = {
style = "bg:#FCA17D";
format = "[$all_status$ahead_behind ]($style)";
};
golang = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};
gradle = {
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)";
};
haskell = {
symbol = " "
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
java = {
symbol = " "
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
julia = {
symbol = " "
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
nodejs = {
symbol = ""
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
nim = {
symbol = "󰆥 "
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
rust = {
symbol = ""
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
scala = {
symbol = " "
style = "bg:#86BBD8"
format = "[ $symbol ($version) ]($style)"
};
time = {
disabled = false
time_format = "%R" # Hour:Minute Format
style = "bg:#33658A"
format = "[ ♥ $time ]($style)"
}
  };
}
