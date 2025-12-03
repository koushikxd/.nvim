local M = {}

M.remove_comments = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local success, language_tree = pcall(vim.treesitter.get_parser, bufnr)
  if not success or not language_tree then
    vim.notify('Treesitter parser not available for this file type', vim.log.levels.WARN)
    return
  end

  language_tree:parse()
  local lang = language_tree:lang()

  local changes = {}

  language_tree:for_each_tree(function(tree, lang_tree)
    local root = tree:root()
    local current_lang = lang_tree:lang()

    local query_str = '(comment) @comment'
    local ok, query = pcall(vim.treesitter.query.parse, current_lang, query_str)

    if ok and query then
      for id, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
        if query.captures[id] == 'comment' then
          local start_row, start_col, end_row, end_col = node:range()

          local is_whole_line = false
          local line_text = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
          if line_text then
            local before = line_text:sub(1, start_col):match '^%s*$'
            local after = line_text:sub(end_col + 1):match '^%s*$'
            is_whole_line = (before ~= nil and (after ~= nil or end_row > start_row))
          end

          table.insert(changes, {
            start_row = start_row,
            start_col = start_col,
            end_row = end_row,
            end_col = end_col,
            is_whole_line = is_whole_line,
          })
        end
      end
    end
  end)

  if #changes == 0 then
    vim.notify('No comments found', vim.log.levels.INFO)
    return
  end

  table.sort(changes, function(a, b)
    if a.end_row ~= b.end_row then
      return a.end_row > b.end_row
    else
      return a.end_col > b.end_col
    end
  end)

  for _, change in ipairs(changes) do
    if change.is_whole_line and change.start_row == change.end_row then
      vim.api.nvim_buf_set_lines(bufnr, change.start_row, change.start_row + 1, false, {})
    elseif change.is_whole_line then
      vim.api.nvim_buf_set_lines(bufnr, change.start_row, change.end_row + 1, false, {})
    else
      local start_line = vim.api.nvim_buf_get_lines(bufnr, change.start_row, change.start_row + 1, false)[1]
      local end_line = vim.api.nvim_buf_get_lines(bufnr, change.end_row, change.end_row + 1, false)[1]

      if change.start_row == change.end_row then
        local new_line = start_line:sub(1, change.start_col) .. start_line:sub(change.end_col + 1)
        vim.api.nvim_buf_set_lines(bufnr, change.start_row, change.start_row + 1, false, { new_line })
      else
        local new_start = start_line:sub(1, change.start_col)
        local new_end = end_line:sub(change.end_col + 1)
        vim.api.nvim_buf_set_lines(bufnr, change.start_row, change.end_row + 1, false, { new_start .. new_end })
      end
    end
  end

  vim.cmd 'update'
  vim.notify('Removed ' .. #changes .. ' comment(s)', vim.log.levels.INFO)
end

M.code_actions = function()
  local function apply_specific_code_action(res)
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title == res.title
      end,
      apply = true,
    }
  end

  local actions = {}

  actions['Goto Definition'] = { priority = 100, call = vim.lsp.buf.definition }
  actions['Goto Implementation'] = { priority = 200, call = vim.lsp.buf.implementation }
  actions['Show References'] = { priority = 300, call = vim.lsp.buf.references }
  actions['Rename'] = { priority = 400, call = vim.lsp.buf.rename }

  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_range_params()

  params.context = {
    triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }

  vim.lsp.buf_request(bufnr, 'textDocument/codeAction', params, function(_, results, _, _)
    if not results or #results == 0 then
      return
    end
    for i, res in ipairs(results) do
      local prio = 10
      if res.isPreferred then
        if res.kind == 'quickfix' then
          prio = 0
        else
          prio = 1
        end
      end
      actions[res.title] = {
        priority = prio,
        call = function()
          apply_specific_code_action(res)
        end,
      }
    end
    local items = {}
    for t, action in pairs(actions) do
      table.insert(items, { title = t, priority = action.priority })
    end
    table.sort(items, function(a, b)
      return a.priority < b.priority
    end)
    local titles = {}
    for _, item in ipairs(items) do
      table.insert(titles, item.title)
    end
    vim.ui.select(titles, {}, function(choice)
      if choice == nil then
        return
      end
      actions[choice].call()
    end)
  end)
end

M.get_buffer_absolute = function()
  return vim.fn.expand '%:p'
end

M.get_visual_bounds = function()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then
    error('get_visual_bounds must be called in visual or visual-line mode (current mode: ' .. vim.inspect(mode) .. ')')
  end
  local is_visual_line_mode = mode == 'V'
  local start_pos = vim.fn.getpos 'v'
  local end_pos = vim.fn.getpos '.'

  return {
    start_line = math.min(start_pos[2], end_pos[2]),
    end_line = math.max(start_pos[2], end_pos[2]),
    start_col = is_visual_line_mode and 0 or math.min(start_pos[3], end_pos[3]) - 1,
    end_col = is_visual_line_mode and -1 or math.max(start_pos[3], end_pos[3]),
    mode = mode,
    start_pos = start_pos,
    end_pos = end_pos,
  }
end

M.format_line_range = function(start_line, end_line)
  return start_line == end_line and tostring(start_line) or start_line .. '-' .. end_line
end

M.simulate_yank_highlight = function()
  local bounds = M.get_visual_bounds()

  local ns = vim.api.nvim_create_namespace 'simulate_yank_highlight'
  vim.highlight.range(0, ns, 'IncSearch', { bounds.start_line - 1, bounds.start_col }, { bounds.end_line - 1, bounds.end_col }, { priority = 200 })
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end, 150)
end

M.exit_visual_mode = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

M.yank_path = function(path, label)
  vim.fn.setreg('+', path)
  print('Yanked ' .. label .. ' path: ' .. path)
end

M.yank_visual_with_path = function(path, label)
  local bounds = M.get_visual_bounds()

  local selected_lines = vim.fn.getregion(bounds.start_pos, bounds.end_pos, { type = bounds.mode })
  local selected_text = table.concat(selected_lines, '\n')

  local line_range = M.format_line_range(bounds.start_line, bounds.end_line)
  local path_with_lines = path .. ':' .. line_range

  local result = path_with_lines .. '\n\n' .. selected_text
  vim.fn.setreg('+', result)

  M.simulate_yank_highlight()

  M.exit_visual_mode()

  print('Yanked ' .. label .. ' with lines ' .. line_range)
end

return M
