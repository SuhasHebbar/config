vim.lsp.set_log_level("debug")
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local win32 = vim.fn.has('win32') == 1

local mason_path = vim.fn.stdpath('data') .. '/mason'
local mason_bin_path = mason_path .. '/bin'
local mason_cmd_suffix = ''

if win32 then
  mason_cmd_suffix = '.cmd'
end

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

local is_gui = vim.fn.exists('g:GuiLoaded')

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  require('plugins.lsp_setup'),
  require('plugins.debug_setup'),
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',          opts = {} },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  -- Fancier statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        -- icons_enabled = false,
        theme = 'gruvbox',
      },
      tabline = {
        lualine_a = { { 'buffers', buffers_color = { active = { bg = '#ffffff' }, }, symbols = { alternate_file = '' } }, },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff',
          { 'diagnostics', sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', }, colored = true,
            always_visible = false } },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    }
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} }, },
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-dap.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `cmake` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    cond = function()
      return vim.fn.executable 'cmake' == 1
    end,
  },
  require('plugins.treesitter_setup'),
  -- #Theme
  { 'folke/tokyonight.nvim',     lazy = false, priority = 1000 },
  -- Auto insert matching brackets
  {
    "windwp/nvim-autopairs",
    opts = {}
  },
  -- Auto set file indent with :DetectIndent
  'ciaranm/detectindent',

  -- nvim-cmp source for filesystem paths.
  'hrsh7th/cmp-path',

  -- nvim-cmp source for local buffer keywords.
  'hrsh7th/cmp-buffer',
  { 'simrat39/inlay-hints.nvim', opts = {} },
  'simrat39/rust-tools.nvim',
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = 'Neotree',
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-tree/nvim-web-devicons", opts = {} }, -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require('neo-tree').setup({
        window = {
          mappings = {
            ["o"] = "open",
          }
        }
      })
    end,
  },
  "samjwill/nvim-unception",
}, { defaults = { lazy = false, }, })

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.wo.signcolumn = 'yes'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Set colorscheme
-- #Theme
vim.o.background = 'dark'

-- Hide vim welcome screen
vim.o.shm = vim.o.shm .. 'I'

require('tokyonight').setup({
  style = 'night',
  on_colors = function(colors)
    -- Override background to be dark.
    colors.bg = '#000000'
  end,
  on_highlights = function(highlights, _colors)
    highlights.MiniStatuslineModeNormal.bg = '#fceea7'
  end,
})
vim.cmd [[colorscheme tokyonight]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.env.MYLUARC = vim.fn.stdpath('config') .. '/init.lua'
vim.wo.relativenumber = true
-- vim.wo.backspace = 'indent,eol,start'
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menuone,noinsert,noselect'

vim.keymap.set('n', '<C-s>', ':w<cr>', {})
vim.keymap.set('n', '<C-t>', ':enew<cr>', {})

vim.keymap.set('n', '<M-2>', ':bnext!<cr>', {})
vim.keymap.set('n', '<C-Tab>', ':bnext!<cr>', {})

vim.keymap.set('n', '<M-1>', ':bprevious!<cr>', {})
vim.keymap.set('n', '<C-S-Tab>', ':bprevious!<cr>', {})

vim.keymap.set('n', '<C-w>', ':bp <BAR> bd! #<CR>', {})

vim.keymap.set('n', '<C-b>', ':Neotree toggle<CR>')

-- Handle terminal mode shenanigans
-- 't' to set mapping for terminal mode. <C-\><C-N> to leave terminal mode and
-- enter back to normal mode which we then follow with normal mode buffer change commands.
vim.keymap.set('t', '<M-2>', '<C-\\><C-N>:bnext!<cr>', { noremap = true })
vim.keymap.set('t', '<M-1>', '<C-\\><C-N>:bprevious!<cr>', { noremap = true })

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { noremap = true })

-- BufEnter event doesn't seem to be triggered when the terminal opens so we also include TermOpen.
-- We need BufEnter since alt tabbing away from the terminal puts it back to normal mode
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  pattern = { 'term://*' },
  command = 'startinsert',
})


-- require("dapui").setup({
--   -- Expand lines larger than the window
--   -- Requires >= 0.7
--   expand_lines = vim.fn.has("nvim-0.7") == 1,
--   -- Layouts define sections of the screen to place windows.
--   -- The position can be "left", "right", "top" or "bottom".
--   -- The size specifies the height/width depending on position. It can be an Int
--   -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
--   -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
--   -- Elements are the elements shown in the layout (in order).
--   -- Layouts are opened in order so that earlier layouts take priority in window sizing.
--   layouts = {
--     {
--       elements = {
--         -- Elements can be strings or table with id and size keys.
--         { id = "scopes", size = 0.25 },
--         "breakpoints",
--         "stacks",
--         "watches",
--       },
--       size = 40, -- 40 columns
--       position = "left",
--     },
--     {
--       elements = {
--         "repl",
--         "console",
--       },
--       size = 0.25, -- 25% of total lines
--       position = "bottom",
--     },
--   },
--   controls = {
--     -- Requires Neovim nightly (or 0.8 when released)
--     enabled = true,
--     -- Display controls in this element
--     element = "repl",
--     icons = {
--       pause = "P",
--       play = ">",
--       step_into = "I",
--       step_over = "-",
--       step_out = "O",
--       step_back = "B",
--       run_last = "L",
--       terminate = "X",
--     },
--   },
--   floating = {
--     max_height = nil, -- These can be integers or a float between 0 and 1.
--     max_width = nil, -- Floats will be treated as percentage of your screen.
--     border = "single", -- Border style. Can be "single", "double" or "rounded"
--     mappings = {
--       close = { "q", "<Esc>" },
--     },
--   },
--   windows = { indent = 1 },
--   render = {
--     max_type_length = nil, -- Can be integer or nil.
--     max_value_lines = 100, -- Can be integer or nil.
--   }
-- })

-- detectindent
-- https://www.vim.org/scripts/script.php?script_id=1171
vim.api.nvim_create_autocmd({ 'BufReadPost' }, { pattern = { '*' }, command = 'DetectIndent' })

-- Shortcut to format file and detect indent.
vim.keymap.set('n', '<leader>e', ':Format<cr> <bar> :DetectIndent<cr>')

vim.api.nvim_create_user_command('H', function(opts)
  vim.cmd.help(opts.args)
  vim.cmd.only()
  -- vim.cmd('help ' .. opts.args .. ' | only')
end, { nargs = '*' })

-- Source :help shell-powershell & https://github.com/neovim/neovim/issues/11437
-- To fix issues in :terminal when using powershell on windows
if win32 then
  vim.cmd([[
    let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
  ]])
end

-- Help command that opens help in a new persistent full screen buffer
vim.api.nvim_create_user_command('H', function(opts)
  local ok, result = pcall(vim.cmd.help, opts.args)
  if ok then
    local helpfile = vim.api.nvim_buf_get_name(0)
    vim.cmd.helpclose()
    vim.cmd('silent noautocmd keepalt e ' .. helpfile)
  elseif type(result) == 'string' then
    vim.api.nvim_err_writeln(result)
  end
end, { nargs = '*' })



-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable( -1) then
        luasnip.jump( -1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
