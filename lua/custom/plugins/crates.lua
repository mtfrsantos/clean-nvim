return {
    "saecki/crates.nvim",
    tag = "stable",
    dependencies = { "mrcjkb/rustaceanvim" },
    opts = {
        completion = {
            crates = { enabled = true },
        },
        lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
        },
    },
}
