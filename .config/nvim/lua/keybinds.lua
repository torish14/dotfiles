local g = vim.g
local keymap = vim.api.nvim_set_keymap
local silent = { silent = true, noremap = true }

g.mapleader = [[ ]]
g.maplocalleader = [[,]]

g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_python_provider = 0
g.loaded_python_provider3 = 0

local disabled_built_ins = {
  '2html_plugin',
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'shada_plugin',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'tutor_mode_plugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
  'rplugin',
  'rrhelper',
}

for i = 1, 17 do
  g['loaded_' .. disabled_built_ins[i]] = 1
end

g.cursorhold_updatetime = 100

g.closetag_filenames = '*.html, *.xhtml, *.phtml, *.vue, *jsx, *tsx'

g.copilot_node_command = '.local/share/nvm/v16.17.0/bin/node'

g.user_emmet_leader_key='<C-z>'

g.bookmark_sign = '💡'
g.bookmark_highlight_lines = 1

g.winresizer_start_key = '<leader>wr'

-- g.lightspeed_disable_default_mappings = 1

-- g.cursorword_disable_at_startup = true
-- g.cursorword_min_width = 3
-- g.cursorword_max_width = 20
-- g.cursorword_disable_filetypes = { "TelescopePrompt" }
-- vim.cmd('hi! def link CursorWord CursorLine')

-- b:coc_nav

keymap('n', '<leader>w', '<cmd>w<CR>', silent)
keymap('n', '<leader>qq', '<cmd>q!<CR>', silent)
keymap('n', '<leader>wq', '<cmd>wq<CR>', silent)
keymap('n', '<leader>x', '<cmd>x!<CR>', silent)

keymap('n', '<leader>pi', '<cmd>PackerInstall<CR>', silent)
keymap('n', '<leader>pu', '<cmd>PackerUpdate<CR>', silent)
keymap('n', '<leader>pn', '<cmd>PackerClean<CR>', silent)
keymap('n', '<leader>ps', '<cmd>PackerSync<CR>', silent)
keymap('n', '<leader>pe', '<cmd>PackerCompile<CR>', silent)
keymap('n', '<leader>ch', '<cmd>CheckHealth<CR>', silent)

keymap('n', '<Esc><Esc>', '<cmd>nohlsearch<CR><Esc>', silent)

keymap('n', 'j', 'gj', silent)
keymap('n', 'k', 'gk', silent)
keymap('n', '<Down>', 'gj', silent)
keymap('n', '<Up>', 'gk', silent)

keymap('n', '<C-;>', 'g;', silent)
keymap('n', '<C-,>', 'g,', silent)

keymap('n', '<C-a>', '<Esc>^', silent)
keymap('n', '<C-e>', '<Esc>$', silent)
keymap('i', '<C-a>', '<Esc>^i', silent)
keymap('i', '<C-e>', '<Esc>$a', silent)

keymap('n', '0', '^', silent)
keymap('n', '^', '0', silent)

keymap('n', 'p', ']p', silent)
keymap('n', 'P', ']P', silent)

keymap('n', 'Y', 'y$', silent)

keymap('n', '+', '<C-a>', silent)
keymap('n', '-', '<C-x>', silent)

keymap('n', '<leader>,', ':vertical new ~/.config/nvim/init.lua<CR>', silent)

keymap('n', '<CR>', 'i<Return><Esc>^k', silent)

keymap('n', 'zj', 'zt', silent)
keymap('n', 'zk', 'zb', silent)

keymap('v', '<', '<gv', silent)
keymap('v', '>', '>gv', silent)

keymap('n', 'cw', 'ciw', silent)
keymap('n', 'ct', 'cit', silent)
keymap('n', 'c(', 'ci(', silent)
keymap('n', 'c{', 'ci{', silent)
keymap('n', 'c[', 'ci[', silent)
keymap('n', 'c<', 'ci<', silent)
keymap('n', "c'", "ci'", silent)
keymap('n', 'c"', 'ci"', silent)
keymap('n', 'c`', 'ci`', silent)

