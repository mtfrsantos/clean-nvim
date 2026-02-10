return {
    "rest-nvim/rest.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/nvim-nio",
    },
    keys = {
        { "<leader>rr", "<cmd>Rest run<cr>", desc = "Run REST request" },
    },
    build = false,
    config = function()
        require("rest-nvim").setup({
            rocks = {
                enabled = false,
                hererocks = false,
            },
        })
    end,
}
