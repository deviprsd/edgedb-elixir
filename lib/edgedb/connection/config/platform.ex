defmodule EdgeDB.Connection.Config.Platform do
  @system_module Application.compile_env(:edgedb, :system_module, System)

  @spec search_config_dir(list(String.t())) :: String.t()
  def search_config_dir(suffixes) do
    Enum.reduce(suffixes, config_dir(), fn component, result ->
      Path.join(result, component)
    end)
  end

  case :os.type() do
    {:unix, :darwin} ->
      defp config_dir do
        Path.join([
          @system_module.user_home!(),
          "Library",
          "Application Support",
          "edgedb"
        ])
      end

    {:unix, _} ->
      defp config_dir do
        xdg_conf_dir = @system_module.get_env("XDG_CONFIG_HOME", ".")

        xdg_conf_dir =
          if Path.type(xdg_conf_dir) == :relative do
            Path.join(@system_module.user_home!(), ".config")
          else
            xdg_conf_dir
          end

        Path.join(xdg_conf_dir, "edgedb")
      end
  end
end
