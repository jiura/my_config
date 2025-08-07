-- Greeter

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.cursorline = false

		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			callback = function()
				vim.wo.number = true
				vim.wo.relativenumber = true
				vim.wo.cursorline = true
			end
		})

		local current_buf = 0
		local greeter_text = {
			"     ⠀⠀⠀⠀⠀⠀⢀⡤⡜⠧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⣟⡵⣔⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠞⠁⢳⠤⣤⡀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣀⣨⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠯⣀⠀⠀⠀⣀⣤⢿⠯⣉⣳⠀⠀⠀⠀⠀⠀⠀⠈⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⣠⢤⠠⣿⣨⠧⠀⠀⠙⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡄⡀⠀⠹⣗⣿⣹⣧⠻⠤⠤⡀⠀⠘⣆⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣿⣯⢧⡀⠀⣏⣟⡟⠋⠀⠀⢠⣼⡴⠚⠉⠀⠀⠀⠀⠉⠙⠒⠤⠤⠤⠤⣄⡀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢯⢿⡇⠰⣿⣾⠋⠀⠀⠀⢹⡿⠁⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠈⠲⡀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⡄⡿⢁⣶⣴⡾⠁⠀⡇⠀⠀⠀⠀⠀⠀⠀⠸⠟⠀⠀⠀⠀⠀⠀⠀⠀⠹⡀⠀⠀",
			"     ⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢭⣾⣵⣦⡻⣇⢸⣿⡯⠃⣄⣀⡹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀",
			"     ⢤⡾⢻⣤⠄⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠟⠛⠻⣾⠉⠰⣦⣿⡿⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣣⣾⣷⣆⡇⠀⠀",
			"     ⠘⠊⠻⠆⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣄⢀⠀⠀⢹⣠⣚⣿⣿⠟⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⢠⢯⣾⣿⣿⣿⣿⣇⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⣾⣖⢤⡈⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠹⡆⠀⠀⠀⠀⠀⡾⣾⣿⣿⣿⣿⡟⡞⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣨⣿⢿⢝⢮⡉⠉⠛⢷⣿⠁⠀⠀⣀⣠⡀⠀⠀⠀⠀⠹⡄⠀⠀⢰⠞⢳⡹⣿⣿⡿⢟⡴⠃⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡘⡼⣍⣧⡇⠀⠀⠈⣿⠀⣶⣶⣿⣿⠏⠀⠀⠀⠀⠠⣧⣴⠶⠛⠳⠤⠽⣒⠶⠒⠋⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⡷⢋⢠⣶⠀⢰⣿⡿⠻⠉⠃⠀⠀⠀⠀⠀⠀⢠⢣⡶⠒⠒⠉⠉⠁⠈⠑⢄⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣄⣀⣤⣄⡘⢾⣿⡇⢸⡏⢰⣤⣴⣤⠀⠀⠀⠀⠀⠀⡏⠁⢹⣁⣔⢠⡒⠲⣶⠖⠊⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣻⣶⣿⣿⡿⠿⣶⠿⣄⢸⣧⡾⠛⠛⠃⠀⠀⠀⠀⠀⠐⡇⠀⠀⠀⠉⠉⠀⠀⠈⣆⠀⠀⠀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠸⠟⠻⠛⠹⠁⠀⠀⠀⠈⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⠀⠀⠀⠀⠀⠀⠀⣼⣏⡉⠙⠋⣛⣦",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣶⠂⢀⠀⠀⢠⡞⠉⠀⠉⠙⠋⠉⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠖⣫⣳⡦⢼⣿⡖⠛⠓⡦⣄⡀⠀⠀⠀⢀⣀⣀⡸⠴⠀⡆⡀⠀⢣⣀⣀⣤⣀⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣻⡉⠉⠀⢀⠈⢉⣠⡦⠾⠶⠿⠥⢄⡀⢰⢫⠄⣰⢼⠖⠒⠋⠁⠀⠀⠀⠀⢀⡞⠀⠀⠀",
			"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠤⠦⠖⠋⠛⠧⢅⣀⣄⡤⠽⠚⠀⠀⠙⠺⣁⣔⡀⣰⠀⠀⠀⣀⣠⠴⠋⠀⠀⠀⠀",
			"      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠛⠒⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀",
			[[ __    __ ________  ______  __     __ ______ __       __ ]],
			[[|  \  |  \        \/      \|  \   |  \      \  \     /  \]],
			[[| ▓▓\ | ▓▓ ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓]],
			[[| ▓▓▓\| ▓▓ ▓▓__   | ▓▓  | ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓]],
			[[| ▓▓▓▓\ ▓▓ ▓▓  \  | ▓▓  | ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓]],
			[[| ▓▓\▓▓ ▓▓ ▓▓▓▓▓  | ▓▓  | ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓]],
			[[| ▓▓ \▓▓▓▓ ▓▓_____| ▓▓__/ ▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓]],
			[[| ▓▓  \▓▓▓ ▓▓     \\▓▓    ▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓]],
			[[ \▓▓   \▓▓\▓▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓▓▓▓▓\▓▓      \▓▓]]
		}
		local screen_width = vim.api.nvim_win_get_width(0)
		local screen_height = vim.api.nvim_win_get_height(0)

		-- local start_line = math.floor((screen_height - #greeter_text) / 2)

		local biggest_line_len = 0
		for i = 1, #greeter_text do
			if vim.str_utfindex(greeter_text[i]) > biggest_line_len then
				biggest_line_len = vim.str_utfindex(greeter_text[i])
			end
		end

		local padding = math.floor((screen_width - biggest_line_len) / 2)

		local function center_text(str)
			return string.rep(" ", padding) .. str
		end

		local centered_greeter_text = vim.tbl_map(center_text, greeter_text)

		vim.api.nvim_buf_set_lines(current_buf, 3, 3, false, centered_greeter_text)
		-- vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, { tostring(biggest_line_len) })
		vim.api.nvim_set_option_value("modified", false, { buf = current_buf })
		vim.api.nvim_set_option_value("modifiable", false, { buf = current_buf })
	end,
})

