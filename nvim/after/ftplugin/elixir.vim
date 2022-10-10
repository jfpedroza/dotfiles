" Wrap word in {:ok, word} tuple
nmap <silent> <localleader>o :lua require("jp.tools").wrap_cursor_node("{:ok, ", "}")<CR>
xmap <silent> <localleader>o :lua require("jp.tools").wrap_selected_nodes("{:ok, ", "}")<CR>

" Wrap word in {:error, word} tuple
nmap <silent> <localleader>e :lua require("jp.tools").wrap_cursor_node("{:error, ", "}")<CR>
xmap <silent> <localleader>e :lua require("jp.tools").wrap_selected_nodes("{:error, ", "}")<CR>
