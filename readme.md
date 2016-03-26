# hexadecimal to ascii

Convert textfile which contain hex chars to ascii.

Similar to `Save With Encoding-Hexiadecimal` in SublimeText 3.

Usage:

```vim
:call Hex2asciiConvert()
```

return 0 if convert successfully,return negative number if error.

Use [ vim-plug ](https://github.com/junegunn/vim-plug) to install hex2ascii

```vim
"Use vim-plug to install hex2ascii
Plug 'tracyone/hex2ascii.vim', { 'do': 'make' }
```
