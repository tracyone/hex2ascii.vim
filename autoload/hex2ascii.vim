"=============================================================================
" FILE: hex2ascii.vim
" AUTHOR: tracyone,tracyone@live.cn
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! hex2ascii#Convert(hexfile,outputfile)
    if !executable("../hex2ascii")
        echom "Please build the hex2ascii program first!See readme.md!"
        return -1;
    endif
    if !filereadable(a:hexfile)
        echom "Can not read file ".a:hexfile
    endif
    call system("../hex2ascii ".a:hexfile." ".a:outputfile)
    if v:shell_error != 0
        echom "Convert Error!"
    endif
    return v:shell_error
endfunction


let &cpo = s:save_cpo
unlet! s:save_cpo

" vim: foldmethod=marker
