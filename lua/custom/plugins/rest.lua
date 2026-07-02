local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    gh("rest-nvim/rest.nvim"),
    gh("nvim-treesitter/nvim-treesitter"),
    gh("nvim-neotest/nvim-nio"),
})

vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<cr>", { desc = "[R]un request under cursor" })
vim.keymap.set("n", "<leader>rf", "<cmd>Rest env select<cr>", { desc = "Select env [F]ile" })

require("rest-nvim").setup({
    ui = {
        winbar = true,
        keybinds = {
            prev = "H",
            next = "L",
        },
    },
})
