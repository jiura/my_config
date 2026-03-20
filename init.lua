vim.g.mapleader = " "

-- Greeter

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		if vim.fn.expand('%') ~= '' then
			return
		end

		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.cursorline = false

		vim.api.nvim_create_autocmd("BufEnter", {
			once = true,
			callback = function()
				vim.cmd("highlight LineNr ctermbg=NONE guibg=NONE")
				vim.cmd("highlight CursorLineNr ctermbg=NONE guibg=NONE")
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
vim.o.termguicolors = true
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false -- Hide mode, already have it on status line
vim.o.signcolumn = "no"

vim.o.winborder = "rounded"

vim.o.wrap = true

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
vim.o.updatetime = 4000
vim.o.timeoutlen = 400
vim.o.timeout = true

-- vim.o.ttimeout = false
-- vim.o.ttimeoutlen = 0

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
-- Doesn't yank when pasting in visual mode
vim.keymap.set('x', 'p', [["_dP]], { noremap = true, silent = true })

-- Plugins

--[ Mine
require('jiumplist')
require('jiuscratch')

--[ Others
local gh_path = "https://github.com/"
vim.pack.add({
	-- { src = gh_path .. "nvim-tree/nvim-web-devicons" },
	{ src = gh_path .. "neovim/nvim-lspconfig" },
	{ src = gh_path .. "echasnovski/mini.statusline" },
	{ src = gh_path .. "folke/which-key.nvim" },
	{ src = gh_path .. "ggandor/leap.nvim" },
	{ src = gh_path .. "tpope/vim-sleuth" },   -- detects file's indentation patterns
	{ src = gh_path .. "numToStr/Comment.nvim" }, -- comment selection with "gc"
	{ src = gh_path .. "lewis6991/gitsigns.nvim" },
	{ src = gh_path .. "mbbill/undotree" },
	{ src = gh_path .. "nvim-tree/nvim-tree.lua" },
	{ src = gh_path .. "ibhagwan/fzf-lua" },
	{ src = gh_path .. "seblyng/roslyn.nvim" },
	{ src = gh_path .. "sindrets/diffview.nvim" },

	-- debugger
	{ src = gh_path .. "mfussenegger/nvim-dap" },
	{ src = gh_path .. "nvim-neotest/nvim-nio" },
	{ src = gh_path .. "rcarriga/nvim-dap-ui" },
	{ src = gh_path .. "nvim-treesitter/nvim-treesitter" },
	{ src = gh_path .. "theHamsta/nvim-dap-virtual-text" },

	-- plenary and those who depend on it
	{ src = gh_path .. "nvim-lua/plenary.nvim" },
	{ src = gh_path .. "NeogitOrg/neogit" },
	{ src = gh_path .. "ej-shafran/compile-mode.nvim" },

	-- colorschemes
	{ src = gh_path .. "rebelot/kanagawa.nvim" },
	{ src = gh_path .. "RRethy/base16-nvim" },
	-- { src = gh_path .. "aikhe/fleur.nvim" }, -- TODO: This could've been good... Might edit it myself later
})

-- vim.opt.rtp:prepend("/home/joao/work/proj/plugins/emoji-nvim")
-- vim.api.nvim_create_user_command("Emoji", function()
--   require("emoji").pick()
-- end, {})

--[ Compile Mode

local function load_env_file(path)
	local env = {}

	if vim.fn.filereadable(path) == 0 then
		return env
	end

	for line in io.lines(path) do
		if line:match("%S") and not line:match("^%s*#") then
			local key, value = line:match("^%s*([A-Z_][A-Z0-9_]*)%s*=%s*(.+)$")

			if key and value then
				value = value:match("^%s*(.-)%s*$") -- trim

				local first = value:sub(1, 1)

				if first == '"' or first == "'" then
					local closing = nil

					for i = 2, #value do
						if value:sub(i, i) == first and value:sub(i - 1, i - 1) ~= "\\" then
							closing = i
							break
						end
					end

					if closing then
						value = value:sub(2, closing - 1) -- inside quotes
					else
						value = value:sub(1):match("^(%S+)") -- no closing quote, up to first whitespace
					end
				else
					value = value:match("^(%S+)") -- until whitespace
				end

				env[key] = value
			end
		end
	end

	return env
end

local function load_flags_file(path)
	local flags = ""

	if vim.fn.filereadable(path) == 0 then
		return flags
	end

	for line in io.lines(path) do
		if line:match("%S") and not line:match("^%s*#") then
			line = line:match("^%s*(.-)%s*$") -- trim
			flags = flags .. " " .. line
		end
	end

	return flags
end

local function load_compilecmd_file(path)
	local cmd = ""

	if vim.fn.filereadable(path) == 0 then
		return cmd
	end

	for line in io.lines(path) do
		line = line:match("^%s*(.-)%s*$") -- trim
		cmd = cmd .. " " .. line
	end

	return cmd:match("^%s*(.-)%s*$") -- trim
end

local cwd = vim.fn.getcwd()
local compile_mode_flags = ""
local compile_cmd = ""

-- Nice way to print out stuff for debug
-- print(vim.inspect(compile_mode_env))

if vim.fn.filereadable(cwd .. "/.flags") == 1 then
	compile_mode_flags = load_flags_file(cwd .. "/.flags")
end

if vim.fn.filereadable(cwd .. "/.compilecmd") == 1 then
	compile_cmd = load_compilecmd_file(cwd .. "/.compilecmd")
end

local default_cmd

if compile_cmd == "" then
	default_cmd = {
		-- c = "gcc -o %:r %" .. compile_mode_flags .. " && ./%:r",
		c = "gcc -o qdebug main.c" .. compile_mode_flags .. " && ./qdebug",
		go = "go run ." .. compile_mode_flags,
		csharp = "dotnet run",
	}
else
	default_cmd = compile_cmd
end

---@module "compile-mode"
---@type CompileModeOpts
local compile_mode_opts = {
	default_command = default_cmd,
	bang_expansion = true,
	focus_compilation_buffer = false,
	ask_to_interrupt = false,
}

if vim.fn.filereadable(cwd .. "/.env") == 1 then
	compile_mode_opts.environment = load_env_file(cwd .. "/.env")
end

vim.g.compile_mode = compile_mode_opts

-- Add a custom compile command that opens in a new tab
vim.api.nvim_create_user_command('CompileNewTab', function()
	vim.cmd('tabnew ' .. vim.fn.expand('%'))
	vim.cmd('Compile')

	vim.defer_fn(function()
		vim.cmd('wincmd k')
		vim.cmd('quit')
		-- vim.cmd('tabprevious')
	end, 1)
end, { desc = 'Compile and open in a new tab' })

--[ Debugger
local dap = require("dap")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Dap Virtual Text
dap_virtual_text.setup()

-- Adapters
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

-- Configurations
dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		args = {},
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		pid = function()
			local name = vim.fn.input('Executable name (filter): ')
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = '${workspaceFolder}'
	},
	{
		name = 'Attach to gdbserver :1234',
		type = 'gdb',
		request = 'attach',
		target = 'localhost:1234',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}'
	}
}

-- Dap UI
dap_ui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🔴" })

dap.listeners.before.attach.dapui_config = function()
	dap_ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dap_ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dap_ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dap_ui.close()
end

--[ LSP
vim.lsp.config('roslyn', {
	cmd = {
		'dotnet',
		'/home/joao/apps/roslyn-ls/nupkg/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll',
		"--logLevel",        -- this property is required by the server
		"Information",
		"--extensionLogDirectory", -- this property is required by the server
		vim.fs.joinpath(vim.loop.os_tmpdir(), "roslyn_ls/logs"),
		"--stdio",
	}
})

-- :help lspconfig-all
vim.lsp.enable({
	"lua_ls",
	"gopls",
	"ts_ls",
	--"cssls",
	"clangd",
	"basedpyright"
})

require("roslyn").setup()

--[ mini.statusline
local status_line = require("mini.statusline")
status_line.setup({
	use_icons = vim.g.have_nerd_font,
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			-- local git           = MiniStatusline.section_git({ trunc_width = 40 })
			-- local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
			-- local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			-- local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
			local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
			-- local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			-- local location      = MiniStatusline.section_location({ trunc_width = 75 })
			local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl,                  strings = { mode } },
				-- { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
				'%<', -- Mark general truncate point
				{ hl = 'MiniStatuslineFilename', strings = { filename } },
				'%=', -- End left alignment
				-- { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
				-- { hl = mode_hl,                  strings = { search, location } },
				{ hl = mode_hl, strings = { search } },
			})
		end,
		inactive = nil,
	},
})
status_line.section_location = function()
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

--[ which-key
local which_key = require("which-key")
which_key.setup({
	icons = {
		mappings = false,
	}
})

-- Keymaps
vim.api.nvim_set_keymap('n', '<C-x>', '', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-x><Esc>', '', { noremap = true, silent = true })

which_key.add({
	{ "<leader>t",           group = "toggle" },
	{ "<leader>d",           group = "debug" },
	{ "<leader>g",           group = "git" },

	{ "<leader><CR>",        hidden = true },
	{ "<leader><Backspace>", hidden = true },
	{ "<leader><Up>",        hidden = true },
	{ "<leader>e",           hidden = true },
	{ "<leader>E",           hidden = true },
	{ "<leader>q",           hidden = true },
	{ "<leader>w",           hidden = true },
	{ "<leader>Q",           hidden = true },
	{ "<leader>n",           hidden = true },
	{ "<leader>f",           hidden = true },
	{ "<C-x>",               hidden = true },
	{ "v",                   hidden = true },
})

--[ Editor Keymaps
-- vim.keymap.set("n", "<leader>R", ":update<CR>:source<CR>", { desc = "Refresh" })
vim.keymap.set("n", "<C-x><C-r>", ":restart<CR>", { noremap = true, desc = "Restart" })
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Write" })
vim.keymap.set("n", "<C-s>", ":write<CR>", { desc = "Write" })
-- vim.keymap.set("n", "<leader>Q", ":quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", ":quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear search highlight

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show error" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>ts", function() -- toggle signs before line number
	if vim.o.signcolumn == "no" then
		vim.o.signcolumn = "yes"
	else
		vim.o.signcolumn = "no"
	end
end, { desc = "Toggle signcolumn" })

vim.keymap.set("n", "<leader>tn", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative numbers" })

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR><C-w>w", { desc = "Undo tree" })
vim.keymap.set("n", "<leader><Up>", ":NvimTreeToggle<CR>", { desc = "File tree" })
vim.keymap.set("n", "<leader>co", ":FzfLua colorschemes<CR>", { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>r", ":FzfLua registers<CR>", { desc = "Registers" })

vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", { desc = "Buffers" })

vim.keymap.set("n", "T", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>T", ":FzfLua tabs<CR>", { desc = "Tabs" })

vim.keymap.set("n", "<leader>'", ":FzfLua marks<CR>", { desc = "Marks" })

---[ Move selected lines
vim.api.nvim_set_keymap('v', '<C-S-Up>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-S-Down>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

--[ Git Keymaps
vim.keymap.set("n", "<leader>gs", ":FzfLua git_status<CR>", { desc = "Status" })
vim.keymap.set("n", "<leader>gd", ":FzfLua git_diff<CR>", { desc = "Diff" })
vim.keymap.set("n", "<leader>gc", ":FzfLua git_commits<CR>", { desc = "Commits" })
vim.keymap.set("n", "<leader>gb", ":FzfLua git_branches<CR>", { desc = "Branches" })

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })

--[ Debug Keymaps
vim.keymap.set("n", "<leader>dt", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
-- TODO: Finish setting these up

vim.keymap.set("n", "<leader>dc", ":CompileNewTab<CR>", { desc = "Compile" })
vim.keymap.set("n", "<C-c>", ":CompileNewTab<CR>", { desc = "Compile" })
vim.keymap.set("n", "<leader>dr", ":Recompile<CR>", { desc = "Recompile" })
-- Create r keymap local to *compilation* window
vim.api.nvim_create_autocmd('BufWinEnter', {
	pattern = '*compilation*',
	callback = function()
		vim.keymap.set('n', 'r', ':Recompile<CR>', { buffer = true })
		vim.keymap.set('n', 's', ':CompileInterrupt<CR>', { buffer = true })
		vim.keymap.set('n', 'q', ':CompileCloseBuffer<CR>', { buffer = true })
	end
})

--[ LSP Keymaps
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

vim.keymap.set("n", "<leader>a", ":FzfLua lsp_references<CR>", { desc = "References" })
vim.keymap.set("n", "<leader>q", ":FzfLua lsp_document_diagnostics<CR>", { desc = "Current buffer errors" })
vim.keymap.set("n", "<leader>E", ":FzfLua lsp_workspace_diagnostics<CR>", { desc = "Workspace errors" })

--[ Basic Typing Keymaps
vim.keymap.set("n", "<leader><CR>", "o<Esc>", { desc = "New line below" })
vim.keymap.set("n", "<leader><Backspace>", "O<Esc>", { desc = "New line above" })
vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true }) -- ctrl + backspace
vim.keymap.set("n", "x", '"_x')                            -- x not to save deleted char to a register

--[ Movement Keymaps
vim.keymap.set({ "n", "v" }, "<C-Up>", "{") -- ctrl + up or down == go up/down paragraph
vim.keymap.set({ "n", "v" }, "<C-Down>", "}")
vim.keymap.set("i", "<C-Up>", "<C-o>{")
vim.keymap.set("i", "<C-Down>", "<C-o>}")
vim.keymap.set("n", "gt", "/", { noremap = true, desc = "Go to (search)" })

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
vim.keymap.set("n", "<C-g>", ":FzfLua live_grep_native resume=true<CR>")
vim.keymap.set("n", "<C-S-g>", ":FzfLua lgrep_curbuf resume=true<CR>")

--[ Insert mode keymaps
vim.keymap.set("i", "<C-c>", "<C-o>")
vim.keymap.set("i", "<C-z>", "<C-o>u") -- undo
vim.keymap.set("i", "<C-Del>", "<C-o>dw") -- delete next work

-- Colorscheme
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	callback = function()
-- 		-- Your code here runs whenever the colorscheme changes
-- 		vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight NonText ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight NormalFloat ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight FloatBorder ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight NormalNC ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight SignColumn ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight EndOfBuffer ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight LineNr ctermbg=NONE guibg=NONE")
-- 		vim.cmd("highlight CursorLineNr ctermbg=NONE guibg=NONE")
-- 	end,
-- })

require("kanagawa").setup({
	transparent = true,
})
vim.cmd("colorscheme base16-grayscale-dark")
-- vim.cmd("colorscheme base16-vulcan")
