stds.factorio = {
  globals = {
    "game", "script", "global", "defines", "remote", "commands", "settings", "rcon"
  }
}

std = "factorio"
files["**/*.lua"] = {std = "factorio"}
