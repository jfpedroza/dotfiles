local query = [[
  ;; Describe blocks
  (call
    target: (identifier) @_target (#eq? @_target "describe")
    (arguments ((string (quoted_content) @namespace.name)))
    (do_block)
  ) @namespace.definition

  ;; Test blocks
  (call
    target: (identifier) @_target (#eq? @_target "test")
    (arguments ((string (quoted_content) @test.name)))
    (do_block)
  ) @test.definition
  ]]

local tquery = vim.treesitter.parse_query("elixir", query)

local function get_tests(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "elixir", {})
  local tree = parser:parse()[1]

  local results = {}
  for id, node, metadata in tquery:iter_captures(tree:root(), bufnr, 0, -1) do
    local text = vim.treesitter.get_node_text(node, bufnr)
    local range = { node:range() }
    local the_data = {
      id = id,
      text = text,
      range = range,
      metadata = metadata,
    }

    table.insert(results, the_data)
  end

  return results
end

P(get_tests(1))