keymap('n', 'dw', 'diw', silent)
keymap('n', 'dt', 'dit', silent)
keymap('n', 'd(', 'di(', silent)
keymap('n', 'd{', 'di{', silent)
keymap('n', 'd[', 'di[', silent)
keymap('n', 'd<', 'di<', silent)
keymap('n', "d'", "di'", silent)
keymap('n', 'd"', 'di"', silent)
keymap('n', 'd`', 'di`', silent)

keymap('n', 'vw', 'viw', silent)
keymap('n', 'vt', 'vit', silent)
keymap('n', 'v(', 'vi(', silent)
keymap('n', 'v{', 'vi{', silent)
keymap('n', 'v[', 'vi[', silent)
keymap('n', 'v<', 'vi<', silent)
keymap('n', "v'", "vi'", silent)
keymap('n', 'v"', 'vi"', silent)
keymap('n', 'v`', 'vi`', silent)

keymap('n', 'yw', 'yiw', silent)
keymap('n', 'yt', 'yit', silent)
keymap('n', 'y(', 'yi(', silent)
keymap('n', 'y{', 'yi{', silent)
keymap('n', 'y[', 'yi[', silent)
keymap('n', 'y<', 'yi<', silent)
keymap('n', "y'", "yi'", silent)
keymap('n', 'y"', 'yi"', silent)
keymap('n', 'y`', 'yi`', silent)

keymap('n', 'sj', '<C-w>j', silent)
keymap('n', 'sk', '<C-w>k', silent)
keymap('n', 'sl', '<C-w>l', silent)
keymap('n', 'sh', '<C-w>h', silent)
keymap('n', 'ss', ':<C-u>sp<CR><C-w>j', silent)
keymap('n', 'sv', ':<C-u>vs<CR><C-w>l', silent)
keymap('n', '<leader>s', ':<C-u>split<CR>', silent)
keymap('n', '<leader>v', ':<C-u>vsplit<CR>', silent)

-- place this in one of your configuration file(s)
-- keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
-- keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
-- keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})
keymap('n', '<leader>j', '<cmd>HopLineStart<CR>', silent)
keymap('n', '<leader>k', '<cmd>HopLineStart<CR>', silent)
keymap('n', '<leader>hh', '<cmd>HopChar2<CR>', silent)
keymap('n', '<leader>hw', '<cmd>HopWord<CR>', silent)
keymap('n', '<leader>ha', '<cmd>HopAnywhere<CR>', silent)
keymap('v', '<leader>j', '<cmd>HopLineStart<CR>', silent)
keymap('v', '<leader>k', '<cmd>HopLineStart<CR>', silent)
keymap('v', '<leader>hh', '<cmd>HopChar2<CR>', silent)
keymap('v', '<leader>hw', '<cmd>HopWord<CR>', silent)
keymap('v', '<leader>ha', '<cmd>HopAnywhere<CR>', silent)

keymap('n', '<leader>ls', '<Plug>Lightspeed_s', silent)
keymap('n', '<leader>lS', '<Plug>Lightspeed_S', silent)
keymap('n', '<leader>lx', '<Plug>Lightspeed_x', silent)
keymap('n', '<leader>lX', '<Plug>Lightspeed_X', silent)

vim.cmd([[
  nmap <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
  nmap <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
  nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
  nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"
]])

keymap('n', '<S-j>', '<Plug>(columnskip:nonblank:next)', silent)
keymap('v', '<S-j>', '<Plug>(columnskip:nonblank:next)', silent)
keymap('n', '<S-k>', '<Plug>(columnskip:nonblank:prev)', silent)
keymap('v', '<S-k>', '<Plug>(columnskip:nonblank:prev)', silent)

