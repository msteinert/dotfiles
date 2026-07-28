-- vim.pack is the built-in plugin manager (Neovim 0.11+).
-- Update plugins: :lua vim.pack.update()
-- Check health:  :checkhealth

local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- OPTIONS
-- ============================================================
do
  vim.loader.enable()

  vim.g.mapleader      = ' '
  vim.g.maplocalleader = ' '
  vim.g.have_nerd_font = false

  vim.o.number       = true
  vim.o.mouse        = 'a'
  vim.o.showmode     = false
  vim.o.breakindent  = true
  vim.o.undofile     = true
  vim.o.ignorecase   = true
  vim.o.smartcase    = true
  vim.o.signcolumn   = 'yes'
  vim.o.updatetime   = 250
  vim.o.timeoutlen   = 300
  vim.o.splitright   = true
  vim.o.splitbelow   = true
  vim.o.inccommand   = 'split'
  vim.o.cursorline   = true
  vim.o.scrolloff    = 10
  vim.o.confirm      = true
  vim.o.wrap         = false
  vim.o.nojoinspaces = true
  vim.o.cinoptions   = ':0'
  vim.o.history      = 1000
  vim.o.list         = true
  vim.opt.listchars  = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.opt.wildignore:append { '*.o', '*.lo' }

  -- Sync clipboard with OS
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
end

-- ============================================================
-- KEYMAPS & AUTOCMDS
-- ============================================================
do
  -- Clear search highlight on <Esc>
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Window navigation (matches vimrc S-hjkl and adds C-hjkl)
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })
  vim.keymap.set('n', '<S-h>', '<C-w>h', { desc = 'Focus left window' })
  vim.keymap.set('n', '<S-l>', '<C-w>l', { desc = 'Focus right window' })
  vim.keymap.set('n', '<S-j>', '<C-w>j', { desc = 'Focus lower window' })
  vim.keymap.set('n', '<S-k>', '<C-w>k', { desc = 'Focus upper window' })

  -- Window resize
  vim.keymap.set('n', '<S-Up>',    '<cmd>resize +1<CR>')
  vim.keymap.set('n', '<S-Down>',  '<cmd>resize -1<CR>')
  vim.keymap.set('n', '<S-Right>', '<cmd>vertical resize +1<CR>')
  vim.keymap.set('n', '<S-Left>',  '<cmd>vertical resize -1<CR>')

  -- Buffer navigation
  vim.keymap.set('n', '<F5>', '<cmd>bprevious!<CR>', { desc = 'Previous buffer' })
  vim.keymap.set('n', '<F6>', '<cmd>bnext!<CR>',     { desc = 'Next buffer' })
  vim.keymap.set('n', '<F7>', '<cmd>bdelete!<CR>',   { desc = 'Delete buffer' })

  -- Quickfix navigation
  vim.keymap.set('n', '<F9>',  '<cmd>cprev!<CR>', { desc = 'Previous quickfix' })
  vim.keymap.set('n', '<F10>', '<cmd>cnext!<CR>', { desc = 'Next quickfix' })

  -- Q formats instead of Ex mode
  vim.keymap.set('n', 'Q', 'gq')

  -- Kill trailing whitespace
  vim.keymap.set('n', '<leader>kw', '<cmd>%s/\\s\\+$//<CR>', { desc = '[K]ill trailing [W]hitespace' })

  -- Diagnostic keymaps
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort    = true,
    float            = { border = 'rounded', source = 'if_many' },
    underline        = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text     = true,
    virtual_lines    = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
      end,
    },
  }
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Terminal mode escape
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Autocmds
  local augroup = vim.api.nvim_create_augroup

  -- Highlight on yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    group    = augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- Jump to last known cursor position
  vim.api.nvim_create_autocmd('BufReadPost', {
    group    = augroup('last-cursor', { clear = true }),
    callback = function()
      local row = vim.fn.line '\'"'
      if row > 1 and row <= vim.fn.line '$' then
        vim.cmd 'normal! g`"'
      end
    end,
  })

  -- Open all folds on enter
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group    = augroup('open-folds', { clear = true }),
    callback = function() vim.cmd 'normal! zR' end,
  })

  -- Highlight trailing whitespace
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'InsertLeave' }, {
    group    = augroup('trailing-ws', { clear = true }),
    callback = function() vim.fn.matchadd('ExtraWhitespace', '\\s\\+$') end,
  })
  vim.api.nvim_create_autocmd('InsertEnter', {
    group    = augroup('trailing-ws-insert', { clear = true }),
    callback = function() vim.fn.clearmatches() end,
  })
  vim.cmd 'highlight ExtraWhitespace ctermbg=red guibg=#cc9393'

  -- Per-language indent
  vim.api.nvim_create_autocmd('FileType', {
    group   = augroup('filetype-indent', { clear = true }),
    pattern = { 'cmake', 'cpp', 'css', 'javascript', 'ruby', 'typescript' },
    callback = function()
      vim.bo.tabstop     = 8
      vim.bo.shiftwidth  = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab   = true
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group   = augroup('filetype-indent-4', { clear = true }),
    pattern = { 'html', 'python', 'sh', 'zsh' },
    callback = function()
      vim.bo.tabstop     = 8
      vim.bo.shiftwidth  = 4
      vim.bo.softtabstop = 4
      vim.bo.expandtab   = true
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group   = augroup('filetype-sql', { clear = true }),
    pattern = 'sql',
    callback = function()
      vim.bo.tabstop     = 2
      vim.bo.shiftwidth  = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab   = true
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group   = augroup('filetype-markdown', { clear = true }),
    pattern = 'markdown',
    callback = function()
      vim.bo.tabstop     = 8
      vim.bo.shiftwidth  = 4
      vim.bo.softtabstop = 4
      vim.bo.expandtab   = true
      vim.bo.textwidth   = 76
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group   = augroup('filetype-text', { clear = true }),
    pattern = 'text',
    callback = function() vim.bo.textwidth = 78 end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    group   = augroup('filetype-qf', { clear = true }),
    pattern = 'qf',
    callback = function()
      vim.wo.wrap      = true
      vim.wo.linebreak = true
    end,
  })
