vim.g.mapleader = " "

vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes:1"
vim.opt.cursorline = true
vim.opt.cmdheight = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
if vim.uv.fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          flavour = "frappe",
          transparent_background = true,
        })

        vim.cmd.colorscheme("catppuccin")
      end,
    },
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "intelephense", "ts_ls" },
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local on_attach = function(_, bufnr)
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end

        vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
        })

        vim.lsp.config("ts_ls", {
          capabilities = capabilities,
          on_attach = on_attach,
        })

        vim.lsp.config("intelephense", {
          capabilities = capabilities,
          on_attach = on_attach,
        })

        vim.lsp.enable({ "ts_ls", "intelephense" })

        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "windwp/nvim-autopairs",
      },
      config = function()
        local cmp = require("cmp")
        local autopairs = require("nvim-autopairs")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        autopairs.setup({})
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        cmp.setup({
          completion = {
            autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),
          sources = {
            { name = "nvim_lsp" },
          },
        })
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          current_line_blame = false,
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local opts = { buffer = bufnr }

            vim.keymap.set("n", "]h", gs.next_hunk, opts)
            vim.keymap.set("n", "[h", gs.prev_hunk, opts)
            vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
            vim.keymap.set("n", "<leader>hb", gs.blame_line, opts)
            vim.keymap.set("n", "<leader>hd", gs.diffthis, opts)
            vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
            vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
          end,
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
        },
      },
      config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local function git_root()
          local start = vim.api.nvim_buf_get_name(0)
          if start == "" then
            start = vim.fn.getcwd()
          else
            start = vim.fn.fnamemodify(start, ":h")
          end

          local git_dir = vim.fs.find(".git", {
            path = start,
            upward = true,
            type = "directory",
          })[1]

          if git_dir then
            return vim.fn.fnamemodify(git_dir, ":h")
          end

          return nil
        end

        local function with_git_root(picker)
          return function()
            local root = git_root()
            if not root then
              vim.notify("No git repository found for the current file", vim.log.levels.WARN)
              return
            end

            picker({ cwd = root })
          end
        end

        telescope.setup({
          defaults = {
            layout_strategy = "horizontal",
            layout_config = {
              prompt_position = "top",
            },
            sorting_strategy = "ascending",
            mappings = {
              i = {
                ["<Esc>"] = require("telescope.actions").close,
              },
            },
          },
          pickers = {
            find_files = {
              hidden = true,
            },
            live_grep = {
              additional_args = function()
                return { "--hidden" }
              end,
            },
          },
        })

        pcall(telescope.load_extension, "fzf")

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<C-r>", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        vim.keymap.set("n", "<leader>gc", with_git_root(builtin.git_commits), { desc = "Git commits" })
        vim.keymap.set("n", "<leader>gb", with_git_root(builtin.git_branches), { desc = "Git branches" })
        vim.keymap.set("n", "<leader>gs", with_git_root(builtin.git_status), { desc = "Git status" })
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search buffer" })
      end,
    },
  }, {
    lockfile = "/Users/james/Documents/dottofiles/nvim/lazy-lock.json",
  })
else
  vim.schedule(function()
    vim.notify("lazy.nvim is not installed yet; restart Neovim after bootstrap succeeds", vim.log.levels.WARN)
  end)
end

vim.keymap.set({ "n", "v" }, "j", "h", { noremap = true })
vim.keymap.set({ "n", "v" }, "k", "j", { noremap = true })
vim.keymap.set({ "n", "v" }, "l", "k", { noremap = true })
vim.keymap.set({ "n", "v" }, ";", "l", { noremap = true })
vim.keymap.set({ "n", "v" }, "h", ";", { noremap = true })

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
