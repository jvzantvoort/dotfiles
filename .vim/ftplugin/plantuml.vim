if exists("g:loaded_plantuml_plugin")
    finish
endif

let g:loaded_plantuml_plugin = 1

if !exists("g:plantuml_executable_script")
    let g:plantuml_executable_script="plantuml"
endif

let s:path=expand("%")
let s:path=fnameescape(s:path)
let s:makecommand=g:plantuml_executable_script." ".s:path

augroup PLANTUMLPLUG
	autocmd Filetype plantuml let &l:makeprg=s:makecommand
augroup END
