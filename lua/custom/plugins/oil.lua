return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "OilEnter",
            callback = function()
                vim.defer_fn(function()
                    -- A. Stop if we are currently INSIDE the preview window
                    -- (Prevents recursive loop when previewing directories)
                    if vim.api.nvim_get_option_value("previewwindow", { win = 0 }) then
                        return
                    end
                    -- B. Stop if a preview window is ALREADY open elsewhere in the tab
                    -- (Prevents the "Toggle" behavior that closes the window)
                    local wins = vim.api.nvim_tabpage_list_wins(0)
                    for _, win in ipairs(wins) do
                        -- CORRECTED: Use nvim_get_option_value
                        if vim.api.nvim_get_option_value("previewwindow", { win = win }) then
                            return -- Preview exists, do nothing
                        end
                    end
                    -- C. If we are here: We are in Oil, and no preview exists. Open it.
                    if require("oil").get_cursor_entry() then
                        require("oil.actions").preview.callback({
                            vertical = true,
                            split = "botright",
                        })
                    end
                end, 100)
            end,
        })
        vim.keymap.set("n", "=", "<cmd>Oil<CR>", { desc = "Open oil" })
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
    end,
}
