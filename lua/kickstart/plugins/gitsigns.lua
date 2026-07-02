local function gh(repo)
    return "https://github.com/" .. repo
end

-- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
--
-- See `:help gitsigns` to understand what each configuration key does.
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
require("gitsigns").setup({
    signs = {
        add = { text = "+" }, ---@diagnostic disable-line: missing-fields
        change = { text = "~" }, ---@diagnostic disable-line: missing-fields
        delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
    },
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "<leader>hn", function()
            if vim.wo.diff then
                vim.cmd.normal({ "hn", bang = true })
            else
                gitsigns.nav_hunk("next")
            end
        end, { desc = "Jump to [n]ext git change" })

        map("n", "<leader>hp", function()
            if vim.wo.diff then
                vim.cmd.normal({ "hp", bang = true })
            else
                gitsigns.nav_hunk("prev")
            end
        end, { desc = "Jump to [p]revious git change" })

        -- Actions
        map("n", "<leader>hP", gitsigns.preview_hunk, { desc = "git [P]review hunk" })
        map("n", "<leader>hB", gitsigns.blame_line, { desc = "git [B]lame line" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
        map("n", "<leader>hD", function()
            gitsigns.diffthis("@")
        end, { desc = "git [D]iff against last commit" })

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
        map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
    end,
})

-- vim: ts=2 sts=2 sw=2 et
