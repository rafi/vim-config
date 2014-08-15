" == "acomment" == {{{
"
"          File:  assistant.vim
"          Path:  ~/.vim/plugin
"        Author:  Alvan
"      Modifier:  Alvan
"      Modified:  2014-07-22
"       License:  Public Domain
"   Description:  Display the definition of functions, variables, etc
"
" --}}}

" Exit if already loaded
if exists("g:loaded_assistant")
    finish
endif
let g:loaded_assistant = "1.5.8"

let s:aChar = '[a-zA-Z0-9_#]'
let s:aTags = '[fm]'

let s:types = {}
let s:paths = {}
let s:dicts = {}

"command! -nargs=1 Find call s:Find(<f-args>)

function! Find(name)
    " Retrieve tags of the 'f' kind
    let results = taglist('^'.a:name)
    let results = filter(results, 'v:val["kind"] == "c"')

    " Prepare them for inserting in the quickfix window
    let qf_taglist = []
    for entry in results
        call add(qf_taglist, {
            \ 'pattern':  entry['cmd'],
            \ 'filename': entry['inherits'],
            \ })
    endfor

    " Place the tags in the quickfix window, if possible
    if len(qf_taglist) > 0
        call setqflist(qf_taglist)
        copen
    else
        echo "No tags found for ".a:name
    endif
endfunction

function s:GetFileType()
    return getwinvar(winnr(), '&filetype')
endf

function s:LocUserDict(...)
    let type = a:0 < 1 ? s:GetFileType() : a:1

    if type == ''
        return 0
    endif

    if !has_key(s:types, type)
        let s:types[type] = type
    endif

    if !has_key(s:paths, s:types[type])
        let s:paths[s:types[type]] = expand(substitute(globpath(&rtp, 'plugin/assistant/'), "\n", ',', 'g').s:types[type].'.dict.txt')
    endif

    if !has_key(s:dicts, s:types[type])
        let s:dicts[s:types[type]] = {}

        if s:paths[s:types[type]] != '' && filereadable(s:paths[s:types[type]])
            for line in readfile(s:paths[s:types[type]])
                let mtls = matchlist(line, '^\s*\([^ ]\+\)\s\+\(.*[^ ]\)\s*$')
                if len(mtls) >= 3
                    let s:dicts[s:types[type]][mtls[1]] = mtls[2]
                endif
            endfor
        endif
    endif

    return has_key(s:paths, s:types[type]) && s:paths[s:types[type]] != '' ? 1 : 0
endf

function PopHelpList()
    if !s:LocUserDict()
        echo 'assistant.ERR: no filetype'
        return
    endif

    let str = getline(".")
    let col = col(".")
    let end = col("$")

    let num = col - 1
    while num >= 0
        if strpart(str, num, 1) !~ s:aChar
            break
        endif
        let lcol = num
        let num -= 1
    endw
    if !exists("lcol")
        echo 'assistant.ERR: The current content under the cursor is not a keyword'
        return
    endif

    let num = col - 1
    while num <= end
        if strpart(str, num, 1) !~ s:aChar
            break
        endif
        let rcol = num
        let num += 1
    endw

    let list = []
    let type = s:GetFileType()
    let keys = keys(s:dicts[s:types[type]])

    let len = len(keys) - 1
    let key = strpart(str, lcol, rcol-lcol+1)

    let tlst = taglist('^'.key.'$')
    let tlen = len(tlst) - 1
    while tlen >= 0
        if tlst[tlen]['kind'] =~ s:aTags
            call add(list, substitute(substitute(tlst[tlen]['cmd'], '^\s*/^\s*', '', ''), '\s*\$/$', '', '') . '  in  ' . pathshorten(tlst[tlen]['filename']))
        endif
        let tlen -= 1
    endw

    while len >= 0
        if keys[len] == key || keys[len] =~ '[\.:]'.key.'$'
            call add(list, keys[len] . s:dicts[s:types[type]][keys[len]])
        endif
        let len -= 1
    endw

    echo len(list) > 0 ? join(sort(list), "\n") : 'assistant.MIS: "'.key.'"'
endf
" vim:ft=vim:ff=unix:tabstop=4:shiftwidth=4:softtabstop=4:expandtab
