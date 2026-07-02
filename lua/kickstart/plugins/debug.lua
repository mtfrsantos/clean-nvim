-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/jay-babu/mason-nvim-dap.nvim",
    -- Languages
    "https://github.com/mfussenegger/nvim-dap-python",
    "https://github.com/leoluz/nvim-dap-go",
})

-- Basic debugging keymaps
vim.keymap.set("n", "<leader>bc", function()
    require("dap").continue()
end, { desc = "De[B]ug: Start/[C]ontinue" })
vim.keymap.set("n", "<leader>bt", function()
    require("dap").terminate()
end, { desc = "De[B]ug: [T]erminate" })
vim.keymap.set("n", "<leader>bi", function()
    require("dap").step_into()
end, { desc = "De[B]ug: Step [I]nto" })
vim.keymap.set("n", "<leader>bo", function()
    require("dap").step_over()
end, { desc = "De[B]ug: Step [O]ver" })
vim.keymap.set("n", "<leader>bu", function()
    require("dap").step_out()
end, { desc = "De[B]ug: Step O[U]t" })
vim.keymap.set("n", "<leader>bb", function()
    require("dap").toggle_breakpoint()
end, { desc = "De[B]ug: Toggle [B]reakpoint" })
vim.keymap.set("n", "<leader>bB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "De[B]ug: Set [B]reakpoint" })
vim.keymap.set("n", "<leader>bR", function()
    require("dapui").toggle()
end, { desc = "De[B]ug: See last session [R]esult" })
vim.keymap.set("n", "<leader>br", function()
    require("dap").restart()
end, { desc = "De[B]ug: [R]estart" })
vim.keymap.set("n", "<leader>be", function()
    require("dapui").eval()
end, { desc = "De[B]ug: [E]val" })
vim.keymap.set("n", "<leader>bw", function()
    require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
end, { noremap = true, silent = true, desc = "De[B]ug: Add to [W]atch list" })

local dap = require("dap")
local dapui = require("dapui")

-- Move debug to line under cursor
vim.keymap.set("n", "<leader>bm", function()
    local breakpoint_hit = false
    dap.listeners.after.event_stopped["remove_breakpoint"] = function()
        if not breakpoint_hit then
            breakpoint_hit = true
            dap.toggle_breakpoint()
            dap.listeners.after.event_stopped["remove_breakpoint"] = nil
        end
    end
    dap.set_breakpoint()
    dap.continue()
end, { desc = "De[B]ug: [M]ove to cursor" })

require("mason-nvim-dap").setup({
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "delve",
    },
})

-- Dap UI setup
---@diagnostic disable-next-line: missing-fields
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    ---@diagnostic disable-next-line: missing-fields
    controls = {
        icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
        },
    },
})

-- Change breakpoint icons
vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
local breakpoint_icons = vim.g.have_nerd_font
        and {
            Breakpoint = "",
            BreakpointCondition = "",
            BreakpointRejected = "",
            LogPoint = "",
            Stopped = "",
        }
    or {
        Breakpoint = "●",
        BreakpointCondition = "⊜",
        BreakpointRejected = "⊘",
        LogPoint = "◆",
        Stopped = "⭔",
    }

for type, icon in pairs(breakpoint_icons) do
    local tp = "Dap" .. type
    local hl = (type == "Stopped") and "DapStop" or "DapBreak"
    vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Add better inline variable value
require("nvim-dap-virtual-text").setup({
    display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == "eol" then
            return " " .. variable.value
        else
            return " = " .. variable.value
        end
    end,
    virt_text_pos = "eol",
})

-- Install golang specific config
require("dap-go").setup({
    delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has("win32") == 0,
    },
})

-- Install python specific config
local debugpy_python_path = "$HOME/.virtualenvs/debugpy/bin/python"
require("dap-python").setup(debugpy_python_path)
require("dap-python").test_runner = "pytest"
table.insert(dap.configurations.python, {
    name = "Pytest: file",
    type = "python",
    request = "launch",
    module = "pytest",
    args = { "-vvv", "${file}" },
    justMyCode = true,
    cwd = "${workspaceFolder}",
})
