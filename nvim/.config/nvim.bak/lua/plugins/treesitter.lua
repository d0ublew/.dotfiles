return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		-- lazy = true,
		dependencies = {
			{
				"nvim-treesitter/playground",
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			{
				"nvim-treesitter/nvim-treesitter-context",
				keys = function()
					local lazy_keymap = require("doublew.keymap").lazy_keymap
					return {
						lazy_keymap("<leader>tc", "<cmd>TSContextToggle<CR>", {
							mode = "n",
							desc = "[T]reesitter [C]ontext toggle",
						}),
					}
				end,

				config = function(_, opts)
					require("treesitter-context").setup(opts)
				end,
				opts = {
					enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
					max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
					trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
					patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
						-- For all filetypes
						-- Note that setting an entry here replaces all other patterns for this entry.
						-- By setting the 'default' entry below, you can control which nodes you want to
						-- appear in the context window.
						default = {
							"class",
							"function",
							"method",
							"for",
							"while",
							"if",
							"switch",
							"case",
						},
						-- Patterns for specific filetypes
						-- If a pattern is missing, *open a PR* so everyone can benefit.
						tex = {
							"chapter",
							"section",
							"subsection",
							"subsubsection",
						},
						rust = {
							"impl_item",
							"struct",
							"enum",
						},
						scala = {
							"object_definition",
						},
						vhdl = {
							"process_statement",
							"architecture_body",
							"entity_declaration",
						},
						markdown = {
							"section",
						},
						elixir = {
							"anonymous_function",
							"arguments",
							"block",
							"do_block",
							"list",
							"map",
							"tuple",
							"quoted_content",
						},
					},
					exact_patterns = {
						-- Example for a specific filetype with Lua patterns
						-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
						-- exactly match "impl_item" only)
						-- rust = true,
					},

					-- [!] The options below are exposed but shouldn't require your attention,
					--     you can safely ignore them.

					zindex = 20, -- The Z-index of the context window
					mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
					-- Separator between context and content. Should be a single character string, like '-'.
					-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
					separator = nil,
				},
			},
		},
		build = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		opts = {
			--[[ ensure_installed = "all", ]]
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"dockerfile",
				"vimdoc",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			sync_install = false,
			highlight = {
				enable = true,
				disable = function(_, bufnr)
					return vim.api.nvim_buf_line_count(bufnr) > 5000
				end,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<cr>",
					node_incremental = "<cr>",
					scope_incremental = "<c-space>",
					node_decremental = "<bs>",
				},
			},
			indent = { enable = true, disable = { "yaml" } },
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = false, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["]a"] = "@parameter.inner",
					},
					swap_previous = {
						["[a"] = "@parameter.inner",
					},
				},
			},
		},
	},
}