-- g.move_map_keys = 0
g.move_key_modifier = 'C'
g.move_key_modifier_visualmode = 'C'
-- keymap('v', '<C-k>', '<Plug>Translate', silent)

g.translator_target_lang = 'ja'

keymap('n', '<leader>tl', '<Plug>Translate', silent)
keymap('v', '<leader>tl', '<Plug>TranslateV', silent)
keymap('n', '<leader>tw', '<Plug>TranslateW', silent)
keymap('v', '<leader>tw', '<Plug>TranslateWV', silent)
keymap('n', '<leader>tr', '<Plug>TranslateR', silent)
keymap('v', '<leader>tr', '<Plug>TranslateRV', silent)
keymap('n', '<leader>tx', '<Plug>TranslateX', silent)

keymap('i', '<C-f>', '<Right>', silent)
keymap('i', '<C-b>', '<Left>', silent)
keymap('i', '<C-d>', '<Del>', silent)
keymap('i', '<C-h>', '<BS>', silent)
keymap('i', '<C-k>', '<C-O>D', silent)
keymap('i', '<C-j>', '<CR>', silent)

keymap('i', 'jj', '<Esc>', silent)
keymap('i', '縺｣j', '<Esc>', silent)

vim.cmd[[
    inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "ﾂ･<Enter>"
    inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "ﾂ･<Esc>"
]]

-- keymap('i', '<expr><CR> pumvisible() ?', '<C-y>:<CR>', silent)
-- keymap('i', '<C-CR>', '<C-y>', silent)

-- keymap('i', '<expr><CR> pumvisible() ? coc#_select_confirm()', 'ﾂ･<C-g>uﾂ･<CR>ﾂ･<c-r>=coc#on_enter()ﾂ･<CR>', silent)

-- inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
--       ﾂ･: "ﾂ･<C-g>uﾂ･<CR>ﾂ･<c-r>=coc#on_enter()ﾂ･<CR>"
--
-- inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "ﾂ･<C-g>uﾂ･<CR>ﾂ･<c-r>=coc#on_enter()ﾂ･<CR>"
-- inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "ﾂ･<C-x>ﾂ･<C-z>"
-- " remap for complete to use tab and <cr>
-- inoremap <silent><expr> <TAB>
--     ﾂ･ coc#pum#visible() ? coc#pum#next(1):
--     ﾂ･ <SID>check_back_space() ? "ﾂ･<Tab>" :
--     ﾂ･ coc#refresh()
-- inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "ﾂ･<C-h>"
-- inoremap <silent><expr> <c-space> coc#refresh()
--
-- inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "ﾂ･<c-r>=coc#float#scroll(1)ﾂ･<cr>" : "ﾂ･<Right>"
-- inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "ﾂ･<c-r>=coc#float#scroll(0)ﾂ･<cr>" : "ﾂ･<Left>"

