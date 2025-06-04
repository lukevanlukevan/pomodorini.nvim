local M = {}

local defaults = {
  status_line = { "[r]estart [b]reak [c]lose" },
  use_highlight = true,
  highlight_color = "FF0000",
  timer_dur = 25,
  break_dur = 5,
  use_snacks = false,
  align = "tr",
  v_margin = 1,
  h_margin = 1,
  keymaps = {
    start = "<leader>tt",
    show = "<leader>ts",
    hide = "<leader>th",
    pause_toggle = "<leader>tp",
  },
}

local config = defaults

M.setup = function(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})

  local keymaps = {
    start = { cmd = ":PomodoriniStart " .. config.timer_dur .. "<cr>", desc = "Start Pomodorini" },
    show = { cmd = ":PomodoriniShow<cr>", desc = "Show Pomodorini" },
    hide = { cmd = ":PomodoriniHide<cr>", desc = "Hide Pomodorini" },
    pause_toggle = { cmd = ":PomodoriniPauseToggle<cr>", desc = "Toggle Pomodorini Pause" },
  }

  for name, def in pairs(keymaps) do
    local lhs = config.keymaps[name]
    if lhs then
      vim.keymap.set("n", lhs, def.cmd, { silent = true, desc = def.desc })
    end
  end

  -- snacks toggle --
  if config.use_snacks then
    require("snacks")
      .toggle({
        name = "Pause",
        get = function()
          return M.is_paused()
        end,
        set = function()
          M.pomodorini_pause_toggle()
        end,
      })
      :map("<leader>tp")
  end
end

WIDTH = 39
local ns_id = vim.api.nvim_create_namespace("pomodorini")

local state = {
  timer = nil,
  win_id = nil,
  bufnr = nil,
  lines = {},
  hidden = false,
  paused = false,
  status_line = "",
  current_tick = nil,
  total_ticks = nil,
  paused_at_tick = 0,
}

local function render_progress_bar(progress, length)
  local filled = math.floor(progress * length)
  local empty = length - filled
  return "[" .. string.rep("█", filled) .. string.rep("░", empty) .. "]"
end

local function set_lines(lines)
  vim.bo[state.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
  vim.bo[state.bufnr].modifiable = false
end

local function set_highlight()
  vim.cmd("highlight timerBar guifg=#" .. config.highlight_color)
  vim.api.nvim_buf_set_extmark(state.bufnr, ns_id, 1, 1, { end_row = 1, end_col = 60, hl_group = "timerBar" })
end

local function get_corner_options()
  local row = config.align:sub(1, 1) == "t" and config.v_margin or vim.o.lines - 4 - config.v_margin
  local col = config.align:sub(2) == "l" and config.h_margin or vim.o.columns - WIDTH - 2 - config.h_margin
  return row, col
end

local function create_window()
  local width = WIDTH
  local height = 2

  local row, col = get_corner_options()
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "🍅 Pomodorini",
  }
  local win_id = vim.api.nvim_open_win(state.bufnr, false, win_opts)
  state.win_id = win_id
  state.hidden = false
end

M.toggle = function()
  if state.hidden then
    M.pomodorini_show()
  else
    M.pomodorini_hide()
  end
end

M.pomodorini_create = function()
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
    vim.api.nvim_win_close(state.win_id, true)
    state.win_id = nil
  end
  state.bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[state.bufnr].modifiable = false
  vim.bo[state.bufnr].buflisted = false
  vim.bo[state.bufnr].filetype = "pomodorini"
  create_window()
end

local function start_timer_for(duration_minutes, on_done, start_tick)
  state.paused = false
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end

  if state.hidden then
    M.pomodorini_show()
  end
  state.current_tick = start_tick or 0
  state.total_ticks = duration_minutes * 60
  state.timer = vim.loop.new_timer()
  state.timer:start(
    0,
    1000,
    vim.schedule_wrap(function()
      if state.current_tick >= state.total_ticks then
        state.timer:stop()
        state.timer:close()
        state.timer = nil

        local done_lines = {
          state.status_line,
          " Timer complete.",
        }
        state.lines = done_lines
        set_lines(done_lines)

        if on_done then
          on_done()
        end
        return
      end

      local progress = state.current_tick / state.total_ticks
      local bar = render_progress_bar(progress, 20)
      local secondsleft = state.total_ticks - state.current_tick
      local minutesleft = math.floor(secondsleft / 60)
      local modsecs = math.fmod(secondsleft, 60)
      state.status_line = config.status_line[math.random(#config.status_line)]
      local lines = {
        state.status_line,
        bar .. string.format(" %dm %ds left", minutesleft, modsecs),
      }
      state.lines = lines
      set_lines(lines)
      if config.use_highlight then
        set_highlight()
      end
      if not state.paused then
        state.current_tick = state.current_tick + 1
      end
    end)
  )
end

M.start_timer = function(duration, on_done)
  if not state.bufnr or not vim.api.nvim_buf_is_valid(state.bufnr) then
    M.pomodorini_create()
  end
  vim.api.nvim_buf_set_option(state.bufnr, "bufhidden", "hide")

  vim.keymap.set("n", "c", function()
    if vim.api.nvim_win_is_valid(state.win_id) then
      vim.api.nvim_win_close(state.win_id, true)
    end
    if state.timer then
      state.timer:stop()
      state.timer:close()
      state.timer = nil
    end
    state.win_id = nil
    state.hidden = true
  end, { buffer = state.bufnr, nowait = true, silent = true })

  vim.keymap.set("n", "h", M.toggle, { buffer = state.bufnr, nowait = true, silent = true })

  vim.keymap.set("n", "r", function()
    start_timer_for(config.timer_dur, function()
      start_timer_for(1)
    end)
  end, { buffer = state.bufnr, nowait = true, silent = true, noremap = true })

  vim.keymap.set("n", "b", function()
    start_timer_for(config.break_dur, function()
      start_timer_for(1)
    end)
  end, { buffer = state.bufnr, nowait = true, silent = true, noremap = true })

  start_timer_for(duration, on_done)
end

M.pomodorini_pause_toggle = function()
  if state.paused then
    state.paused = false
    start_timer_for(state.total_ticks / 60, nil, state.paused_at_tick)
  else
    if state.timer then
      state.timer:stop()
      state.timer:close()
      state.timer = nil
    end
    state.paused_at_tick = state.current_tick
    state.paused = true
  end
end

M.pomodorini_hide = function()
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
    vim.api.nvim_win_hide(state.win_id)
    state.win_id = nil
    state.hidden = true
  end
end

M.pomodorini_show = function()
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
    local current_buf = vim.api.nvim_win_get_buf(state.win_id)
    if current_buf ~= state.bufnr then
      state.win_id = nil
      state.hidden = true
    end
  end

  if state.hidden and state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
    create_window()
    vim.keymap.set("n", "h", M.toggle, { buffer = state.bufnr, nowait = true, silent = true })
    if state.lines then
      set_lines(state.lines)
    end
  end
end

M.get_config = function()
  return config
end

M.is_paused = function()
  return state.paused
end

return M
