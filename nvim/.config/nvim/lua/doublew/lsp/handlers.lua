local M = {}

local buf_nnoremap = require("doublew.keymap").buf_nnoremap

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
    local config = {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        -- local lsp_hl_group = vim.api.nvim.create_augroup("lsp_document_highlight", { clear = true })
        -- vim.api.nvim_create_autocmd("CursorHold", {
        --     pattern = {"<buffer>"},
        --     command = "lua vim.lsp.buf.document_highlight()",
        --     group = lsp_hl_group,
        -- })

        -- vim.api.nvim_create_autocmd("CursorMoved", {
        --     pattern = {"<buffer>"},
        --     command = "lua vim.lsp.buf.clear_references()",
        --     group = lsp_hl_group,
        -- })
        vim.api.nvim_exec(
            [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]]   ,
            false
        )
    end
end

local function lsp_keymaps(bufnr)
    buf_nnoremap(bufnr, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    buf_nnoremap(bufnr, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    buf_nnoremap(bufnr, "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    buf_nnoremap(bufnr, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    buf_nnoremap(bufnr, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    -- buf_nnoremap(bufnr, "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    buf_nnoremap(bufnr, "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    -- buf_nnoremap(bufnr, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    -- buf_nnoremap(bufnr, "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>")
    buf_nnoremap(bufnr, "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
    -- buf_nnoremap(bufnr, "gl", '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>')
    buf_nnoremap(bufnr, "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>')
    buf_nnoremap(bufnr, "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
    buf_nnoremap(bufnr, "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]]
end

M.on_attach = function(client, bufnr)
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M