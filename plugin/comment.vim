
" Commenting {{{
" ----------

autocmd FileType asciidoc,jade let b:comments = { 'left': '//' }
autocmd FileType css           let b:comments = { 'block': [ '/*', '*/' ] }
autocmd FileType mustache      let b:comments = { 'block': [ '{{!', '}}' ] }
autocmd FileType cterm         let b:comments = { 'left': '*' }
autocmd FileType haml          let b:comments = { 'left': '-#' }
autocmd FileType erlang,tex    let b:comments = { 'left': '%' }
autocmd FileType man           let b:comments = { 'left': '."' }
autocmd FileType vim           let b:comments = { 'left': '"' }
autocmd FileType xdefaults     let b:comments = { 'left': '!' }
autocmd FileType sql,plsql
								\ let b:comments = { 'left': '--', 'block': [ '/*', '*/' ] }
autocmd FileType ada,ahdl,vhdl,lua,haskell
								\ let b:comments = { 'left': '--' }
autocmd FileType clojure,dns,dosini,gitconfig,scheme,lisp,tags
								\ let b:comments = { 'left': ';' }
autocmd FileType markdown,django,docbk,genshi,html
								\ let b:comments = { 'block': [ '<!--', '-->' ] }
autocmd FileType actionscript,c,cpp,cs,go,groovy,haxe,java,javascript,objc,
								\php,rc,sass,scala,scss,vala
								\ let b:comments = { 'left': '//', 'block': [ '/*', '*/' ] }
autocmd FileType apache,cmake,coffee,crontab,cucumber,desktop,dhcpd,diff,
								\exports,gitcommit,gitrebase,gnuplot,gtkrc,make,nginx,nimrod,
								\nsis,ntp,perl,po,puppet,python,robots,rspec,ruby,sh,ssh,
								\squid,tcl,tmux
								\ let b:comments = { 'left': '#' }

noremap <silent> <Leader>/ :<C-B>sil <C-E>s/^/<C-R>=escape(b:comments['left'],'\/')<CR>/<CR>:noh<CR>
noremap <silent> <Leader>u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comments['left'],'\/')<CR>//e<CR>:noh<CR>
vmap <Leader>/ :s/^/<C-R>=escape(b:comments['left'],'\/')<CR>/<CR>:noh<CR>
vmap <Leader>u :s/^\V<C-R>=escape(b:comments['left'],'\/')<CR>//e<CR>:noh<CR>
vmap <Leader>\ :s/^\(\_.*\)\%V/<C-R>=escape(b:comments['block'][0],'\/')<CR>\r\1\r<C-R>=escape(b:comments['block'][1],'\/')<CR>/<CR>:nohlsearch<CR>

" }}}
