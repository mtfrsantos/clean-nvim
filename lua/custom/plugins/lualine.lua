local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    gh("nvim-lualine/lualine.nvim"),
    gh("nvim-tree/nvim-web-devicons"),
    gh("yavorski/lualine-macro-recording.nvim"),
})

require("lualine").setup({
    options = {
        theme = "horizon",
    },
    sections = {
        lualine_c = { "filename", "macro_recording", "%S" },
    },
})
