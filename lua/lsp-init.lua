-- Autoformat on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

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
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true })
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
local custom_lsp_attach = function()
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>s', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true })

  -- Use LSP as the handler for formatexpr.
  --    See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  -- For plugins with an `on_attach` callback, call them here. For example:
  -- require('completion').on_attach()
end

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
  on_attach = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>s', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>a', '<cmd>lua vim.lsp.buf.hover_actions()<CR>', { noremap = true })
  end
})
--

-- HTML LSP
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require 'lspconfig'.html.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach
}
