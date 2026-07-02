local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    { src = "https://github.com/saecki/crates.nvim", tag = "stable" },
    gh("mrcjkb/rustaceanvim"), -- Dependency
})

require("crates").setup({
    completion = {
        crates = { enabled = true },
    },
    lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
    },
})
