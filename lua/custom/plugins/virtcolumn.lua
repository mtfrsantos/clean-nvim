local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({ gh("lukas-reineke/virt-column.nvim") })

require("virt-column").setup({
    char = "▕",
    virtcolumn = "80,120",
})
