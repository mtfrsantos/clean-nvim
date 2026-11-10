local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({ gh("hiphish/rainbow-delimiters.nvim") })

require("rainbow-delimiters.setup").setup({
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
    },
})
