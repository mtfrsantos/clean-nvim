local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    gh("stevearc/oil.nvim"),
    gh("nvim-tree/nvim-web-devicons"),
    gh("malewicz1337/oil-git.nvim"),
})

require("oil-git").setup({
    symbol_position = "signcolumn",
    can_use_signcolumn = "yes:2",
})

vim.keymap.set("n", "=", "<cmd>Oil<CR>", { desc = "Open oil" })

local function scroll_preview(key)
    local termkey = vim.api.nvim_replace_termcodes(key, true, false, true)
    return function()
        local cur_win = vim.api.nvim_get_current_win()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_get_option_value("previewwindow", { win = win }) then
                vim.api.nvim_set_current_win(win)
                vim.cmd("normal! " .. termkey)
                vim.api.nvim_set_current_win(cur_win)
                return
            end
        end
        vim.cmd("normal! " .. termkey)
    end
end

local oil_info_ns = vim.api.nvim_create_namespace("oil_cursor_info")
local function format_ls_line(path)
    local output = vim.fn.systemlist("ls -ld -h -- " .. vim.fn.shellescape(path))
    if vim.v.shell_error ~= 0 or not output[1] then
        return nil
    end
    local perm, _links, owner, group, size, month, day, time =
        output[1]:match("^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
    if not perm then
        return nil
    end
    return string.format("%s  %s %s %s %s  %s  %s", perm, owner, group, size, month, day, time)
end

local function update_oil_info(buf, win)
    vim.api.nvim_buf_clear_namespace(buf, oil_info_ns, 0, -1)
    local oil = require("oil")
    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if not entry or not dir then
        return
    end
    local info = format_ls_line(dir .. entry.name)
    if not info then
        return
    end
    local lnum = vim.api.nvim_win_get_cursor(win)[1] - 1
    vim.api.nvim_buf_set_extmark(buf, oil_info_ns, lnum, 0, {
        virt_text = { { info .. "  ", "Comment" } },
        virt_text_pos = "eol",
        hl_mode = "combine",
    })
end

local info_timer
vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "oil" then
            return
        end
        if info_timer then
            info_timer:stop()
        end
        local win = vim.api.nvim_get_current_win()
        info_timer = vim.defer_fn(function()
            update_oil_info(args.buf, win)
        end, 30)
    end,
})

require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    preview = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
        update_on_cursor_moved = true,
    },
    keymaps = {
        ["<CR>"] = "actions.select",
        ["<BS>"] = "actions.parent",
        ["="] = "actions.close",
        ["."] = "actions.cd",
        ["<C-p>"] = { "actions.preview", opts = { vertical = true, split = "botright" } },
        ["<C-d>"] = scroll_preview("<C-d>"),
        ["<C-u>"] = scroll_preview("<C-u>"),
    },
    lsp_file_methods = {
        enabled = false,
    },
    use_default_keymaps = false,
    view_options = {
        natural_order = true,
        show_hidden = true,
        is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
        end,
    },
})
