-- Create scratch buffer
vim.api.nvim_create_user_command('Scratch', function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].swapfile = false
end, { desc = 'Create a scratch buffer' })

vim.api.nvim_command("cnoreabbrev scratch Scratch")

-- Namespace for run results

local ns_id = vim.api.nvim_create_namespace("RunLuaInline")

-- TODO: Worth it? This would run for every buffer
-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
--     callback = function(args)
--         local line = vim.fn.line('.') - 1
--         vim.api.nvim_buf_clear_namespace(0, ns_id, line, line + 1)
--     end,
-- })

-- Run Lua line

local function run_lua_code(code, last_line)
    local func, err = load(code)
    if not func then
        print("Error:", err)
        return
    end

    local ok, result = pcall(func)
    if not ok then
        print("Runtime error:", result)
    else
        vim.api.nvim_buf_clear_namespace(0, ns_id, last_line - 1, last_line)

        if result ~= nil then
            -- Add virtual text at the end of the current line
            vim.api.nvim_buf_set_extmark(0, ns_id, last_line - 1, 0, {
                virt_text = { { " ⇒ " .. vim.inspect(result), "Comment" } }, -- dim color
                virt_text_pos = 'eol',
            })

            print(vim.inspect(result))
        end
    end
end

vim.keymap.set('n', '<leader>dl', function()
    local code
    code = vim.api.nvim_get_current_line()
    run_lua_code(code, vim.fn.line('.'))
end, { noremap = true, silent = true, desc = 'Run Lua' })

-- Run Lua selection

vim.api.nvim_create_user_command('RunLuaSelection', function()
    vim.cmd([[ execute "normal! \<ESC>" ]])

    local code

    local start_pos             = vim.fn.getpos("'<")
    local end_pos               = vim.fn.getpos("'>")
    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col     = end_pos[2], end_pos[3]

    local lines                 = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    if #lines == 1 then
        code = lines[1]:sub(start_col, end_col)
    else
        lines[1] = lines[1]:sub(start_col)
        lines[#lines] = lines[#lines]:sub(1, end_col)
        code = table.concat(lines, "\n")
    end

    run_lua_code(code, end_line)
end, { desc = 'Run selection as Lua', range = true })

vim.keymap.set('v', '<leader>dl', ':RunLuaSelection<CR>', { noremap = true, silent = true, desc = 'Run Lua' })

-- Run Lua buffer

vim.api.nvim_create_user_command('RunLuaBuffer', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local code = table.concat(lines, "\n")

    run_lua_code(code, vim.api.nvim_buf_line_count(0))
end, { desc = 'Run entire buffer as Lua' })

vim.api.nvim_command("cnoreabbrev rua RunLuaBuffer")
