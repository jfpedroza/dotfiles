vim.g.projectionist_heuristics = vim.json.decode([[
{
  "nvim/": {
    "nvim/after/plugin/*.lua": {
      "type": "after",
      "template": [
        "if not pcall(require, \"{}\") then",
        "  return",
        "end",
        "",
        "require(\"{}\").setup()"
      ]
    }
  },
  "mix.exs": {
    "lib/*.ex": {
      "alternate": "test/{}_test.exs",
      "type": "source",
      "template": [
        "defmodule {camelcase|capitalize|dot} do",
        "end"
      ]
    },
    "test/*_test.exs": {
      "alternate": "lib/{}.ex",
      "type": "test",
      "template": [
        "defmodule {camelcase|capitalize|dot}Test do",
        "  use ExUnit.Case, async: true",
        "",
        "  alias {camelcase|capitalize|dot}",
        "end"
      ]
    }
  }
}
]])
