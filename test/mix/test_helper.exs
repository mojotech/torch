if System.get_env("CI") do
  ExUnit.configure(formatters: [ExUnit.CLIFormatter])
else
  ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitNotifier])
end

ExUnit.start()
