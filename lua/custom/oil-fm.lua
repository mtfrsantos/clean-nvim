local M = {}

local function write_selection(path)
    local out = os.getenv("OIL_FM_OUTPUT")
    if not out or out == "" then
        return
    end
    local f = io.open(out, "w")
    if not f then
        return
    end
    f:write(path)
    f:close()
end

function M.select()
    local oil = require("oil")
    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if not entry or not dir then
        return
    end
    local path = dir .. entry.name
    if vim.fn.isdirectory(path) == 1 then
        oil.select()
        return
    end
    M.done = true
    write_selection(path)
    vim.cmd("qa!")
end

function M.quit()
    M.done = true
    local dir = require("oil").get_current_dir()
    if dir then
        write_selection(dir)
    end
    vim.cmd("qa!")
end

function M.start()
    local start = os.getenv("OIL_FM_START")
    if not start or start == "" then
        start = vim.fn.getcwd()
    end
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            if M.done then
                return
            end
            local ok, oil = pcall(require, "oil")
            if not ok then
                return
            end
            local dir = oil.get_current_dir()
            if dir then
                write_selection(dir)
            end
        end,
    })
    require("oil").open(start, { preview = { vertical = true, split = "botright" } })
end

return M
