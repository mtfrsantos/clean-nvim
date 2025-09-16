-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "+", nbsp = "␣", space = "·", eol = "¬" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- When a file has been detected to have been changed outside of Vim and
-- it has not been changed inside of Vim, automatically read it again.
vim.o.autoread = true

-- Tab config
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- File encoding
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- The value of this option influences when the last window will have a
-- status line:
--    0: never
--    1: only if there are at least two windows
--    2: always
--    3: always and ONLY the last window
-- The screen looks nicer with a status line if you have several
-- windows, but it takes another screen line.
vim.o.laststatus = 3

-- Enables 24-bit RGB color in the TUI
vim.o.termguicolors = true

-- Make special chars grey
vim.cmd("hi SpecialKey ctermfg=grey guifg=grey10")

-- Disable snacks animations
vim.g.snacks_animate = false
