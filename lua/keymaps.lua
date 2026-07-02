-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
local original_virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
        return diagnostic.message
    end,
}
local original_signs = vim.g.have_nerd_font
        and {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
                [vim.diagnostic.severity.INFO] = "󰋽 ",
                [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
        }
    or {}
local main_dianostic_config = {
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    signs = original_signs,
    virtual_lines = { current_line = true }, -- Always show virtual lines on current line
    virtual_text = original_virtual_text, -- Start with virtual text enabled
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = "cursor",
                focus = false,
            })
        end,
    },
    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
}
vim.diagnostic.config(main_dianostic_config)
local group = vim.api.nvim_create_augroup("DiagnosticControl", { clear = true })
-- Disable all diagnostics in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = function()
        vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = false,
            underline = false,
            signs = original_signs,
        })
    end,
})
-- Restore diagnostics when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = function()
        vim.diagnostic.config(main_dianostic_config)
    end,
})
-- Update diagnostics when cursor moves
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    callback = function()
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local has_current_line_diags = #vim.diagnostic.get(0, { lnum = current_line - 1 }) > 0
        local new_config = vim.deepcopy(main_dianostic_config)
        if has_current_line_diags then
            new_config.virtual_text = false
        else
            new_config.virtual_text = original_virtual_text
        end
        vim.diagnostic.config(new_config)
    end,
})
-- Diagnostics under the cursor
vim.keymap.set("n", "<leader>gu", function()
    local options = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        scope = "line",
    }
    vim.diagnostic.open_float(nil, options)
end, { noremap = true, desc = "Dia[G]nostic [U]nder cursor" })
vim.keymap.set("n", "<leader>gq", vim.diagnostic.setloclist, { desc = "Open dia[G]nostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize window
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize +3<cr>", { noremap = true, desc = "Vertical resize +3" })
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize -3<cr>", { noremap = true, desc = "Vertical resize -3" })
vim.keymap.set("n", "<A-k>", "<cmd>resize +3<cr>", { noremap = true, desc = "Horizontal resize +3" })
vim.keymap.set("n", "<A-j>", "<cmd>resize -3<cr>", { noremap = true, desc = "Horizontal resize -3" })

-- Split window
vim.keymap.set("n", "\\", ":vsplit<cr>", { desc = "Vertical window split" })
vim.keymap.set("n", "-", ":split<cr>", { desc = "Horizontal window split" })

-- Save buffer
vim.keymap.set("n", "<C-s>", ":w<cr>", { desc = "Save buffer" })

-- Better navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Move down on buffer" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Move up on buffer" })
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

-- Yank and maintain register
vim.keymap.set("x", "<leader>p", '"_dP', { noremap = true, desc = "Yank and maintain register" })

-- Close current buffer
vim.keymap.set("n", "<leader>bc", "<cmd>bw<cr>", { noremap = true, desc = "[C]lose current buffer" })

-- Close current window
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { noremap = true, desc = "Close current window" })

-- Disable C-z suspension
vim.keymap.set("n", "<C-z>", "<Nop>", { noremap = true, silent = true, desc = "Disable neovim suspension" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("help_window_right", {}),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == "help" then
            vim.cmd.wincmd("L")
        end
    end,
})
