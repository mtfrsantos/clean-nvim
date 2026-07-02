-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add({
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("*") },
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "https://github.com/MunifTanjim/nui.nvim",
})

-- Global keymap to reveal Neo-tree
vim.keymap.set("n", "<C-e>", "<Cmd>Neotree reveal<CR>", { desc = "NeoTree reveal", silent = true })

require("neo-tree").setup({
    event_handlers = {
        {
            event = "neo_tree_buffer_enter",
            handler = function()
                vim.opt_local.relativenumber = true
            end,
        },
    },
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
        position = "current",
    },
    filesystem = {
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        filtered_items = {
            visible = true,
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignore = false,
        },
        use_libuv_file_watcher = true,
        window = {
            mappings = {
                ["<C-e>"] = "close_window",
            },
        },
    },
})
