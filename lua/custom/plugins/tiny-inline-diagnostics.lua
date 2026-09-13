local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    gh("rachartier/tiny-inline-diagnostic.nvim"),
})

vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        require("tiny-inline-diagnostic").setup({
            signs = {
                left = "",
                right = "",
                diag = "●",
                arrow = "    ",
                up_arrow = "    ",
                vertical = " │",
                vertical_end = " └",
            },
            blend = {
                factor = 0.22,
            },
            options = {
                show_source = {
                    enabled = true,
                },
                multilines = {
                    enabled = true,
                },
            },
        })
        vim.diagnostic.config({
            virtual_text = false,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
        })
    end,
})
