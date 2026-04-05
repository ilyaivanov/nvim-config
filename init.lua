-- Stuff missing: 
    -- Autocomplettion
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

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.signcolumn = "yes:1"

-- sync clipboard with the nvim
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>w', '<cmd>wa<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--
vim.keymap.set('n', '<leader>r', function()
  -- https://stackoverflow.com/a/14425862
  isWindows = package.config:sub(1,1) == "\\"

  if isWindows then
    vim.cmd('!cmd /c .\\build.bat')
  else 
    vim.print("linux")
  end
end)

vim.keymap.set('n', '<leader>i', function()
  vim.cmd('wa') 
  vim.cmd('source $MYVIMRC')
end)

vim.keymap.set('n', '<leader>I', function()
  vim.cmd('e $MYVIMRC')
end)

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})

vim.keymap.set('n', '<M-J>', '<cmd>cnext<CR>');
vim.keymap.set('n', '<M-K>', '<cmd>cprev<CR>');

-- Theme
vim.opt.background = "dark"

vim.pack.add({ 'https://github.com/EdenEast/nightfox.nvim'})
vim.cmd.colorscheme "carbonfox"

-- vim.pack.add({ 'https://github.com/nyoom-engineering/oxocarbon.nvim' })
-- vim.cmd.colorscheme "oxocarbon"

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
  'https://github.com/nvim-telescope/telescope-file-browser.nvim',

  'https://github.com/nvim-lua/plenary.nvim',

  -- Optional but recommended (native sorter, much faster)
  -- am I using this??
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
})

require('telescope').setup({
  defaults = {
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
  },
})

vim.keymap.set("n", "<space>fb", function()
	require("telescope").extensions.file_browser.file_browser({selected_buffer = true})
end)

require("telescope").load_extension "file_browser"

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
  require("conform").format({
    async = true,
  })
end, {})


vim.keymap.set('n', '<leader>F', function()
  vim.cmd("write")

  local file = vim.api.nvim_buf_get_name(0)

  vim.system({ "prettier", "-w", file }, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        print("Prettier failed: " .. (obj.stderr or ""))
      end)
    else
      vim.schedule(function()
        vim.cmd("edit!") -- reload file after formatting
      end)
    end
  end)
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

vim.keymap.set('n', '<leader>q', function()
  vim.lsp.buf.references(nil, {
    loclist = false,
    on_list = function(options)
      vim.fn.setqflist({}, ' ', options)
      vim.cmd('copen')
    end,
  })
end)

vim.keymap.set('n', '<leader>E', function()
  vim.diagnostic.setqflist()
  vim.cmd('copen')
end, { desc = 'Show all LSP diagnostics in quickfix' })

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



-- File Explorer 
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua"
})


-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with a config

---@type nvim_tree.config
local config = {
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}
require("nvim-tree").setup(config)

vim.keymap.set("n", "<leader>to", "<cmd>NvimTreeOpen<CR>")
