if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

let python_highlight_builtins = 1
let python_highlight_exceptions = 1
let python_highlight_numbers = 1

" compiler pylint
setlocal autoindent
setlocal expandtab
setlocal shiftwidth=4
setlocal smarttab
setlocal softtabstop=4
setlocal tabstop=4
setlocal errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

