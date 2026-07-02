local function gh(repo)
    return "https://github.com/" .. repo
end

-- [[ Formatting ]]
vim.pack.add({ gh("stevearc/conform.nvim") })
require("conform").setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        -- Specify filetypes to autoformat on save here:
        local enabled_filetypes = {
            lua = true,
            nix = true,
            python = true,
            markdown = true,
            go = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
            return {
                timeout_ms = 3000,
                lsp_fallback = true,
                lsp_format = "fallback",
            }
        else
            return nil
        end
    end,
    default_format_opts = {
        lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting.
    },
    formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        markdown = { "mdformat" },
        go = { "goimports", "gofmt" },
    },
    formatters = {
        nix = {
            command = "nixfmt",
            prepend_args = { "--indent=4" },
        },
        ruff_organize_imports = {
            command = "ruff",
            args = {
                "check",
                "--force-exclude",
                "--select",
                "I",
                "--fix",
                "--line-length",
                "79",
                "--stdin-filename",
                "$FILENAME",
                "-",
            },
        },
        ruff_format = {
            command = "ruff",
            args = {
                "format",
                "--force-exclude",
                "--line-length",
                "79",
                "--stdin-filename",
                "$FILENAME",
                "-",
            },
        },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- vim: ts=2 sts=2 sw=2 et
