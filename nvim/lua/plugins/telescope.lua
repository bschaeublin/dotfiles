return {
  {
    "nvim-telescope/telescope.nvim",
     opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
               file_ignore_patterns = {
                  ".git/",
                  "node_modules/",
               },
               layout_strategy = "vertical",
               mappings = {
                  i = {["<Tab>"] = "select_vertical", ["<esc>"] = actions.close},
                  n = {["<Tab>"] = "select_vertical"},
               },
            },
        }
    end,
    config = function(_, opts) 
       require("telescope").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
