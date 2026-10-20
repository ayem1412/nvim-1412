-- Keymaps that exist only in buffers with a language server attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("cfg_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("gd", function() Snacks.picker.lsp_definitions() end, "Goto definition")
    map("gD", function() Snacks.picker.lsp_declarations() end, "Goto declaration")
    map("gr", function() Snacks.picker.lsp_references() end, "References")
    map("gI", function() Snacks.picker.lsp_implementations() end, "Goto implementation")
    map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto type definition")
    map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
    map("gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
    map("<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help", "i")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")

    -- Inlay hints off by default, toggle with <leader>uh
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
    end
  end,
})
