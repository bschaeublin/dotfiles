return {
    {
        'stevearc/conform.nvim',
        lazy = false,
        opts = {
            formatters_by_ft = {
                ["javascript"] = { "prettier" },
                ["javascriptreact"] = { "prettier" },
                ["typescript"] = { "prettier" },
                ["typescriptreact"] = { "prettier" },
                ["cs"] = { "csharpier"},
                ["vue"] = { "prettier" },
                ["css"] = { "prettier" },
                ["scss"] = { "prettier" },
                ["less"] = { "prettier" },
                ["html"] = { "prettier" },
                ["json"] = { "prettier" },
                ["yaml"] = { "prettier" },
                ["markdown"] = { "prettier" },
                ["markdown.mdx"] = { "prettier" },
                ["graphql"] = { "prettier" },
                ["handlebars"] = { "prettier" },
            },
            formatters = {
                csharpier = {
                    command = "dotnet-csharpier",
                    args = { "--write-stdout" }
                }
            }
        },
    },
}
