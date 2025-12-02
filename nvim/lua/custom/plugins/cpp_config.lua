
return {
  -- =============================
  -- 1. C++ Debugger (codelldb)
  -- =============================
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- path to Mason-installed codelldb
      local mason_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

      dap.adapters.codelldb = {
        type = "server",
        port = 13000,
        executable = {
          command = mason_path,
          args = { "--port", "13000" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch C++ file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.expand("%:p:r") -- compiled output
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },

  -- =============================
  -- 2. Compile + Run C++ Keymaps
  -- =============================
{
    "nvim-lua/plenary.nvim",
    config = function()
      -- Compile current C++ file
      vim.keymap.set("n", "<leader>cr", function()
	vim.cmd("wa") 
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r")
        local cmd = "g++ -std=c++20 -O2 " .. file .. " -o " .. output
        local result = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
          print("Compilation failed: " .. result)
        else
          print("Compiled → " .. output)
        end
      end, { desc = "Compile C++" })

      -- Run the compiled output
      vim.keymap.set("n", "<leader>rr", function()
	vim.cmd("wa") 
        local output = vim.fn.expand("%:p:r")
        local result = vim.fn.system(output)
        print(result)
      end, { desc = "Run C++ executable" })

      -- Compile and run in one command
      vim.keymap.set("n", "<leader>crr", function()
	vim.cmd("wa") 
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r")
        local cmd = "g++ -std=c++20 -O2 " .. file .. " -o " .. output .. " && " .. output
        local result = vim.fn.system(cmd)
        print(result)
      end, { desc = "Compile & Run C++" })
    end
},
	
  -- =============================
  -- 3. LSP Config (clangd) - New API
  -- =============================
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Start clangd automatically on C/C++ files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          vim.lsp.start({
            name = "clangd",
            cmd = { "clangd", "--completion-style=detailed", "--header-insertion=never", "--clang-tidy" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = function(fname)
              return vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1] or vim.loop.cwd()
            end,
          })
        end,
      })
    end,
  },

  -- =============================
  -- 4. Snippets
  -- =============================
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- =============================
  -- 5. Formatting
  -- =============================
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        filetype = {
          cpp = {
            function()
              return {
                exe = "clang-format",
                args = { "--assume-filename", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
                stdin = true,
              }
            end,
          },
        },
      })
    end,
  },

  -- =============================
  -- 6. Autocomplete (nvim-cmp)
  -- =============================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  }

}


