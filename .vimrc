"itochan's vimrc

set nocompatible

"vundle settings {{{
  filetype off
  set rtp+=~/.vim/vundle/
  call vundle#rc()

  "Bundle 'gmarik/vundle'
  Bundle 'mrkn/mrkn256.vim'
  Bundle 'Shougo/neocomplcache'
  Bundle 'Shougo/unite.vim'
  Bundle 'Align'
  Bundle 'vim-ruby/vim-ruby'
  Bundle 'ruby-matchit'
  Bundle 'thinca/vim-quickrun'
  Bundle 'Shougo/vimproc'
  Bundle 'Shougo/vimshell'
  Bundle 'pangloss/vim-javascript'
  Bundle 'nono/jquery.vim'
  Bundle 'nginx.vim'
  Bundle 'basyura/jslint.vim'
  Bundle 'tpope/vim-rails'
  Bundle 'hallison/vim-ruby-sinatra'
  Bundle 'tpope/vim-haml'
  Bundle 'tpope/vim-surround'
  Bundle 'othree/html5.vim'
  Bundle 'hail2u/vim-css3-syntax'
  Bundle 'lilydjwg/colorizer'
  Bundle 'cakebaker/scss-syntax.vim'
  Bundle 'YankRing.vim'
  Bundle 'sjl/gundo.vim'
  Bundle 't9md/vim-textmanip'
  Bundle 'kana/vim-operator-user'
  Bundle 'tyru/operator-html-escape.vim'
  Bundle 'tpope/vim-endwise'
  Bundle 'tpope/vim-bundler'
  Bundle 'tpope/vim-git'
  Bundle 'tpope/vim-rake'
  Bundle 'tpope/vim-markdown'
  Bundle 'mattn/gist-vim'
  Bundle 'sudo.vim'
  Bundle 'The-NERD-Commenter'
  Bundle 'acustodioo/vim-tmux'
  Bundle 'scrooloose/syntastic'
  Bundle 'msanders/cocoa.vim'
  Bundle 'mattn/webapi-vim'
  Bundle 'mattn/favstar-vim'
  Bundle 'nathanaelkane/vim-indent-guides'

  filetype plugin indent on
"}}}

set number
set backspace=2

"- -> >>- ---> {{{
  set list
  set listchars=tab:>-,trail:-,extends:>,precedes:<
"}}}

"syntax settings
syntax enable

" lang
lang en_US.UTF-8

"neocomplcache settings {{{
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  "let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_smart_case = 0
  " Use camel case completion.
  let g:neocomplcache_enable_camel_case_completion = 1
  " Use underbar completion.
  let g:neocomplcache_enable_underbar_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  imap <C-k>     <Plug>(neocomplcache_snippets_expand)
  smap <C-k>     <Plug>(neocomplcache_snippets_expand)
  inoremap <expr><C-g>     neocomplcache#undo_completion()
  inoremap <expr><C-l>     neocomplcache#complete_common_string()

  " SuperTab like snippets behavior.
  "imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  " AutoComplPop like behavior.
  "let g:neocomplcache_enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplcache_enable_auto_select = 1
  "let g:neocomplcache_disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
  "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
  let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
  "Rubyのオムニ補完を設定(ft-ruby-omni)
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_rails = 1
"}}}

"keymap settings
"http://twitter.com/#!/mactkg/statuses/78873595920646145
map <C-j> <C-d>
map <C-k> <C-u>
map <C-h> 0
map <C-l> $

"search settings
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"Tab completion
set wildmenu
set wildmode=list,full

"backup settings
set backup
if has('win32') || has('win64')
  set backupdir=%TEMP%
else
  set backupdir=/tmp
endif

"undo settings
if has('persistent_undo')
  set undodir=./.vimundo,~/.vimundo
  augroup vimrc-undofile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif

" tags settings
set tags=tags,.tags

"mouse settings
set mouse=i

"encoding settings
set fenc=utf-8
set fencs=ucs_bom,utf-8,euc-jp,iso-2022-jp,cp932 ",utf-16,utf-16le

