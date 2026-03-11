-- Function to switch buffers based on history
local buf_history = {}
local buf_history_index = 0
local last_move_was_switch = false

function SwitchBuffer(direction)
	local num_bufs = #buf_history

	if direction == -1 and buf_history_index == 1 then return end
	if direction == 1 and buf_history_index == num_bufs then return end

	if direction == 1 then
		-- Going forward
		buf_history_index = buf_history_index + 1
	else
		-- Going backward
		buf_history_index = buf_history_index - 1
	end

	-- Get the buffer to switch to
	local buf_to_switch = buf_history[buf_history_index]
	vim.api.nvim_command('buffer ' .. buf_to_switch)
	last_move_was_switch = true
end

-- Add current buffer to history when switching buffers
-- Add buffer to history when entering it
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if last_move_was_switch then
			last_move_was_switch = false
			return
		end

		local current_buf = vim.fn.bufnr()

		if not vim.tbl_contains(buf_history, current_buf) then
			if #buf_history >= 8 then
				table.remove(buf_history, 1) -- Remove the first (oldest) item
			end
		else
			table.remove(buf_history, buf_history_index)
		end

		table.insert(buf_history, current_buf)
		buf_history_index = #buf_history
	end
})

-- Remove buffer from history when it is deleted
vim.api.nvim_create_autocmd("BufDelete", {
	pattern = "*",
	callback = function()
		local cur_buf = vim.fn.bufnr()

		for i, buf in ipairs(buf_history) do
			if buf == cur_buf then
				table.remove(buf_history, i)

				if i <= buf_history_index then
					buf_history_index = buf_history_index - 1
				end

				break
			end
		end
	end
})

vim.keymap.set("n", "<C-x><Left>", ":lua SwitchBuffer(-1)<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<C-x><Right>", ":lua SwitchBuffer(1)<CR>", { desc = "Next buffer", silent = true })

local function jump_back_in_buf()
	local win_jumps = vim.fn.getjumplist(0)
	local jumps, idx = win_jumps[1], win_jumps[2]
	local cur_buf = vim.fn.bufnr()

	for i = idx, 1, -1 do
		if jumps[i].bufnr == cur_buf then
			local keys = vim.api.nvim_replace_termcodes(idx - i .. "<C-o>", true, false, true)
			vim.api.nvim_feedkeys(keys, 'n', false)
			return
		end
	end

	print("No previous jump in current buffer")
end

local function jump_forward_in_buf()
	local win_jumps = vim.fn.getjumplist(0)
	local jumps, idx = win_jumps[1], win_jumps[2]
	local cur_buf = vim.fn.bufnr()

	-- Search forward
	for i = idx + 1, #jumps-1 do
		if jumps[i].bufnr == cur_buf then
			local keys = vim.api.nvim_replace_termcodes(i - idx .. "<C-i>", true, false, true)
			vim.api.nvim_feedkeys(keys, 'n', false)
			return
		end
	end

	print("No next jump in current buffer")
end

vim.keymap.set("n", "<C-x><Up>", jump_back_in_buf, { noremap = true, silent = true })
vim.keymap.set("n", "<C-x><Down>", jump_forward_in_buf, { noremap = true, silent = true })