end

-- ============================================================
-- BUILD HOOKS (for vim.pack)
-- ============================================================
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local output = result.stderr ~= '' and result.stderr or result.stdout
      vim.notify(('Build failed for %s:\n%s'):format(name, output or ''), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
      elseif name == 'LuaSnip' and vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
      elseif name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
      end
    end,
  })
end

-- ============================================================
-- UI PLUGINS
-- ============================================================
do
  -- Detect and set indentation automatically
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Git signs in the gutter
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add          = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change       = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete       = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete    = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Show pending keybinds
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec  = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { 'gr',        group = 'LSP Actions' },
    },
  }

  -- Zenburn colorscheme
  vim.pack.add { gh 'phha/zenburn.nvim' }
  require('zenburn').setup()

  -- Highlight todo/fixme/note comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- mini.nvim collection
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better text objects (va), yiiq, ci', etc.)
  require('mini.ai').setup {
    mappings = { around_next = 'aa', inside_next = 'ii' },
    n_lines  = 500,
  }

  -- surround (replaces vim-surround: saiw), sd', sr)')
  require('mini.surround').setup()

  -- Statusline (replaces lightline)
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  -- File tree (replaces NERDTree)
  vim.pack.add {
    gh 'nvim-neo-tree/neo-tree.nvim',
    gh 'MunifTanjim/nui.nvim',
  }
  require('neo-tree').setup {
    filesystem = {
      filtered_items = { visible = true }, -- show hidden files (like NERDTreeShowHidden)
    },
    window = { width = 39 },               -- match NERDTreeWinSize
  }
  vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle<CR>', { desc = 'Toggle file tree' })

  -- Fugitive (git commands)
  vim.pack.add { gh 'tpope/vim-fugitive' }