"gvim settings
if has('gui_running')
  set guifont=Source\ Code\ Pro:h12,Monaco:h12

  "http://vim-users.jp/2010/01/hack120/
  let g:save_window_file = expand('~/.vimwinpos')
  augroup SaveWindow
    autocmd!
    autocmd VimLeavePre * call s:save_window()
    function! s:save_window()
      let options = [
        \ 'set columns=' . &columns,
        \ 'set lines=' . &lines,
        \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
        \ ]
      call writefile(options, g:save_window_file)
    endfunction
  augroup END

  if filereadable(g:save_window_file)
    execute 'source' g:save_window_file
  endif

  "clipboard settings
  set clipboard=unnamed,autoselect

  "mouse settings
  set mouse=a

  "quickrun.vim settings
  if !exists('g:quickrun_config')
    let g:quickrun_config['*'] = {"runmode": "async:remote:vimproc"}
  endif

endif

au FileType c setl ts=8 sw=4 noexpandtab
"indent settings {{{
  set autoindent
  set cindent
  set tabstop=2
  set shiftwidth=2
  set smarttab
  set expandtab
"}}}
au FileType objc setl ts=4 sw=4
au FileType java setl ts=4 sw=4

"color settings
set t_Co=256
colorscheme mrkn256

"statusline settings
set laststatus=2
set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%y%=\ [%v,%l/%L]\ %P

"vimproc settings
nnoremap :! :call vimproc#system('

"macvim settings
if has('gui_macvim')
  set guioptions-=T
  set transparency=20
  set showtabline=2
  nnoremap <C-Tab> gt
  nnoremap <C-S-Tab> gT
endif

