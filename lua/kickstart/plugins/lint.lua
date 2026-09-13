vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")
local uv = vim.uv or vim.loop

lint.linters_by_ft = {
    python = { "pylint", "ruff", "mypy", "codespell" },
    markdown = { "markdownlint", "codespell" },
    json = { "jsonlint" },
    go = { "golangcilint", "codespell" },
}

local pylint = lint.linters.pylint
if pylint then
    pylint.args = {
        function()
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
                            hook = "--init-hook=import sys; sys.path.extend(['" .. site_pkgs .. "', 'src'])"
                            break
                        end
                    end
                end
            end
            return hook
        end,
        "--disable=missing-module-docstring,missing-class-docstring,missing-function-docstring,redefined-outer-name",
        "-f",
        "json",
        "--from-stdin",
        function()
            return vim.api.nvim_buf_get_name(0)
        end,
    }
end

-- Create autocommand which carries out the actual linting
-- on the specified events.
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

-- Auto search mypy in virtual environment
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("Linting", { clear = true }),
    callback = function()
        local cwd = vim.fn.getcwd()
        local venv_mypy = cwd .. "/.venv/bin/mypy"
        if vim.fn.executable(venv_mypy) == 1 then
            lint.linters.mypy.cmd = venv_mypy
        else
            lint.linters.mypy.cmd = "mypy"
        end
        lint.try_lint()
    end,
})