-- local lib = require("nvim-tree.lib")
-- local view = require("nvim-tree.view")
--
--
-- local function collapse_all()
--     require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
-- end
--
-- local function edit_or_open()
--     -- open as vsplit on current node
--     local action = "edit"
--     local node = lib.get_node_at_cursor()
--
--     -- Just copy what's done normally with vsplit
--     if node.link_to and not node.nodes then
--         require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
--         view.close() -- Close the tree if file was opened
--
--     elseif node.nodes 窶ｾ= nil then
--         lib.expand_or_collapse(node)
--
--     else
--         require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
--         view.close() -- Close the tree if file was opened
--     end
--
-- end
--
-- local function vsplit_preview()
--     -- open as vsplit on current node
--     local action = "vsplit"
--     local node = lib.get_node_at_cursor()
--
--     -- Just copy what's done normally with vsplit
--     if node.link_to and not node.nodes then
--         require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
--
--     elseif node.nodes 窶ｾ= nil then
--         lib.expand_or_collapse(node)
--
--     else
--         require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
--
--     end
--
--     -- Finally refocus on tree if it was lost
--     view.focus()
-- end
--
-- local config = {
--     view = {
--         mappings = {
--             custom_only = false,
--             list = {
--                 { key = "l", action = "edit", action_cb = edit_or_open },
--                 { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
--                 { key = "h", action = "close_node" },
--                 { key = "H", action = "collapse_all", action_cb = collapse_all }
--             }
--         },
--     },
--     actions = {
--         open_file = {
--             quit_on_open = false
--         }
--     }
-- }

-- keymap("n", "<leader>b", "<cmd>NvimTreeToggle<CR>" , silent)
-- require('nvim-tree').setup(config)

keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', silent)
keymap('n', '<C-p>', '<cmd>Telescope find_files<CR>', silent)
-- keymap('n', '<C-p>', '<cmd>Telescope find_files<CR>', silent)
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', silent)
keymap('n', '<C-g>', '<cmd>Telescope live_grep<CR>', silent)
-- keymap('n', '<C-g>', '<cmd>Telescope live_grep<CR>', silent)
keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', silent)
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', silent)

keymap('n', '<leader>b', '<cmd>Telescope file_browser<CR>', silent)
keymap('n', '<C-b>', '<cmd>Telescope file_browser<CR>', silent)
-- keymap('n', '<C-b>', ':Telescope file_browser', silent)

keymap('n', '<leader><leader>', "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>", silent)
keymap('n', '<C-f>', "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>", silent)
-- keymap('n', '<C-f>', "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>", silent)

keymap('n', '<leader>ma', '<cmd>Telescope vim_bookmarks all<CR>', silent)
keymap('n', '<leader>mm', '<cmd>Telescope vim_bookmarks current_file<CR>', silent)

keymap('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', silent)
keymap('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', silent)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.stage_buffer', silent)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.undo_stage_hunk', silent)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.reset_buffer', silent)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.preview_hunk', silent)
-- keymap('n', '<leader>hS', function() gs.blame_line{full=true} end)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.toggle_current_line_blame', silent)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.diffthis', silent)
-- keymap('n', '<leader>hS', function() gs.diffthis('窶ｾ') end)
keymap('n', '<leader>hS', 'package.loaded.gitsigns.toggle_deleted', silent)

keymap('n', '<leader>co', '<Plug>(git-conflict-ours)', silent)
keymap('n', '<leader>ct', '<Plug>(git-conflict-theirs)', silent)
keymap('n', '<leader>cb', '<Plug>(git-conflict-both)', silent)
keymap('n', '<leader>c0', '<Plug>(git-conflict-none)', silent)
keymap('n', '<leader>]x', '<Plug>(git-conflict-prev-conflict)', silent)
keymap('n', '<leader>[x', '<Plug>(git-conflict-next-conflict)', silent)

keymap('n', '<C-t>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>', silent)
keymap('i', '<C-t>', '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', silent)

keymap('n', '<leader>pp', '<Cmd>Telescope command_palette<CR>', silent)

keymap('n', 'w', '<Plug>CamelCaseMotion_w', silent)
keymap('n', 'b', '<Plug>CamelCaseMotion_b', silent)
keymap('n', 'e', '<Plug>CamelCaseMotion_e', silent)
keymap('n', 'ge', '<Plug>CamelCaseMotion_ge', silent)

keymap('n', '*', '<Plug>(asterisk-*)', silent)
keymap('n', '#', '<Plug>(asterisk-#)', silent)
keymap('n', 'g*', '<Plug>(asterisk-g*)', silent)
keymap('n', 'g#', '<Plug>(asterisk-g#)', silent)
keymap('n', 'z*', '<Plug>(asterisk-z*)', silent)
keymap('n', 'gz*', '<Plug>(asterisk-gz*)', silent)
keymap('n', 'z#', '<Plug>(asterisk-z#)', silent)
keymap('n', 'gz#', '<Plug>(asterisk-gz#)', silent)

