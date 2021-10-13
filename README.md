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
vim.o.tabline = '%!v:lua.require\'luatab\'.tabline()'

-- without a separator:
vim.o.tabline = '%!v:lua.require\'luatab\'.tabline("")'

-- with / as separator:
vim.o.tabline = '%!v:lua.require\'luatab\'.tabline("/")'

```

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


