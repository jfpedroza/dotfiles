local query = [[
  ;; query
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

  ;; Doctests
  ;; The word doctest is included in the name to make it easier to notice
  (call 
    target: (identifier) @_target (#eq? @_target "doctest")) @test.name @test.definition
  ]]

local tquery = vim.treesitter.parse_query("elixir", query)

local function get_tests(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "elixir", {})
  local tree = parser:parse()[1]

  local results = {}
  -- Pattern index, match table, metadata
  for _, match, _ in tquery:iter_matches(tree:root(), bufnr, 0, -1) do
    local texts = {}

    for id, node in pairs(match) do
      local capture_name = tquery.captures[id]
      local text = vim.treesitter.get_node_text(node, bufnr)
      texts[capture_name] = text
    end

    table.insert(results, texts)
  end

  return results
end

P(get_tests(1))
