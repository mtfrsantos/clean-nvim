local function gh(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({ gh("folke/snacks.nvim") })

---@type snacks.Config
require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = {
        enabled = false,
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
            {
                section = "terminal",
                cmd = "pokemon-colorscripts -r --no-title; sleep .1",
                random = 10,
                pane = 2,
                indent = 4,
                height = 30,
            },
        },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    picker = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
})

-- Keymaps
vim.keymap.set("n", "<leader>n", function()
    Snacks.notifier.show_history()
end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>G", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })

-- Setup some globals for debugging
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd -- Override print to use snacks for `:=` command

-- Create some toggle mappings
Snacks.toggle.option("spell", { name = "[T]oggle [S]pelling" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "[T]oggle [W]rap" }):map("<leader>tw")
Snacks.toggle.option("relativenumber", { name = "[T]oggle [R]elative Number" }):map("<leader>tr")
Snacks.toggle.diagnostics():map("<leader>td")

-- vim: ts=2 sts=2 sw=2 et
