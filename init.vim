set relativenumber
set number
set splitbelow
set noswapfile
set spell

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <leader>t :NvimTreeToggle<CR>
nnoremap <Leader>rm :call delete(expand('%')) \
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprev<CR>
nnoremap <Leader>fu :Telescope buffers<CR>
nnoremap <leader>c :s/^/-- /<CR>
nnoremap <leader>u :s/^--\s*//<CR>
nnoremap <Leader>d :call delete(expand('%'))<CR>
command! -nargs=1 DelFile call delete(<q-args>)

lua << EOF

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.diagnostic.config({
virtual_text = true,
})
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full" -- don't insert, show options
vim.opt.signcolumn = "number"
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"})
vim.cmd([[command! Temp ObsidianTemplate]])
vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'
vim.api.nvim_exec([[
  autocmd FileType swift setlocal nospell
]], false)

-- vim.lsp.set_log_level("debug")

require('plugins')
require('lsp.pyright')
require('lsp.clangd')
require('lsp.sourcekit')
require('lsp.typescript')
require('lsp.go')
require('keymaps')
-- require('dap_setup')

EOF

