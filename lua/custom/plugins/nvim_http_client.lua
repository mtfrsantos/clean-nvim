return {
    "heilgar/nvim-http-client",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    ft = { "http", "rest" },
    config = function()
        require("http_client").setup({
            -- Default configuration (works out of the box)
            default_env_file = ".env.json",
            request_timeout = 5000,
            split_direction = "right",
            create_keybindings = true,
            user_agent = "heilgar/nvim-http-client",
            -- Profiling (timing metrics for requests)
            profiling = {
                enabled = true,
                show_in_response = true,
                detailed_metrics = true,
            },
            -- Default keybindings (can be customized)
            keybindings = {
                select_env_file = "<leader>rf",
                set_env = "<leader>re",
                run_request = "<leader>rr",
                stop_request = "<leader>rx",
                toggle_verbose = "<leader>rv",
                toggle_profiling = "<leader>rp",
                dry_run = "<leader>rd",
                copy_curl = "<leader>rc",
                save_response = "<leader>rs",
                set_project_root = "<leader>rg",
                get_project_root = "<leader>rgg",
            },
        })
        -- Set up Telescope integration if available
        if pcall(require, "telescope") then
            require("telescope").load_extension("http_client")
        end
    end,
}
