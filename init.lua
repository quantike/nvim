require("quantike")


local time = os.date("*t")
print(("Logged in @ %02d:%02d:%02d"):format(time.hour, time.min, time.sec))

vim.o.backgroundi = "dark"
vim.cmd([[colorscheme gruvbox]])