-- Disabling netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Editor Display
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false -- Hide mode, already have it on status line
vim.o.signcolumn = "no"

vim.o.winborder = "rounded"

vim.o.wrap = false

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = "split" -- Preview substitutions live, as you type

vim.o.cursorline = true
vim.o.scrolloff = 30 -- Min. lines above and below cursor

vim.o.hlsearch = true

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true

-- Editing
vim.o.swapfile = false
vim.o.undofile = true

-- Movement
vim.o.ignorecase = true -- Case-insensitive searching unless \C or one or more capital letters in the search term
vim.o.smartcase = true

-- Internals
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Basic Typing
vim.o.whichwrap = "<>[]hl"

--[ Yanking and pasting
vim.o.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Packs
local gh_path = "https://github.com/"
vim.pack.add({
	{ src = gh_path .. "rebelot/kanagawa.nvim" },
	{ src = gh_path .. "neovim/nvim-lspconfig" },
	{ src = gh_path .. "echasnovski/mini.statusline" },
	-- { src = gh_path .. "folke/which-key.nvim" },
	{ src = gh_path .. "ggandor/leap.nvim" },
	{ src = gh_path .. "tpope/vim-sleuth" },   -- detects file's indentation patterns
	{ src = gh_path .. "numToStr/Comment.nvim" }, -- comment selection with "gc"
	{ src = gh_path .. "lewis6991/gitsigns.nvim" },
	{ src = gh_path .. "mbbill/undotree" },
	{ src = gh_path .. "nvim-tree/nvim-tree.lua" },
	{ src = gh_path .. "ibhagwan/fzf-lua" },
})

--[ LSP
vim.lsp.enable({ "lua_ls", "gopls" })

--[ mini.statusline
require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
require("mini.statusline").section_location = function()
	return "%2l:%-2v"
end

--[ leap
require("leap").create_default_mappings()
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

--[ git signs
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

--[ nvim-tree
require("nvim-tree").setup()

--[ fzf-lua
require("fzf-lua").setup()

-- Keymaps
vim.g.mapleader = " "

--[ Editor Keymaps
vim.keymap.set("n", "<leader>R", ":update<CR>:source<CR>", { desc = "Refresh" })
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>Q", ":quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear search highlight

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>ts", function() -- toggle signs before line number
	if vim.o.signcolumn == "no" then
		vim.o.signcolumn = "yes"
	else
		vim.o.signcolumn = "no"
	end
end, { desc = "Toggle signcolumn" })

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR><C-w>w")
vim.keymap.set("n", "<leader><Up>", ":NvimTreeOpen<CR>")
vim.keymap.set("n", "<leader>co", ":FzfLua colorschemes<CR>")
vim.keymap.set("n", "<leader>r", ":FzfLua registers<CR>")
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")

--[ FzfLua Git Keymaps
vim.keymap.set("n", "<leader>gs", ":FzfLua git_status<CR>")
vim.keymap.set("n", "<leader>gd", ":FzfLua git_diff<CR>")
vim.keymap.set("n", "<leader>gc", ":FzfLua git_commits<CR>")
vim.keymap.set("n", "<leader>gb", ":FzfLua git_branches<CR>")

--[ LSP Keymaps
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP: Format buffer" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, { desc = "LSP: Rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })

vim.keymap.set("n", "<leader>a", ":FzfLua lsp_references<CR>")
vim.keymap.set("n", "<leader>q", ":FzfLua lsp_document_diagnostics<CR>")
vim.keymap.set("n", "<leader>E", ":FzfLua lsp_workspace_diagnostics<CR>")

--[ Basic Typing Keymaps
vim.keymap.set("n", "<leader><CR>", "o<Esc>")
vim.keymap.set("n", "<leader><Backspace>", "O<Esc>")
vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true }) -- ctrl + backspace
vim.keymap.set("n", "x", '"_x')                            -- x not to save deleted char to a register

--[ Movement Keymaps
-- TODO: Make gt search for a term, go to first ocurrence and exit search
vim.keymap.set({ "n", "v" }, "<C-Up>", "{") -- ctrl + up or down == go up/down paragraph
vim.keymap.set({ "n", "v" }, "<C-Down>", "}")
vim.keymap.set("i", "<C-Up>", "<C-o>{")
vim.keymap.set("i", "<C-Down>", "<C-o>}")

vim.keymap.set({ "n", "v" }, "<C-Left>", function() -- ctrl + left or right == go back/forward words
	local original_line_num = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_feedkeys("b", "n", false)
	local new_line_num
	vim.defer_fn(function()
		new_line_num = vim.api.nvim_win_get_cursor(0)[1]
		if new_line_num ~= original_line_num then
			vim.api.nvim_feedkeys("$", "n", false)
		end
	end, 1)
end)

vim.keymap.set({ "n", "v" }, "<C-Right>", function()
	local original_line_num = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_feedkeys("w", "n", false)
	local new_line_num
	vim.defer_fn(function()
		new_line_num = vim.api.nvim_win_get_cursor(0)[1]
		if new_line_num ~= original_line_num then
			vim.api.nvim_feedkeys("0", "n", false)
		end
	end, 1)
end)

vim.keymap.set("i", "<C-Left>", function() -- ctrl + left or right == go back/forward words (include mode)
	local original_line_num = vim.api.nvim_win_get_cursor(0)[1]
	local keys = vim.api.nvim_replace_termcodes("<C-o>b", false, false, true)
	vim.api.nvim_feedkeys(keys, "n", true)
	local new_line_num
	vim.defer_fn(function()
		new_line_num = vim.api.nvim_win_get_cursor(0)[1]
		if new_line_num ~= original_line_num then
			keys = vim.api.nvim_replace_termcodes("<C-o>$", false, false, true)
			vim.api.nvim_feedkeys(keys, "n", true)
		end
	end, 1)
end)

vim.keymap.set("i", "<C-Right>", function() -- ctrl + left or right == go back/forward words (include mode)
	local original_line_num = vim.api.nvim_win_get_cursor(0)[1]
	local keys = vim.api.nvim_replace_termcodes("<C-o>w", false, false, true)
	vim.api.nvim_feedkeys(keys, "n", true)
	local new_line_num
	vim.defer_fn(function()
		new_line_num = vim.api.nvim_win_get_cursor(0)[1]
		if new_line_num ~= original_line_num then
			keys = vim.api.nvim_replace_termcodes("<C-o>0", false, false, true)
			vim.api.nvim_feedkeys(keys, "n", true)
		end
	end, 1)
end)

vim.keymap.set("n", "<Home>", "^")
vim.keymap.set("i", "<Home>", "<C-o>^")

vim.keymap.set("n", "<C-Up>", [[:<C-u>keepjumps normal! {<CR>]], { silent = true })
vim.keymap.set("n", "<C-Down>", [[:<C-u>keepjumps normal! }<CR>]], { silent = true })
vim.keymap.set("i", "<C-Up>", [[<C-o>:keepjumps normal! {<CR>]], { silent = true })
vim.keymap.set("i", "<C-Down>", [[<C-o>:keepjumps normal! }<CR>]], { silent = true })

vim.keymap.set("n", "<C-f>", ":FzfLua files<CR>")
vim.keymap.set("n", "<C-g>", ":FzfLua live_grep resume=true<CR>")
vim.keymap.set("n", "<C-d>", ":FzfLua lgrep_curbuf<CR>")

-- Colorscheme
require("kanagawa").setup({
	transparent = true,
})
vim.cmd("colorscheme kanagawa-dragon")
