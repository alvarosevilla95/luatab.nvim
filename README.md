# luatab.nvim

## Usage
Add this to your init.lua:

```
Tabline = require'tabline'.tabline
vim.cmd[[ set tabline=%!luaeval('Tabline()') ]]
```

Note: `require'tabline'.tabline` must be assigned to a global variable for it to be picked up by `luaeval`

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


