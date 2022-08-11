vim.opt.background = "light"

local t = os.date("*t").hour
if t >= 20 then
    vim.opt.background = "dark"
end

-- vim.g.tokyonight_transparent_sidebar = true
-- vim.g.tokyonight_transparent = true

-- vim.cmd("colorscheme tokyonight")

local scheme = "solarized"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)

if not status_ok then
    vim.notify("colorscheme " .. scheme .. " not found!")
    vim.cmd("colorscheme default")
    return
end
