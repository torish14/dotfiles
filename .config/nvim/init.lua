-- vim.cmd[[autocmd BufWritePost plugins.lua PackerCompile]]
-- vim.cmd[[command! PackerInstall packadd packer.nvim | lua require'packers'.install()]]
-- vim.cmd[[command! PackerUpdate packadd packer.nvim | lua require'packers'.update()]]
-- vim.cmd[[command! PackerSync packadd packer.nvim | lua require'packers'.sync()]]
-- vim.cmd[[command! PackerClean packadd packer.nvim | lua require'packers'.clean()]]
-- vim.cmd[[command! PackerCompile packadd packer.nvim | lua require'packers'.compile()]]

local cmd = vim.cmd
-- local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup
--
-- autocmd('VimEnter', {
--   group = augroup('start_screen', { clear = true }),
--   once = true,
--   callback = function()
--     require('start').start()
--   end,
-- })

local create_cmd = vim.api.nvim_create_user_command

create_cmd('PackerInstall', function ()
  cmd [[packadd packer.nvim ]]
  require('plugins').install()
end, {})

create_cmd('PackerUpdate', function ()
  cmd [[packadd packer.nvim ]]
  require('plugins').update()
end, {})

create_cmd('PackerSync', function ()
  cmd [[packadd packer.nvim ]]
  require('plugins').sync()
end, {})

create_cmd('PackerClean', function ()
  cmd [[packadd packer.nvim ]]
  require('plugins').clean()
end, {})

create_cmd('PackerCompile', function ()
  cmd [[packadd packer.nvim ]]
  require('plugins').compile()
end, {})
-- vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath

require('base')
require('autocmds')
require('options')
require('keybinds')
require('colorscheme')
require('plugins')
-- require('lualine')
