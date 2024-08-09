return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        -- Helper function to setup keybindings when an LSP server attaches to a buffer
        local function on_attach(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- Keymaps for LSP actions
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)

            vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
        end

        -- Capabilities configuration for completion
        local function setup_capabilities()
            local cmp_lsp = require("cmp_nvim_lsp")
            return vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )
        end

        -- Setup each LSP server
        local function setup_lsp_servers()
            local lspconfig = require("lspconfig")
            local capabilities = setup_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ruff",
                    "rust_analyzer",
                },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup {
                            capabilities = capabilities,
                            on_attach = on_attach,
                        }
                    end,

                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    runtime = { version = "Lua 5.1" },
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,
                }
            })
        end

        -- Setup completion with nvim-cmp
        local function setup_cmp()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
        end

        -- Setup diagnostic display options
        local function setup_diagnostics()
            vim.diagnostic.config({
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end

        -- Initialize all setups
        local function setup()
            require("fidget").setup({})
            require("mason").setup()
            setup_lsp_servers()
            setup_cmp()
            setup_diagnostics()
        end

        setup()
    end
}

