"set relativenumber
"set number
"set splitbelow
set noswapfile

"nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
"nnoremap <leader>t :NvimTreeToggle<CR>
nnoremap <Leader>rm :call delete(expand('%')) \
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprev<CR>
"nnoremap <Leader>fu :Telescope buffers<CR>
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
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.spell = true
vim.opt.spelllang = "en"
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.backup = false
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.breakindent = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.backspace = {"start", "eol", "indent"}
vim.opt.wildignore:append({"*.o", "*~", "*.pyc", "*.class", "*.swp", "*.bak", "*.DS_Store", "*.git", "*.svn", "*.hg", "*.fzf*", "*/node_modules/*"})

vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"})
vim.cmd([[command! Temp ObsidianTemplate]])
vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'

-- Disable spell checking for specific syntax groups
vim.api.nvim_command('autocmd FileType go syntax match SpellBad "\\<\\w\\+\\>" contains=@NoSpell')
vim.api.nvim_command('autocmd FileType go setlocal spell spelllang=en')
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

