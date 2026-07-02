-- Add indentation guides even on blank lines
-- See `:help ibl`
vim.pack.add({
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/TheGLander/indent-rainbowline.nvim",
})

require("ibl").setup(require("indent-rainbowline").make_opts({
    indent = { char = "▏" },
    whitespace = {
        remove_blankline_trail = false,
    },
}, {
    color_transparency = 0.15,
    colors = {
        0x03045e,
        0x023e8a,
        0x0077b6,
        0x0096c7,
        0x00b4d8,
        0x47cae4,
        0x90e0ef,
        0x90e0ef,
        0x90e0ef,
        0x90e0ef,
    },
}))
