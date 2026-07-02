local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({ gh("christoomey/vim-tmux-navigator") })

vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>")
