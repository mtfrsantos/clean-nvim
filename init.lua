-- [[ Setting options ]]
require("options")

-- [[ Basic Keymaps ]]
require("keymaps")

-- [[ Set up vim.pack ]]
require("pack")

-- [[ Configure and install plugins ]]
require("plugins")

-- Force Neovim to look into the Nix profile for binaries
local nix_profile = os.getenv("HOME") .. "/.nix-profile/bin"
vim.env.PATH = nix_profile .. ":" .. vim.env.PATH

-- vim: ts=2 sts=2 sw=2 et
