local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({ gh("shellRaining/hlchunk.nvim") })

require("hlchunk").setup({
    chunk = {
        enable = true,
        delay = 0,
    },
})
