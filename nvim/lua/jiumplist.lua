-- Safeguarding against table.unpack not existing
if not table.unpack then
    table.unpack = unpack
end

-- Helper
local function press_keys(keys, mode)
  -- Replace terminal codes (e.g., "<Esc>") with the actual codes
  local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  -- Feed the keys to Neovim
  vim.api.nvim_feedkeys(termcodes, mode, false)
end

local function jump_to_prev_buffer()
  local jumplist, idx = table.unpack(vim.fn.getjumplist())
  local current_buf = vim.api.nvim_get_current_buf()

  local n = 0

  -- Loop backwards through the jumplist
  for i = idx - 1, 1, -1 do
    local entry = jumplist[i]

    if entry.bufnr ~= current_buf then
      n = idx - i + 1
      break
    end
  end

  if n > 0 then
    -- Jumps back n times
    press_keys(n .. "<C-o>", 'n')
	print("Jump backwards " .. n .. "times")
  else
    print("No previous buffer in jumplist.")
  end
end

local function jump_to_next_buffer()
  local jumplist, idx = table.unpack(vim.fn.getjumplist())
  local current_buf = vim.api.nvim_get_current_buf()

  local target_buf = nil
  local last_index = nil

  -- Loop forward through the jumplist
  for i = idx + 1, #jumplist do
    local entry = jumplist[i]

    if not target_buf then
      -- Find the first jump to next buffer
      if entry.bufnr ~= current_buf then
        target_buf = entry.bufnr
        last_index = i
      end
    else
      -- Updating last_index while still on target buffer
      if entry.bufnr == target_buf then
        last_index = i
      else
        -- Reached a new buffer; stop
        break
      end
    end
  end

  if last_index then
    local n = last_index - idx - 1

	-- Jumps forward n times
    press_keys(n .. "<C-i>", 'n')
	print("Jump forward " .. n .. "times")
  else
    print("No next buffer found in jumplist.")
  end
end

function SwitchBuffer(direction)
	if direction == 1 then
		-- Going forward
		jump_to_next_buffer()
	else
		-- Going backward
		jump_to_prev_buffer()
	end
end

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
