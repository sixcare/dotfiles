-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
spec = {
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",  -- latest stable major branch as of 2025
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim",       -- required for some previews
        "nvim-tree/nvim-web-devicons", -- icons
        "MunifTanjim/nui.nvim",       -- UI components
      },
      config = function()
        require("neo-tree").setup({
          close_if_last_window = true,  -- auto-close neo-tree if it's the last window
          enable_git_status = true,
          enable_diagnostics = false,
          window = {
            position = "left",
            width = 30,
            mappings = {
              ["<space>"] = "toggle_node", -- expand/collapse folder
              ["<cr>"] = "open",
              ["S"] = "split_with_window_picker", -- open in split
              ["s"] = "vsplit_with_window_picker", -- open in vsplit
              ["q"] = "close_window",
            },
          },
          filesystem = {
            filtered_items = {
              hide_dotfiles = false,
              hide_gitignored = false,
            },
          },
          buffers = {
            follow_current_file = { enabled = true }, -- auto-highlight current buffer
          },
          git_status = {
            window = {
              position = "float",
            },
          },
        })
      end,
    },
    {
      "garymjr/nvim-snippets",
      keys = {
        {
          "<Tab>",
          function()
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
              return
            end
            return "<Tab>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<Tab>",
          function()
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          end,
          expr = true,
          silent = true,
          mode = "s",
        },
        {
          "<S-Tab>",
          function()
            if vim.snippet.active({ direction = -1 }) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
              return
            end
            return "<S-Tab>"
          end,
          expr = true,
          silent = true,
          mode = { "i", "s" },
        },
      },
    },
    {
        "echasnovski/mini.nvim",
        version = "false",
        lazy = false
    }
},
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
