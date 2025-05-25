# 🍅 `snacks.nvim`

A collection of small QoL plugins for Neovim.


## Requirements

- **Neovim** >= 0.9.4
- for better toggle support:
  - [snacks.nvim](https://github.com/folke/snacks.nvim)

## Installation

Install the plugin with your package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
	"lukevanlukevan/pomodorini.nvim",
}
```

For an in-depth setup of `snacks.nvim` with `lazy.nvim`, check the [example](https://github.com/folke/snacks.nvim?tab=readme-ov-file#-usage) below.

## Configuration

There are a few `opts` you can configure. The defaults are provided below:

```lua
return {
	"lukevanlukevan/pomodorini.nvim",
	opts = {
		status_line = { "[r]estart [b]reak [c]lose" },
		use_highlight = true,
		highlight_color = "00FF00",
		timer_dur = 25,
		break_dur = 5,
		use_snacks = false,
		keymaps = {
			start = "<leader>tt",
			show = "<leader>ts",
			hide = "<leader>th",
			pause_toggle = "<leader>tp",
		},
	},
}```

## 🚀 Usage

There are some default commands provided, but you can also use the lua commands:

| Command | Description | `lua` |
| --------------- | --------------- | --------------- |
| PomodoriniStart <mins> | Start a timer for <mins> | require("pomodorini").start_timer(mins) |
| PomodoriniShow | Show the pomodorini window | require("pomodorini").pomodorini_show() |
| PomodoriniHide | Hide the pomodorini window | require("pomodorini").pomodorini_hide() |
| PomodoriniPauseToggle | Pause the pomodorini timer | require("pomodorini").pomodorini_pause_toggle() |

