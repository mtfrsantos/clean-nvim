local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    gh("esmuellert/codediff.nvim"),
    gh("MunifTanjim/nui.nvim"), -- Dependency
})
