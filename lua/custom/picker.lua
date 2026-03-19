local M = {}

local opened_from_oil = {}

local function picker_cwd()
  if vim.bo.filetype == 'oil' then
    local ok, oil = pcall(require, 'oil')
    if ok then
      local dir = oil.get_current_dir()
      if type(dir) == 'string' and dir ~= '' then
        return dir, true
      end
    end
  end

  return vim.uv.cwd() or vim.fn.getcwd(), false
end

function M.files()
  local cwd, from_oil = picker_cwd()
  local opts = { cwd = cwd }

  -- The first picker open from an Oil directory buffer is the only failing path.
  -- Skip the preview pane once for that repo so git/diff hooks don't race the
  -- initial directory buffer startup.
  if from_oil and not opened_from_oil[cwd] then
    opened_from_oil[cwd] = true
    opts.layout = { preset = 'ivy', preview = false }
  end

  vim.schedule(function()
    require('snacks').picker.files(opts)
  end)
end

return M
