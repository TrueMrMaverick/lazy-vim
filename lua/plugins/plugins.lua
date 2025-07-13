return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
            experimental = {
              -- allows to use flat config format
              useFlatConfig = true,
            },
          },
          -- keys = {
          --   {
          --
          --     "<leader>cT",
          --     "<cmd>EslintFixAll<CR>",
          --     desc = "Fix all eslint issues",
          --   },
          -- },
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" or client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
    {
      "folke/which-key.nvim",
      opts = {
        preset = "modern",
      },
    },
  },
  {

    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {

              "<leader>cL",
              "<cmd>EslintFixAll<CR>",
              desc = "Fix all eslint issues",
            }
    end,
  }
}