keymap('n', '<leader>cl', ':CocList<CR>', silent)
keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', silent)
keymap('n', ']g', '<Plug>(coc-diagnostic-next)', silent)
keymap('n', 'gd', '<Plug>(coc-definition)', silent)
keymap('n', 'gy', '<Plug>(coc-type-definition)', silent)
keymap('n', 'gi', '<Plug>(coc-implementation)', silent)
keymap('n', 'gr', '<Plug>(coc-references)', silent)
keymap('n', '<leader>rn', '<Plug>(coc-rename)', silent)
keymap('n', '<leader>fm', '<Plug>(coc-format)', silent)
keymap('n', '<leader>a', '<Plug>(coc-codeaction-selected)', silent)
keymap('n', '<leader>ac', '<Plug>(coc-codeaction)', silent)
keymap('n', '<leader>qf', '<Plug>(coc-fix-current)', silent)

keymap('n', '<leader>he', ':vertical help ', silent)

keymap("n", "H", "<Cmd>BufferLineCyclePrev<CR>", silent)
keymap("n", "L", "<Cmd>BufferLineCycleNext<CR>", silent)
-- keymap("n", "@", "<Cmd>BufferLineMovePrev<CR>", silent)
-- keymap("n", "#", "<Cmd>BufferLineMoveNext<CR>", silent)
-- keymap("n", "<C-S-h>", "<Cmd>BufferLineMovePrev<CR>", silent)
-- keymap("n", "<C-S-l>", "<Cmd>BufferLineMoveNext<CR>", silent)

keymap("n", "<leader>mp", "<Cmd>BufferLineMovePrev<CR>", silent)
keymap("n", "<leader>mn", "<Cmd>BufferLineMoveNext<CR>", silent)
keymap("n", "<leader>tp", "<Cmd>BufferLineTogglePin<CR>", silent)
keymap("n", "<leader>d", "<Cmd>Bdelete<CR>", silent)
keymap("n", "<leader>pc", "<Cmd>BufferLinePickClose<CR>", silent)

keymap("n", "go", "<Cmd>Sort<CR>", silent)

keymap("n", "<leader>sf", "<Cmd>set fenc=<CR>", silent)

-- nnoremap <silent> go" vi"<Esc><Cmd>Sort<CR>
-- nnoremap <silent> go' vi'<Esc><Cmd>Sort<CR>
-- nnoremap <silent> go( vi(<Esc><Cmd>Sort<CR>
-- nnoremap <silent> go[ vi[<Esc><Cmd>Sort<CR>
-- nnoremap <silent> gop vip<Esc><Cmd>Sort<CR>
-- nnoremap <silent> go{ vi{<Esc><Cmd>Sort<CR>

vim.keymap.set("n", "<Leader>1", function()
  require("bufferline").go_to_buffer(1, true)
end, silent)

vim.keymap.set("n", "<Leader>1", function()
  require("bufferline").go_to_buffer(1, true)
end, silent)
vim.keymap.set("n", "<Leader>2", function()
  require("bufferline").go_to_buffer(2, true)
end, silent)
vim.keymap.set("n", "<Leader>3", function()
  require("bufferline").go_to_buffer(3, true)
end, silent)
vim.keymap.set("n", "<Leader>4", function()
  require("bufferline").go_to_buffer(4, true)
end, silent)
vim.keymap.set("n", "<Leader>5", function()
  require("bufferline").go_to_buffer(5, true)
end, silent)
vim.keymap.set("n", "<Leader>6", function()
  require("bufferline").go_to_buffer(6, true)
end, silent)
vim.keymap.set("n", "<Leader>7", function()
  require("bufferline").go_to_buffer(7, true)
end, silent)
vim.keymap.set("n", "<Leader>8", function()
  require("bufferline").go_to_buffer(8, true)
end, silent)
vim.keymap.set("n", "<Leader>9", function()
  require("bufferline").go_to_buffer(9, true)
end, silent)
