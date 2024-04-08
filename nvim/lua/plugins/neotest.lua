return {
    {
        "nvim-neotest/neotest",
        event = "VeryLazy",
        ft = "cs",
        config = function()
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)

            require('neotest').setup({
                adapters = {
                    require("neotest-dotnet")({
                        discovery_root = "solution",
                    })
                },
                status = { virtual_text = true },
            })
        end,
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "Issafalcon/neotest-dotnet",
        },
        keys = {
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
            { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
            { "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
            { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
        },
    }
}
