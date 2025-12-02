
-- lua/custom/plugins/markdown.lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim",  -- if you use the mini.nvim suite
      -- "nvim-mini/mini.icons",        -- optional standalone mini icons
      -- "nvim-tree/nvim-web-devicons", -- optional alternative for icons
    },
    opts = {},  -- use defaults; you can customize here
    keys = {
      -- Toggle rendered/raw view
      { "<leader>mr",  function() require("render-markdown").toggle() end, desc = "Toggle Markdown Render" },
      -- Show preview in a side window
      { "<leader>mp",  function() require("render-markdown").preview() end, desc = "Markdown Preview" },
    },
  },
}
