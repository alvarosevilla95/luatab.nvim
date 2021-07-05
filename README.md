# luatab.nvim

![luatab](https://github.com/alvarosevilla95/luatab.nvim/blob/master/pics/tabline.png)

## Features
* Just a lua rewrite of the tabline render function
* No weird mixing buffers and tabs stuff

## Install
Using packer.nvim:
```
use { 'alvarosevilla95/luatab.nvim', requires='kyazdani42/nvim-web-devicons' }
```

## Usage
Add this to your init.lua:

```
Tabline = require'luatab'.tabline
vim.cmd[[ set tabline=%!luaeval('Tabline()') ]]
```

Note: `require'luatab'.tabline` must be assigned to a global variable for it to be picked up by `luaeval`. If you know a better method, PRs are welcome.

## Configuration
You can also define your own tabline function using the provided functions for help. The default tabline is equivalent to:
```
local formatTab = require'luatab'.formatTab
Tabline = function()
    local i = 1
    local line = ''
    while i <= vim.fn.tabpagenr('$') do
        line = line .. formatTab(i)
        i = i + 1
    end
    return  line .. '%T%#TabLineFill#%='
end
```


