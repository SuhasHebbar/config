local u = require('utils')

local M = {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim',       opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing
    { 'folke/neodev.nvim',       config = true },
  },
}

function M.config()
  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  local servers = {
    clangd = {},
    gopls = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = false,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
    pyright = {
      pyright = {
        inlayHints = {
          functionReturnTypes = true,
          variableTypes = true
        },
      },
    },
    rust_analyzer = {},
    bashls = {
      bashIde = {
        shellcheckPath = u.mason_bin_path .. '/shellcheck' .. u.mason_cmd_suffix
      },
    },
    tsserver = {},
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  -- gopls installation needs go installed.
  if vim.fn.executable('go') ~= 1 then
    servers.gopls = nil
  end

  -- Pyright LSP installations needs npm available.
  if vim.fn.executable('npm') ~= 1 then
    servers.pyright = nil
    servers.bashls = nil
  end

  local servers_autostart = {}
  for k, _v in pairs(servers) do
    servers_autostart[k] = true
  end

  -- Do not autostart the following servers. We want opening lua or sh file to be quick and lightweight by default.
  -- servers_autostart.bashls = false
  -- Autostart lua ls if current working directory in nvim config dir
  -- We use resolve to expand symlinks since stdpath doesn't seem to do it.
  servers_autostart.lua_ls = vim.fn.getcwd() == vim.fn.resolve(vim.fn.stdpath('config'))



  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Setup mason so it can manage external tooling
  require('mason').setup()

  do
    local Registry = require('mason-registry')
    local shellcheck = Registry.get_package('shellcheck')
    if not shellcheck:is_installed() then
      shellcheck:install({})
    end
  end

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  -- LSP settings.
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end

  local function setup_rust_tools()
    local rt = require("rust-tools")
    local codelldb_path = u.mason_bin_path .. '/codelldb' .. u.mason_cmd_suffix
    local liblldb_path

    if u.win32 then
      -- codelldb crashes if you pass linux style paths to --liblldb hence we sanitize.
      liblldb_path = u.get_os_path(u.mason_path .. '/packages/codelldb/extension/lldb/bin/liblldb.dll')
    else
      liblldb_path = u.mason_path .. '/packages/codelldb/extension/lldb/lib/liblldb.so'
    end

    local opts = {
      dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(
          codelldb_path, liblldb_path)
      },
      -- Stuff in server goes into lspconfig.setup I think.
      server = {
        root_dir = function(...)
          local lspconfig_ra = require('lspconfig.server_configurations.rust_analyzer')
          local lspconfig_util = require('lspconfig.util')
          local unsanitized_rootdir = lspconfig_ra.default_config.root_dir(...)
          return lspconfig_util.path.sanitize(unsanitized_rootdir)
        end,
        capabilities = capabilities,
        on_attach = function(c, bufnr)
          on_attach(c, bufnr)

          -- Hover actions
          vim.keymap.set("n", 'K', rt.hover_actions.hover_actions, { buffer = bufnr, desc = 'LSP: Hover Documentation' })
          -- Code action groups
          vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group,
            { buffer = bufnr, desc = 'LSP: [C]ode [A]ction' })
        end,
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              -- bug: https://github.com/simrat39/rust-tools.nvim/issues/300
              locationLinks = false
            },
          },
        },
      },
    }

    rt.setup(opts)
  end

  vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
      -- We let rust-tools.nvim handle inlay hints for go.
      if vim.bo.filetype == 'rust' then
        return
      end

      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      require("lsp-inlayhints").on_attach(client, bufnr)
    end,
  })

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      })
    end,
    rust_analyzer = setup_rust_tools,
  }

  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end

return M
