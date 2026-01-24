-- =====================================
-- LEADER
-- =====================================
vim.g.mapleader = " "

-- =====================================
-- BASIC SETTINGS
-- =====================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.number = true
vim.o.relativenumber = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.showmode = false

-- =====================================
-- PACKER (Plugins)
-- =====================================
vim.cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "neovim/nvim-lspconfig"

  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"

  use "windwp/nvim-autopairs"

  use "nvim-lualine/lualine.nvim"
  use "Mofiqul/vscode.nvim"

  use "nvim-tree/nvim-tree.lua"
  use "nvim-tree/nvim-web-devicons"

  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }
end)

-- =====================================
-- THEME & UI
-- =====================================
require("vscode").setup({ italic_comments = true })
vim.cmd("colorscheme vscode")
require("lualine").setup { options = { theme = "vscode" } }

-- =====================================
-- TREESITTER
-- =====================================
require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "cpp", "java", "php", "html", "javascript" },
  highlight = { enable = true },
}

-- =====================================
-- LSP CONFIGURATION
-- =====================================
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- CLANGD
lspconfig.clangd.setup {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--limit-results=100",
    "--completion-style=detailed",
  },
  root_dir = util.root_pattern("compile_commands.json", ".git", "Makefile"),
}

-- JDTLS
lspconfig.jdtls.setup {
  cmd = {
    "java",
    "-jar", "/home/producerdj/java-lsp/plugins/org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar",
    "-configuration", "/home/producerdj/java-lsp/config_linux",
    "-data", "/home/producerdj/workspace",
  },
  root_dir = util.root_pattern(".git", "pom.xml", "build.gradle"),
  capabilities = capabilities,
}

-- =====================================
-- TELESCOPE CONFIG (UNCHANGED)
-- =====================================
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup {
  defaults = {
    layout_config = {
      width = 0.85,
      height = 0.85,
      preview_width = 0.5,
    },
    file_ignore_patterns = {
      "/usr/include",
      "bits/",
      "c%+%+/",
      "v1/",
      "boost/",
    },
  },
}

-- =====================================
-- TELESCOPE KEYMAPS
-- =====================================
vim.keymap.set("n", "<leader>fa", function()
  builtin.lsp_dynamic_workspace_symbols({
    symbols = { "Class", "Struct", "Function", "Method", "Variable", "Field" },
  })
end)

vim.keymap.set("n", "<leader>fd", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)

vim.keymap.set("n", "gd", builtin.lsp_definitions)
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "gi", builtin.lsp_implementations)

-- =====================================
-- COMPLETION (CMP)
-- =====================================
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup {
  preselect = cmp.PreselectMode.None,
  completion = {
    keyword_length = 3,
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<Esc>"] = cmp.mapping.abort(),
  },

  sources = {
    {
      name = "nvim_lsp",
      max_item_count = 15,
      entry_filter = function(entry)
        return entry.kind ~= cmp.lsp.CompletionItemKind.Text
      end,
    },
    { name = "luasnip", max_item_count = 5 },
  },
}

-- =====================================
-- AUTOPAIRS (WORKING)
-- =====================================
local autopairs = require("nvim-autopairs")

autopairs.setup {
  map_cr = true,
  map_bs = true,
  enable_check_bracket_line = false,
}

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- =====================================
-- FILE TREE & DIAGNOSTICS
-- =====================================
require("nvim-tree").setup {}
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "K", vim.diagnostic.open_float)

-- =====================================
-- BUILD COMMANDS
-- =====================================
vim.keymap.set("n", "<F5>", ":w<CR>:!javac % && java %:r<CR>", { silent = true })
vim.keymap.set("n", "<F8>", ":w<CR>:!g++ % -o %:r && exit<CR>:qa<CR>", { silent = true })

vim.opt.compatible = false
vim.opt.wrap = false