end

-- ============================================================
-- SEARCH & NAVIGATION (Telescope)
-- ============================================================
do
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then
    table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim')
  end
  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require 'telescope.builtin'

  -- Matches old FZF mappings
  vim.keymap.set('n', '<leader>fo', function()
    local root = vim.fn.systemlist('git rev-parse --show-toplevel 2>/dev/null')[1]
    builtin.find_files { cwd = root ~= '' and root or vim.fn.getcwd() }
  end, { desc = 'Find files from git root' })
  vim.keymap.set('n', '<leader>fi', builtin.buffers,    { desc = 'Find existing buffers' })
  vim.keymap.set('n', '<leader>f',  builtin.find_files, { desc = 'Find files' })

  -- Additional telescope pickers
  vim.keymap.set('n', '<leader>sh', builtin.help_tags,  { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps,    { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep,  { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics,{ desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume,     { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles,   { desc = '[S]earch recent files' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = 'Fuzzy search current buffer' })

  -- LSP pickers wired up on LspAttach (see LSP section)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'grr', builtin.lsp_references,              { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', builtin.lsp_implementations,         { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', builtin.lsp_definitions,             { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gO',  builtin.lsp_document_symbols,        { buffer = buf, desc = 'Document symbols' })
      vim.keymap.set('n', 'gW',  builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Workspace symbols' })
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions,        { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })
end

-- ============================================================
-- LSP
-- ============================================================
do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('grn', vim.lsp.buf.rename,       '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action,  '[G]oto Code [A]ction', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration,  '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local hi_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf, group = hi_group, callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf, group = hi_group, callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
          callback = function(ev2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = ev2.buf }
          end,
        })
      end

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  ---@type table<string, vim.lsp.Config>
  local servers = {
    gopls        = {},
    rust_analyzer = {},
    clangd       = {},
    ts_ls        = {},
    ruby_lsp     = {},
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config'
            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
          then return end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime  = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library', '${3rd}/busted/library',
            }),
          },
        })
      end,
      settings = { Lua = { format = { enable = false } } },
    },
    stylua = {},
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}
  require('mason-lspconfig').setup { automatic_enable = false }
  require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- FORMATTING (conform.nvim)
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error  = false,
    format_on_save   = function(bufnr)
      local auto_fmt = { go = true, rust = true, lua = true }
      if auto_fmt[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
    end,
    default_format_opts = { lsp_format = 'fallback' },
    formatters_by_ft = {
      go   = { 'goimports' },
      rust = { 'rustfmt' },
      c    = { 'clang-format' },
      cpp  = { 'clang-format' },
      lua  = { 'stylua' },
    },
  }

  -- <leader>f formats; C/C++ also has this mapped by filetype for clang-format
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format { async = true }
  end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- COMPLETION & SNIPPETS (blink.cmp + LuaSnip)
-- ============================================================
do
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap     = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
    sources    = { default = { 'lsp', 'path', 'snippets' } },
    snippets   = { preset = 'luasnip' },
    fuzzy      = { implementation = 'lua' },
    signature  = { enabled = true },
  }
end

-- ============================================================
-- TREESITTER
-- ============================================================
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local parsers = {
    'bash', 'c', 'cpp', 'diff', 'go', 'html', 'lua', 'luadoc',
    'markdown', 'markdown_inline', 'query', 'rust', 'toml', 'vim', 'vimdoc',
  }
  require('nvim-treesitter').install(parsers)

  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)
    if vim.treesitter.query.get(language, 'indents') ~= nil then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end
      local installed = require('nvim-treesitter').get_installed 'parsers'
      if vim.tbl_contains(installed, language) then
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available, language) then
        require('nvim-treesitter').install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- vim: ts=2 sts=2 sw=2 et
