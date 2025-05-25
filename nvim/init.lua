vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.keymap.set('n', '<F5>', function()
  local file = vim.fn.expand('%:p')  -- Lấy đường dẫn đầy đủ
  local dir = vim.fn.expand('%:p:h') -- Lấy thư mục chứa file
  local filename = vim.fn.expand('%:t:r') -- Lấy tên file (không đuôi)
  
  -- Tạo file exe cùng thư mục với file nguồn
local compile_cmd = string.format('cd "%s" && del "%s.exe" 2>nul && g++ "%s" -o "%s" && "%s"', 
  dir, filename, file, filename, filename)
  
  vim.cmd('vsplit | vertical resize 50 | terminal ' .. compile_cmd)
end, { desc = 'Compile & Run C++', noremap = true, silent = true })
