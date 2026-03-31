-- Stuff missing: 
-- Autocomplettion
-- TODO manager plugin
-- File explorer 

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.softtabstop = 2

vim.o.number = true;
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 10

vim.opt.signcolumn = "yes:1"

-- sync clipboard with the nvim
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>w', '<cmd>wa<CR>')

vim.keymap.set('n', '<leader>i', function()
  vim.cmd('wa') 
  vim.cmd('source $MYVIMRC')
end)

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})


-- Theme
vim.opt.background = "dark"

vim.pack.add({ 'https://github.com/nyoom-engineering/oxocarbon.nvim' })
vim.cmd.colorscheme "oxocarbon"

-- vim.pack.add({ 'https://github.com/Mofiqul/vscode.nvim' })
-- vim.cmd.colorscheme "vscode"


-- Mini stuff
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
require('mini.move').setup()
require('mini.surround').setup()
require('mini.statusline').setup({
  use_icons = false,
})


-- Telescope
vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',

  'https://github.com/nvim-lua/plenary.nvim',

  -- Optional but recommended (native sorter, much faster)
  -- am I using this??
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
})

require('telescope').setup({
  defaults = {
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
  }
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>sc', builtin.git_commits, {})


-- Formatting
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' });

require('conform').setup({
  formatters_by_ft = {
    lua = {"stylua"},
    javascript = {"prettier"},
    typescript = {"prettier"},
    c = {"clang-format"},
  }
});

vim.keymap.set('n', '<leader>f', function() 
  require("conform").format({})
end, {})




-- LSP
vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable('ts_ls');
vim.lsp.enable('clangd');

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.diagnostic.config({
  float = {
    border = "rounded",
    source = "always",
    focus = true,
  },
})

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next()
  vim.defer_fn(function()
    vim.diagnostic.open_float(nil, {})
  end, 50)
end)

vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev()
  vim.defer_fn(function()
    vim.diagnostic.open_float(nil, {})
  end, 50)
end)

