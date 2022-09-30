-- Autoformat on save
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

-- LSP Keybindings
local set_lsp_definition = function()
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true })
end

local function set_lsp_references()
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true })
end

local custom_lsp_attach = function()
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>s', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>a', '<cmd>lua vim.lsp.buf.hover_actions()<CR>', { noremap = true })
  set_lsp_definition()
  set_lsp_references()

  -- Use LSP as the handler for formatexpr.
  --    See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
end


--Enable (broadcasting) snippet capability and completion
local capabilities = require 'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- RUST LSP
local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.4/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

local rt = require("rust-tools")
rt.setup({
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
      codelldb_path, liblldb_path)
  },
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>s", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      -- Global lsp apis
      set_lsp_definition()
      set_lsp_references()
    end,
  },
})

-- Rust debugging
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("dapui").setup()
--

-- LUA LSP
require('lspconfig').sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      format = {
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        }
      }
    }
  },

  on_attach = custom_lsp_attach
})
--

-- TYPESCRIPT LSP
require("lspconfig").tsserver.setup({
  on_attach = custom_lsp_attach,
  capabilities = capabilities,
  init_options = {
    hostInfo = "neovim",
    plugins = { {
      name = "typescript-styled-plugin",
      location = "/Users/nate/usr/node-v14.18.2-darwin-x64/lib/node_modules/typescript-styled-plugin"
    } }
  }
})
--


-- HTML LSP
require 'lspconfig'.html.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach
}

-- ESLint LSP
require 'lspconfig'.eslint.setup {
  on_attach = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>fr', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true })
  end
}

-- CSS LSP
require 'lspconfig'.cssls.setup {
  capabilities = capabilities
}
