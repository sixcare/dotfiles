vim.opt.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.g.mapleader = ","
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>t', '<C-w>h', { desc = 'Focus Neo-tree' })

require("config.lazy")
