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
  -- optional, only if you want to use which key groups and have the toggle icon update
  dependencies = {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>t", icon = "🍅", group = "Pomodorini" },
      },
    },
  },
  -- end optional
  opts = {
    status_line = { "[r]estart [b]reak [q]uit", "Time to focus" },
    use_highlight = true,
    highlight_color = "FF0000",
    timer_dur = 25,
    break_dur = 5,
    use_snacks = false, -- set this to true if you are using which key
    align = "tr",
    v_margin = 1,
    h_margin = 1,
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

