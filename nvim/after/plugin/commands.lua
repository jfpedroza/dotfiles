vim.api.nvim_create_user_command("Scratch", function(opts)
  require("jp.tools").make_scratch(unpack(opts.fargs))
end, { nargs = "?", desc = "Make a scratch buffer with the optional filetype" })
