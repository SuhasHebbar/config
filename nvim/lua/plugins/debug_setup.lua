local u = require('utils')

-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'jbyuki/one-small-step-for-vimkind',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    require('mason-nvim-dap').setup_handlers()

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F1>', dap.step_into)
    vim.keymap.set('n', '<F2>', dap.step_over)
    vim.keymap.set('n', '<F3>', dap.step_out)
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏭',
          step_over = '⏎',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close


    vim.keymap.set('v', '<M-k>', dapui.eval, { silent = true, noremap = true, expr = false })
    vim.keymap.set('n', '<M-w>', dapui.toggle, { silent = true, noremap = true, expr = false })

    -- Install golang specific config
    require('dap-go').setup()

    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = u.mason_bin_path .. '/OpenDebugAD7' .. u.mason_cmd_suffix,
      options = {
        detached = false,
      },
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = u.mason_bin_path .. '/codelldb' .. u.mason_cmd_suffix,
        args = { "--port", "${port}" },

        -- On windows you may have to uncomment this:
        detached = false,
      },
    }

    dap.configurations.cpp = {
      {
        name = "codelldb Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = "cppdbg Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = false,
        externalConsole = true
      },
    }

    -- If you want to use this for Rust and C, add something like this:
    dap.configurations.c = dap.configurations.cpp

    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
      }
    }

    local osv_default_port = 8086
    local osv_default_host = "127.0.0.1"

    dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or osv_default_host, port = config.port or osv_default_port})
    end

    vim.api.nvim_create_user_command('Osv', function(opts)
      local port = osv_default_port
      if type(opts.fargs[1]) == 'number' then
        port = opts.fargs[1]
      end

      require('osv').launch({ port = port, host = osv_default_host })
    end, {})

    require('dap.ext.vscode').load_launchjs()
  end,
}
