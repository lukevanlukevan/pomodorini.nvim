# 🍅 `pomodorini.nvim`

A small Neovim pomodoro timer.

## Requirements

- **Neovim** >= 0.9.4
- For better toggle support:
  - [snacks.nvim](https://github.com/folke/snacks.nvim)

## Installation

Install the plugin with your package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  "lukevanlukevan/pomodorini.nvim",
}
```

## Configuration

There are a few `opts` you can configure. The defaults are provided below:

```lua
return {
  "lukevanlukevan/pomodorini.nvim",
  opts = {
    status_line = { "[r]estart [b]reak [c]lose" }, -- line that shows above progress bar
    use_highlight = true, -- use highlighting 
    highlight_color = "FF0000", -- highlight color for progress bar
    timer_dur = 25, -- default timer duration
    break_dur = 5, -- default break duration
    use_snacks = false, -- if you have which-key, add a group for Pomodorini
    align = "br", -- which corner to align the timer to (tl,tr,bl,br)
    v_margin = 1, -- vertical margin for floating window
    h_margin = 1, -- horizontal margin for floating window
    keymaps = {
      start = "<leader>tt",
      show = "<leader>ts",
      hide = "<leader>th",
      pause_toggle = "<leader>tp",
    },
  },
}
```

## 🚀 Usage

There are some default commands provided, but you can also use the lua commands:

| Command | Description | `lua` |
| --------------- | --------------- | --------------- |
| PomodoriniStart <mins> | Start a timer for <mins> | require("pomodorini").start_timer(mins) |
| PomodoriniShow | Show the pomodorini window | require("pomodorini").pomodorini_show() |
| PomodoriniHide | Hide the pomodorini window | require("pomodorini").pomodorini_hide() |
| PomodoriniPauseToggle | Pause the pomodorini timer | require("pomodorini").pomodorini_pause_toggle() |

