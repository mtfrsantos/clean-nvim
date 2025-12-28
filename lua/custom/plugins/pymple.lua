return {
    {
        "alexpasmantier/pymple.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- optional (nicer ui)
            "stevearc/dressing.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        build = ":PympleBuild",
        config = function()
            require("pymple").setup({
                -- options for the update imports feature
                update_imports = {
                    -- the filetypes on which to run the update imports command
                    -- NOTE: this should at least include "python" for the plugin to
                    -- actually do anything useful
                    filetypes = { "python", "markdown" },
                },
                -- options for the add import for symbol under cursor feature
                add_import_to_buf = {
                    -- whether to autosave the buffer after adding the import (which will
                    -- automatically format/sort the imports if you have on-save autocommands)
                    autosave = true,
                },
                -- automatically register the following keymaps on plugin setup
                keymaps = {
                    -- Resolves import for symbol under cursor.
                    -- This will automatically find and add the corresponding import to
                    -- the top of the file (below any existing doctsring)
                    resolve_import_under_cursor = {
                        desc = "Resolve import under cursor",
                        keys = "<leader>lI", -- feel free to change this to whatever you like
                    },
                },
                -- logging options
                logging = {
                    file = {
                        enabled = true,
                        path = vim.fn.stdpath("data") .. "/pymple.vlog",
                        max_lines = 1000, -- feel free to increase this number
                    },
                    -- this might help in some scenarios
                    console = {
                        enabled = false,
                    },
                    level = "debug",
                },
                -- python options
                python = {
                    -- the names of root markers to look out for when discovering a project
                    root_markers = { "pyproject.toml" },
                    -- the names of virtual environment folders to look out for when
                    -- discovering a project
                    virtual_env_names = { ".venv" },
                },
            })
        end,
    },
}
