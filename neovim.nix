# neovim.nix
{ symlinkJoin
, neovim-unwrapped
, makeWrapper
, runCommandLocal
, vimPlugins
, lib
,
}:
let
  packageName = "mypackage";

  startPlugins = [
    vimPlugins.telescope-nvim
    vimPlugins.nvim-treesitter.withAllGrammars
  vimPlugins.snacks-nvim
  ];

  foldPlugins = builtins.foldl'
    (
      acc: next:
        acc
        ++ [
          next
        ]
        ++ (foldPlugins (next.dependencies or [ ]))
    ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ln -vsfT ${./config} $out/pack/${packageName}/start/config
    ${
      lib.concatMapStringsSep
      "\n"
      (plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}")
      startPluginsWithDeps
    }

  '';
in
symlinkJoin {
  name = "neovim-custom";
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
        wrapProgram $out/bin/nvim \
          --add-flags '-u' \
          --add-flags '${./config/plugin/init.lua}' \
          --add-flags '--cmd' \
          --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
          --set-default NVIM_APPNAME nvim-custom
  '';

  # --add-flags '${./init.lua}' \
  passthru = {
    inherit packpath;
  };
}

