return {

    { -- Linting
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                markdown = { "markdownlint", "codespell" },
                python = { "pylint", "mypy", "codespell" },
            }
            local function get_pylint_init_hook()
                -- Check for an activated virtual environment
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    local python_version = "python3.12"
                    local site_packages = venv .. "/lib/" .. python_version .. "/site-packages"
                    return string.format('import sys; sys.path.append("%s")', site_packages)
                end
                -- Fallback: Check for common venv directories in the project
                local project_root = vim.fn.getcwd()
                local venv_candidates = { ".venv", "venv" }
                for _, venv_dir in ipairs(venv_candidates) do
                    local venv_path = project_root .. "/" .. venv_dir
                    if vim.fn.isdirectory(venv_path) == 1 then
                        local site_packages = venv_path .. "/lib/python3.12/site-packages" -- Adjust version
                        return string.format('import sys; sys.path.append("%s")', site_packages)
                    end
                end
                return ""
            end

            lint.linters.pylint.args = {
                "--init-hook=" .. get_pylint_init_hook(),
                "-f",
                "json",
                "--from-stdin",
                function()
                    return vim.api.nvim_buf_get_name(0)
                end,
            }
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    -- Only run the linter in buffers that you can modify in order to
                    -- avoid superfluous noise, notably within the handy LSP pop-ups that
                    -- describe the hovered symbol using Markdown.
                    if vim.bo.modifiable then
                        lint.try_lint()
                    end
                end,
            })
        end,
    },
}