augroup RubyTrunk
  autocmd!
  autocmd BufWinEnter,BufNewFile ~/git/ruby/*.c setl ts=8 noexpandtab
  autocmd BufWinEnter,BufNewFile ~/git/ruby/*.y setl ts=8 noexpandtab
augroup END

" http://vrcb.ajunk.org/s/sorah
" cf. http://github.com/ujihisa/config/blob/4cd4f32695917f95e9657feb07b73d0cafa6a60c/_vimrc#L310
function! s:CRuby_setup()
  setlocal tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab
  syntax keyword cType VALUE ID RUBY_DATA_FUNC BDIGIT BDIGIT_DBL BDIGIT_DBL_SIGNED ruby_glob_func
  syntax keyword cType rb_global_variable
  syntax keyword cType rb_classext_t rb_data_type_t
  syntax keyword cType rb_gvar_getter_t rb_gvar_setter_t rb_gvar_marker_t
  syntax keyword cType rb_encoding rb_transcoding rb_econv_t rb_econv_elem_t rb_econv_result_t
  syntax keyword cType RBasic RObject RClass RFloat RString RArray RRegexp RHash RFile RRational RComplex RData RTypedData RStruct RBignum
  syntax keyword cType st_table st_data
  syntax match   cType display "\<\(RUBY_\)\?T_\(OBJECT\|CLASS\|MODULE\|FLOAT\|STRING\|REGEXP\|ARRAY\|HASH\|STRUCT\|BIGNUM\|FILE\|DATA\|MATCH\|COMPLEX\|RATIONAL\|NIL\|TRUE\|FALSE\|SYMBOL\|FIXNUM\|UNDEF\|NODE\|ICLASS\|ZOMBIE\)\>"
  syntax keyword cStatement ANYARGS NORETURN PRINTF_ARGS
  syntax keyword cStorageClass RUBY_EXTERN
  syntax keyword cOperator IMMEDIATE_P SPECIAL_CONST_P BUILTIN_TYPE SYMBOL_P FIXNUM_P NIL_P RTEST CLASS_OF
  syntax keyword cOperator INT2FIX UINT2NUM LONG2FIX ULONG2NUM LL2NUM ULL2NUM OFFT2NUM SIZET2NUM SSIZET2NUM
  syntax keyword cOperator NUM2LONG NUM2ULONG FIX2INT NUM2INT NUM2UINT FIX2UINT
  syntax keyword cOperator NUM2LL NUM2ULL NUM2OFFT NUM2SIZET NUM2SSIZET NUM2DBL NUM2CHR CHR2FIX
  syntax keyword cOperator NEWOBJ OBJSETUP CLONESETUP DUPSETUP
  syntax keyword cOperator PIDT2NUM NUM2PIDT
  syntax keyword cOperator UIDT2NUM NUM2UIDT
  syntax keyword cOperator GIDT2NUM NUM2GIDT
  syntax keyword cOperator FIX2LONG FIX2ULONG
  syntax keyword cOperator POSFIXABLE NEGFIXABLE
  syntax keyword cOperator ID2SYM SYM2ID
  syntax keyword cOperator RSHIFT BUILTIN_TYPE TYPE
  syntax keyword cOperator RB_GC_GUARD_PTR RB_GC_GUARD
  syntax keyword cOperator Check_Type
  syntax keyword cOperator StringValue StringValuePtr StringValueCPtr
  syntax keyword cOperator SafeStringValue Check_SafeStr
  syntax keyword cOperator ExportStringValue
  syntax keyword cOperator FilePathValue
  syntax keyword cOperator FilePathStringValue
  syntax keyword cOperator ALLOC ALLOC_N REALLOC_N ALLOCA_N MEMZERO MEMCPY MEMMOVE MEMCMP
  syntax keyword cOperator RARRAY RARRAY_LEN RARRAY_PTR RARRAY_LENINT
  syntax keyword cOperator RBIGNUM RBIGNUM_POSITIVE_P RBIGNUM_NEGATIVE_P RBIGNUM_LEN RBIGNUM_DIGITS
  syntax keyword cOperator Data_Wrap_Struct Data_Make_Struct Data_Get_Struct
  syntax keyword cOperator TypedData_Wrap_Struct TypedData_Make_Struct TypedData_Get_Struct

  syntax keyword cConstant Qtrue Qfalse Qnil Qundef
  syntax keyword cConstant IMMEDIATE_MASK FIXNUM_FLAG SYMBOL_FLAG

  " for bignum.c
  syntax keyword cOperator BDIGITS BIGUP BIGDN BIGLO BIGZEROP
  syntax keyword cConstant BITPERDIG BIGRAD DIGSPERLONG DIGSPERLL BDIGMAX
endfunction

function! s:CRuby_ext_setup()
  let dirname = expand("%:h")
  let extconf = dirname . "/extconf.rb"
  if filereadable(extconf)
    call s:CRuby_setup()
  endif
endfunction

augroup CRuby
  autocmd!
  autocmd BufWinEnter,BufNewFile ~/git/ruby/*.[chy] call s:CRuby_setup()
  autocmd BufWinEnter,BufNewFile *.{c,cc,cpp,h,hh,hpp} call s:CRuby_ext_setup()
augroup END

" jslint.vim
autocmd FileType javascript call s:javascript_filetype_settings()
function! s:javascript_filetype_settings()
  autocmd BufLeave     <buffer> call jslint#clear()
  autocmd BufWritePost <buffer> call jslint#check()
  autocmd CursorMoved  <buffer> call jslint#message()
endfunction

" Sinatra
function! SinatraInlineTemplateSyntax()
  exec 'unlet b:current_syntax'
  exec 'syn include @syntaxHaml syntax/haml.vim'
  exec 'syn region rubyDataHaml matchgroup=rubyData start="^__END__$" keepend end="\%$" contains=@syntaxHaml'
  exec 'syn match inFileTemplateName "^@@ \(\w\|/\)\+" containedin=rubyDataHaml'
  exec 'hi def link inFileTemplateName Text'
endfunction
au BufNewFile,BufRead *.rb call SinatraInlineTemplateSyntax()

" For Debian-based distribution filetype settings
au BufNewFile,BufRead /etc/nginx/*.conf*,/etc/nginx/sites-*/*,/opt/nginx/conf/*.conf*,/opt/nginx/conf/sites-*/* setf nginx

" colorize auto colorize
au BufNewFile,BufRead *.css*,*.htm,*.html :ColorHighlight

" NERD_commenter.vim
"http://blog.blueblack.net/item_133
"<Leader>xでコメントをトグル(NERD_commenter.vim)
map <Leader>x ,c<space>
"未対応ファイルタイプのエラーメッセージを表示しない
let NERDShutUp=1

"Scouter
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)

" favstar.vim
let g:favstar_user = 'i315'

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup=1
