local pomodorini = require("pomodorini")

local cfg = pomodorini.get_config()

vim.api.nvim_create_user_command("PomodoriniStart", function(args)
	if args.args then
		local duration = tonumber(args.args) -- Convert the string to a number
		if duration then
			pomodorini.start_timer(duration)
		else
			pomodorini.start_timer(cfg.timer_dur)
		end
	end
end, {
	nargs = 1, -- Require exactly one argument
})

vim.api.nvim_create_user_command("PomodoriniHide", function()
	pomodorini.pomodorini_hide()
end, {})

-- User command to show the window
vim.api.nvim_create_user_command("PomodoriniShow", function()
	pomodorini.pomodorini_show()
end, {})

-- User command to show the window
vim.api.nvim_create_user_command("PomodoriniPauseToggle", function()
	pomodorini.pomodorini_pause_toggle()
end, {})
