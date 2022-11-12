vim.cmd([[
nmap <leader>gb :Git blame<CR>
nmap <leader>gc :Git commit<CR>
nmap <leader>gd :Gvdiffsplit<CR>
nmap <leader>gg :Ggrep
nmap <leader>gL :Gclog<CR>
nmap <leader>gl :Git pull<CR>
nmap <leader>gp :Git push<CR>
nmap <leader>gs :Git<CR>
nmap <leader>gw :GBrowse<CR>
]])

vim.cmd.cnoreabbrev("gpf Git push --force-with-lease")
vim.cmd.cnoreabbrev("gpnoci Git push -o ci.skip")
vim.cmd.cnoreabbrev("gpfnoci Git push --force-with-lease -o ci.skip")
