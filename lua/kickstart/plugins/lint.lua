return {
    { -- Linting
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            local uv = vim.uv or vim.loop
            lint.linters_by_ft = {
                python = { "pylint", "ruff", "mypy", "codespell" },
                markdown = { "markdownlint", "codespell" },
                json = { "jsonlint" },
                go = { "golangcilint" },
            }
            local pylint = lint.linters.pylint
            if not pylint then
                return
            end
            pylint.args = {
                function()
                    -- All logic goes inside this function
                    local venv = os.getenv("VIRTUAL_ENV") or (vim.fn.getcwd() .. "/.venv")
                    local hook = ""
                    if vim.fn.isdirectory(venv) == 1 then
                        local lib_path = venv .. "/lib"
                        local handle = uv.fs_scandir(lib_path)
                        if handle then
                            local function iter()
                                return uv.fs_scandir_next(handle)
                            end
                            for name, type in iter do
                                if type == "directory" and name:match("python") then
                                    local site_pkgs = lib_path .. "/" .. name .. "/site-packages"
                                    hook = "--init-hook=import sys; sys.path.extend.extend(['"
                                        .. site_pkgs
                                        .. "', 'src'])"
                                    break
                                end
                            end
                        end
                    end
                    return hook
                end,
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
                    if vim.bo.modifiable then
                        lint.try_lint()
                    end
                end,
            })
        end,
    },
}
