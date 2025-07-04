with import <nixpkgs> {}; let
  basePackages = [
    sqlite
    nodejs_20
    beam26Packages.erlang
    beam26Packages.elixir_1_16
    beam26Packages.elixir-ls
    fswatch
    direnv
    nix-direnv
    claude-code
  ];

  PROJECT_ROOT = builtins.toString ./.;

  hooks = ''


    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=${PROJECT_ROOT}/.nix-mix
    export HEX_HOME=${PROJECT_ROOT}/.nix-hex
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export ERL_ALFAGS="-kernel shell_history enabled"

    set -e
  '';
in
  mkShell {
    buildInputs = basePackages;
    shellHook = hooks;
  }
