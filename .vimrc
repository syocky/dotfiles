"----------------------------------------
" 初期設定: "{{{
"

" Vi互換をオフ
set nocompatible

scriptencoding utf-8

let s:iswin = has('win32') || has('win64')

if s:iswin
  " Windowsでディレクトリパスの区切り文字表示に / を使えるようにする
  set shellslash
endif


" 自動コマンド初期化
augroup MyAutoCmd
  autocmd!
augroup END

" ユーザランタイムパス設定
if s:iswin
  let $MY_VIMRUNTIME = expand('~/vimfiles')
else
  let $MY_VIMRUNTIME = expand('~/.vim')
endif

" 一時ファイルパス設定
let $MY_VIM_TMPDIR = expand('$MY_VIMRUNTIME/.tmp')

filetype off

if has('vim_starting')
  " ローカル設定ファイル読み込み
  if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
  endif
  " NeoBundleをロード
  if &runtimepath !~ '/neobundle.vim'
    execute 'set runtimepath+=' . '$MY_VIMRUNTIME/bundle/neobundle.vim'
  endif
  call neobundle#rc(expand('$MY_VIMRUNTIME/bundle'))
endif

" プラグイン群
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'jceb/vim-hier'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'mattn/learn-vimscript'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'Rip-Rip/clang_complete'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-session'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
NeoBundle 'sgur/unite-qf'
NeoBundle 'thinca/vim-fontzoom'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/restart.vim'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'vim-jp/cpp-vim'
NeoBundle 'vim-scripts/DoxygenToolkit.vim'
NeoBundle 'vim-scripts/taglist.vim'

filetype plugin indent on

"}}}

"----------------------------------------
" 文字コード: "{{{
"

set encoding=utf-8
if s:iswin
  set termencoding=cp932
else
  set termencoding=utf-8
endif
set fileformat=unix
set fileformats=unix,dos,mac
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,utf-8,cp932,sjis

"}}}

"----------------------------------------
" 基本設定: "{{{
"

" バックアップ、スワップファイル設定
set backup
set backupdir=$MY_VIM_TMPDIR/bak
if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
endif
set backupext=.bak
set directory=$MY_VIM_TMPDIR/swp
if !isdirectory(&directory)
  call mkdir(&directory, "p")
endif
" viminfoの出力先を設定
set viminfo+=n$MY_VIM_TMPDIR/.viminfo
" クリップボードを共有
"set clipboard+=unnamed
" ビジュアルモードで選択したテキストが自動でクリッポボードに入る
set clipboard+=autoselect
" 8進数を無効にする。<C-a>,<C-x>に影響する
set nrformats-=octal
" キーコードやマッピングされたキー列が完了するのを待つ時間(ミリ秒)
"set timeoutlen=3500
" 編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set hidden
" ヒストリの保存数
set history=100
" 日本語の行の連結時には空白を入力しない
set formatoptions+=mM
" Visual blockモードでフリーカーソルを有効にする
set virtualedit=block
" カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" □や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
" コマンドライン補完するときに強化されたものを使う
set wildmenu
" コマンド補完候補をリスト表示、最長マッチ
set wildmode=list:longest
" マウスを有効にする
if has('mouse')
  set mouse=a
endif
" カレントディレクトリから親ディレクトリをさかのぼって tags ファイルを検索
set tags& tags+=tags
" カレントディレクトリ以下を再帰的に検索
"set tags+=./**/tags
" 外部でファイルが編集された時に自動で読み込む
set autoread
" <Leader>を, に設定
let mapleader=","

"}}}

"----------------------------------------
" 検索: "{{{
"

" 検索の時に大文字小文字を区別しない
" ただし大文字小文字の両方が含まれている場合は大文字小文字を区別する
set ignorecase
set smartcase
" 検索時にファイルの最後まで行ったら、そこで検索をやめる
set nowrapscan
" インクリメンタルサーチ
set incsearch
" 検索文字の強調表示
set hlsearch
" w,bの移動で認識する文字
"set iskeyword=a-z,A-Z,48-57,_,.,-,>
"vimgrep をデフォルトのgrepとする場合internal
"set grepprg=internal
set grepprg=grep\ -nH
" vimgrepでの検索後、QuickFixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost vimgrep cw
" 検索で飛んだらそこを真ん中に
for maptype in ['n', 'N', '*', '#', 'g*', 'g#', 'G']
  execute 'nmap' maptype maptype . 'zz'
endfor
" コマンドラインモードでの検索で自動エスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

"}}}

"----------------------------------------
" 表示設定: "{{{
"

" ハイライトを有効
syntax enable
if !s:iswin
  "256色モード
  set t_Co=256
  "モードにあわせてカーソル形状変更
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"  let &t_SI = "\<Esc>]12;lightgreen\x7"
"  let &t_EI = "\<Esc>]12;white\x7"
"   if &term == "xterm-256color"
"     let &t_SI .= "\eP\e[3 q\e\\"
"     let &t_EI .= "\eP\e[1 q\e\\"
"   elseif &term == "xterm"
"     let &t_SI .= "\e[3 q"
"     let &t_EI .= "\e[1 q"
"   endif
endif
" スプラッシュ(起動時のメッセージ)を表示しない
"set shortmess+=I
" エラー時の音とビジュアルベルの抑制(gvimは.gvimrcで設定)
set noerrorbells
set novisualbell
set visualbell t_vb=
" マクロ実行中などの画面再描画を行わない
"set lazyredraw
" 行番号表示
set number
if version >= 703
  " 相対行番号表示(7.3)
  "set relativenumber
endif
" 括弧の対応表示時間
"set showmatch
set matchtime=0
" タブ設定
set ts=2 sw=2 sts=2 ex
" インデント
set autoindent
set smartindent
" Cインデントの設定
set cindent
set cinoptions+=:0,g0,j1
" タイトルを表示
set title
" タブページを常に表示
set showtabline=2
" タブのラベル表示設定
set guitablabel=%N:%t
" コマンドラインの高さ (gvimはgvimrcで指定)
set cmdheight=2
set laststatus=2
" コマンドをステータス行に表示
set showcmd
" 画面最後の行をできる限り表示する
set display=lastline
" ウィンドウ幅で行を折り返す
set wrap
" Tab、行末の半角スペースを明示的に表示する
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<
" スクロール時に表示を5行確保
set scrolloff=10
" カーソルが常に中央行
" set scrolloff=999
" 行間設定
set linespace=1
" フォールディング設定
set foldmethod=marker
set foldlevel=100
" 補完選択時にScratchウィンドウを開かないようにする
set completeopt=menuone
" 他のバッファから補完をしない
set complete=.
" 改行でコメント自動挿入抑止
autocmd MyAutoCmd FileType * setlocal formatoptions-=ro
" Vimスクリプトでバックスラッシュ挿入でインデント抑止
let g:vim_indent_cont = 0
" 自動折り返しを無効化
autocmd MyAutoCmd FileType * setlocal textwidth=0
" 編集中の行に下線を引く
autocmd MyAutoCmd InsertLeave * setlocal nocursorline
autocmd MyAutoCmd InsertEnter * setlocal cursorline
"autocmd MyAutoCmd InsertLeave * highlight CursorLine ctermfg=145 guifg=#c2bfa5 guibg=#000000
"autocmd MyAutoCmd InsertEnter * highlight CursorLine cterm=underline ctermfg=2 ctermbg=NONE gui=underline guifg=#1E90FF guibg=NONE
autocmd MyAutoCmd InsertEnter * highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE
"set cursorline
"highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE
" ファイルタイプ毎のインデント設定
autocmd MyAutoCmd FileType c          setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType cs         setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType css        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType diff       setlocal sw=4 sts=4 ts=4 noet
autocmd MyAutoCmd FileType html       setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType java       setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType jsp        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType javascript setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType perl       setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType php        setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType python     setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType haml       setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType sh         setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType sql        setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType text       setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType vb         setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType vim        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType xhtml      setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType xml        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType scala      setlocal sw=2 sts=2 ts=2 et

" ハイライトを有効にする
"if &t_Co > 2 || has('gui_running')
"  syntax on
"endif
" カラースキーム
"colorscheme torte
"colorscheme desert256
colorscheme jellybeans

" ボップアップのハイライトを設定
highlight Pmenu ctermbg=1 guibg=DarkBlue
highlight PmenuSel ctermbg=5 guibg=DarkMagenta
highlight PmenuSbar ctermbg=0 guibg=Black

" Javaのハイライト設定
"全てのクラスをハイライトする
let g:java_highlight_all = 1
"メソッド宣言文をハイライト
let g:java_highlight_functions = 1
"デバッグ分(print系)をハイライト
let g:java_highlight_debug = 1
"余分な空白に対してハイライト
let g:java_space_errors = 1

" doxygenのハイライト設定
let g:load_doxygen_syntax = 1

" ステータスラインに文字コード等表示 "{{{
" if has('iconv')
"   set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=[0x%{FencB()}]\ (%v,%l)/%L%8P\
" else
"   set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\
" endif

" FencB() : カーソル上の文字コードをエンコードに応じた表示にする
" function! FencB()
"   let c = matchstr(getline('.'), '.', col('.') - 1)
"   let c = iconv(c, &enc, &fenc)
"   return s:Byte2hex(s:Str2byte(c))
" endfunction

" function! s:Str2byte(str)
"   return map(range(len(a:str)), 'char2nr(a:str[v:val])')
" endfunction

" function! s:Byte2hex(bytes)
"   return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
" endfunction
"}}}

" UTF8、SJIS(CP932)、EUCJPで開き直す "{{{
command! -bang -nargs=? Utf8
\ edit<bang> ++enc=utf-8 <args>
command! -bang -nargs=? Sjis
\ edit<bang> ++enc=cp932 <args>
command! -bang -nargs=? Euc
\ edit<bang> ++enc=eucjp <args>
"}}}

"}}}

"----------------------------------------
" キーマッピング: "{{{
"

" 強制全保存終了を無効化
nnoremap ZZ <Nop>
" 表示行移動
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap 0 g0
nnoremap g0 0
nnoremap $ g$
nnoremap g$ $
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap h <Left>
nnoremap l <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
" 分割画面
noremap <silent> <Space>s :sp<CR>
noremap <silent> <Space>v :vs<CR>
nnoremap <silent> <space>wj <C-w>j
nnoremap <silent> <space>wk <C-w>k
nnoremap <silent> <space>wl <C-w>l
nnoremap <silent> <space>wh <C-w>h
nnoremap <silent> <space>wJ <C-w>J
nnoremap <silent> <space>wK <C-w>K
nnoremap <silent> <space>wL <C-w>L
nnoremap <silent> <space>wH <C-w>H
nnoremap <silent> <space>wr <C-w>r
nnoremap <silent> <space>w= <C-w>=
nnoremap <silent> <space>ww <C-w>w
nnoremap <silent> <space>wo <C-w>o
nnoremap <silent> <Space>wx <C-w>x
nnoremap <silent> <Space>w- <C-w>10-
nnoremap <silent> <Space>w+ <C-w>10+
nnoremap <silent> <Space>w> <C-w>10>
nnoremap <silent> <Space>w< <C-w>10<
" タブ
nnoremap <silent> <Space>tn :<C-u>tabnew<CR>
nnoremap <silent> <Space>tc :<C-u>tabclose<CR>
nnoremap <silent> <Space>n gt
nnoremap <silent> <Space>p gT

" l を <Right>に置き換えても、折りたたみを l で開くことができるようにする
if has('folding')
  nnoremap <expr> l foldlevel(line('.')) ? "\<Right>zo" : "\<Right>"
endif
" 折りたたみオープン、クローズ
nnoremap <silent> <space>fc :<C-u>%foldclose<CR>
nnoremap <silent> <space>fo :<C-u>%foldopen<CR>

" ESCキー連打でハイライトを消す
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" カーソル位置の単語をヤンク文字列に置換
nnoremap <silent> cy ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

" コマンド履歴、検索履歴のキーマッピングを変更
noremap qqq: <ESC>q:
noremap qqq/ <ESC>q/
noremap qqq? <ESC>q?
noremap q: <Nop>
noremap q/ <Nop>
noremap q? <Nop>

" 最後に編集したところを選択
"nnoremap gc `[v`]

" ペーストしたテキストを再選択
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" ノーマルモード時にEnter2回で改行
"nnoremap <CR><CR> :<C-u>call append(expand('.'), '')<CR>j

" 挿入モード終了時にIME状態を保存しない
inoremap <silent> <ESC> <ESC>
inoremap <silent> <C-[> <ESC>
" 「日本語入力固定モード」切り替えキー
inoremap <silent> <C-j> <C-^>
" fコマンドなどでのIMEをOFFにする
let g:IMState = 0
autocmd MyAutoCmd InsertEnter * let &iminsert = g:IMState
autocmd MyAutoCmd InsertLeave * let g:IMState = &iminsert|set iminsert=0 imsearch=0

" ビジュアルモードで選択した部分をヤンク文字列で置換
vnoremap <silent> cy c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
" インデント変更後も選択を継続する
vnoremap < <gv
vnoremap > >gv

" 選択部分をクリップボードにコピー
vnoremap <C-C> "*y
" 挿入モード時、クリップボードから貼り付け
inoremap <C-V> <ESC>"*pa
" 選択部分をクリップボードの値に置き換え
vnoremap <C-V> d"*P
" コマンドライン時、クリップボードから貼り付け
cnoremap <C-V> <C-R>*
" 選択部分をクリップボードに切り取り
vnoremap <C-X> "*d<ESC>
" 全選択
nnoremap <C-a> ggVG

" 括弧までを消したり置換する
" http://vim-users.jp/2011/04/hack214/
vnoremap ( t(
vnoremap ) t)
vnoremap ] t]
vnoremap [ t[
onoremap ( t(
onoremap ) t)
onoremap ] t]
onoremap [ t[

" タグジャンプ
nnoremap <C-]> g<C-]>
nnoremap g<C-]> <C-]>
"}}}

"----------------------------------------
" Vimスクリプト: "{{{
"

" 最後に編集した場所にカーソルを移動する "{{{
autocmd MyAutoCmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line('$') |
\   exe "normal! g`\"" |
\ endif
"}}}

" 挿入モード時、ステータスラインのカラー変更
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  autocmd MyAutoCmd InsertEnter * call s:StatusLine('Enter')
  autocmd MyAutoCmd InsertLeave * call s:StatusLine('Leave')
endif
" if has('unix') && !has('gui_running')
"   " ESCですぐに反映されない対策
"   inoremap <silent> <ESC> <ESC>
" endif

let s:slhlcmd = ''
function! s:StatusLine(mode) "{{{
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
    redraw
  endif
endfunction "}}}

function! s:GetHighlight(hi) "{{{
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction "}}}

" 全角スペース、行末スペースを強調表示 "{{{
function! HighlightSpace()
  silent! let hi = s:GetHighlight('HighlightSpace')
  if hi =~ 'E411' || hi =~ 'cleared$'
    highlight HighlightSpace cterm=underline ctermfg=red gui=underline guifg=red
  endif
endfunction
if has('syntax')
    autocmd MyAutoCmd ColorScheme       * call  HighlightSpace()
    autocmd MyAutoCmd VimEnter,WinEnter * match HighlightSpace /　\|\s\+$/
  call HighlightSpace()
endif
"}}}

" カレントディレクトリをファイルと同じディレクトリに移動する "{{{
"if exists('+autochdir')
"  "autochdirがある場合カレントディレクトリを移動
"  set autochdir
"else
"  "autochdirが存在しないが、カレントディレクトリを移動したい場合
"  au BufEnter * execute ":silent! lcd " . escape(expand("%:p:h"), ' ')
"endif
"}}}

" セッションを自動保存・復元する "{{{
" セッション保存ファイルのフルパス
"let s:last_session = expand('$HOME/.vim_last_session')
" VIM終了時にセッション保存ファイルに上書き保存
"au VimLeave * exe "mks! " . s:last_session
" 起動時にセッションファイルがあるかどうかチェック
"if argc() == 0 && filereadable(s:last_session)
  " あった場合読み込む
"  au VimEnter * exe "so " . s:last_session
"endif
"}}}

" matchitスクリプトを読み込む
"source $MY_VIMRUNTIME/macros/matchit.vim

" C/C++関数をハイライト "{{{
" function! s:HighlightCFunction()
"   syntax match CFunc /[A-Z_a-z]\w*\(\s*(\)\@=/
"   highlight CFunc ctermfg=DarkCyan guifg=DarkCyan
" endfunction
" autocmd MyAutoCmd FileType c,cpp call HighlightCFunction()
"autocmd MyAutoCmd FileType c,cpp syntax match CFunction /[a-zA-Z_]\w*(\@=/
"autocmd MyAutoCmd FileType c,cpp highlight CFunction ctermfg=DarkCyan guifg=DarkCyan
"syntax match CFunction /[a-zA-Z_]\+\w*\s*(\@=/
" syntax match CFunction /[a-zA-Z_]\w*\s*\(\(\[[^]]*\]\s*\)\?(\s*[^\*]\)\@=/
" syntax match CFunction /\*\s*[a-zA-Z_]\w*\s*\(\(\[\]\s*\)\?)\s*(\)\@=/
" highlight CFunction ctermfg=DarkCyan guifg=DarkCyan
"}}}

" Quickfixウィンドウの開閉をトグル "{{{
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
  endif
endfunction
nnoremap <silent> <Space>qt :<C-u>call <SID>toggle_quickfix_window()<CR>
"}}}

" clipboardにunnamedを追加 "{{{
function! s:toggle_clipboard_unnamed()
  if &clipboard =~# 'unnamed'
    set clipboard-=unnamed
    echo 'clipboard mode OFF'
  else
    set clipboard+=unnamed
    echo 'clipboard mode ON'
  endif
endfunction
command! ToggleClipboardUnnamed call s:toggle_clipboard_unnamed()
nnoremap <silent> <Space>P :<C-u>call <SID>toggle_clipboard_unnamed()<CR>
"}}}

" 末尾空白削除 "{{{
function! s:trim_last_white_space() range
  execute a:firstline . ',' . a:lastline . 's/\s\+$//e'
endfunction
command! -range=% Trim :<line1>,<line2>call <SID>trim_last_white_space()
nnoremap <silent> <Space>tr :<C-u>%Trim<CR>
vnoremap <silent> <Space>tr :<C-u>Trim<CR>
"}}}

"}}}

"----------------------------------------
" 各プラグイン設定: "{{{
"

" caw "{{{
nmap <Leader>c  <Plug>(caw:prefix)
vmap <Leader>c  <Plug>(caw:prefix)
nmap <Leader>cc <Plug>(caw:I:toggle)
vmap <Leader>cc <Plug>(caw:I:toggle)
"}}}

" clang-complete "{{{
let g:clang_auto_select = 0
let g:clang_complete_auto = 0
let g:clang_debug = 0
let g:clang_use_library = 1
let g:clang_library_path = $MY_CLANG_PATH
let g:clang_exec = $MY_CLANG_PATH . '/clang.exe'
let g:clang_user_options =
\ '-fms-extensions -fgnu-runtime '.
\ '-include malloc.h '.
\ '-std=gnu++0x '
"}}}

" jellybeans "{{{
" コメントのitalicを解除
let g:jellybeans_overrides = {
\ 'Comment' : { 'gui' : 'NONE' }
\}
"}}}

" neobundle "{{{
" RbでNeoBundleの反映
command! -bang Rb :Unite neobundle/install:<bang>
"}}}

" neocomplcache "{{{
" neocomplcacheを有効設定
let g:neocomplcache_enable_at_startup = 1
" 一時ディレクトリ
let g:neocomplcache_temporary_dir = expand('$MY_VIM_TMPDIR/.neocon')
" ユーザー定義スニペット保存ディレクトリ
let g:neocomplcache_snippets_dir = expand('$MY_VIMRUNTIME/snippets')
" smartcaseを有効設定
let g:neocomplcache_enable_smart_case = 1
" 補完候補を自動選択設定
let g:neocomplcache_enable_auto_select = 1
" デリミタ自動補完設定
let g:neocomplcache_enable_auto_delimiter = 1
" _区切りの補完を有効設定
let g:neocomplcache_enable_underbar_completion = 1
" completefuncを強制上書き
let g:neocomplcache_force_overwrite_completefunc = 1
" キーワードパターン定義
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" オムニ補完
autocmd MyAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd MyAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd MyAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd MyAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd MyAutoCmd FileType java setlocal omnifunc=eclim#java#complete#CodeComplete
" オムニ補完のキーワードパターン定義
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.java = '\%(\h\w*\|)\)\.'
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
"let g:neocomplcache_force_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
" 辞書ファイルの定義
let g:neocomplcache_dictionary_filetype_lists = {
\ 'default'  : '',
\ 'vimshell' : $MY_VIM_TMPDIR.'/.vimshell/command-history',
\ 'java'     : $MY_VIMRUNTIME.'/dict/java.dict'
\ }
" Javaのinclude補完用
autocmd MyAutoCmd FileType java setlocal include=^import | setlocal includeexpr=substitute(v:fname,'\\.','/','g')
" includeファイルパス
let g:neocomplcache_include_paths = {
\ 'java' : '.,$MY_JAVA_SRC_PATH,$MY_ANDROID_SRC_PATH'
\ }
" キーマッピング
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>  neocomplcache#undo_completion()
inoremap <expr><C-l>  neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ neocomplcache#start_manual_complete()
function! s:check_back_space()"{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "\<CR>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

"}}}

" restart.vim "{{{
command!
\ -bar
\ RestartWithSession
\ let g:restart_sessionoptions = 'blank,buffers,curdir,folds,help,localoptions,tabpages'
\ | Restart
"}}}

" unite "{{{
" unite prefix key.
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap <Leader>u [unite]
xmap <Leader>u [unite]

" unite general settings
" インサートモードで開始
let g:unite_enable_start_insert = 1
" unite, sourceが内部で保存するディレクトリ
let g:unite_data_directory = expand('$MY_VIM_TMPDIR/.unite')
" 最近開いたファイル履歴の保存数
let g:unite_source_file_mru_limit = 50

" file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''

" grepデフォルトオプション指定
let g:unite_source_grep_default_opts = '-iRHn'

" For unite-session.
" Save session automatically.
let g:unite_source_session_enable_auto_save = 1
let g:unite_source_session_options = "blank,buffers,curdir,folds,help,tabpages,winsize"
let g:unite_source_session_enable_beta_features = 1
"autocmd MyAutoCmd VimEnter * UniteSessionLoad

" キーマッピング
" 現在開いているファイルのディレクトリ下のファイル一覧
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" バッファ一覧
nnoremap <silent> [unite]bt :<C-u>Unite -buffer-name=files buffer_tab<CR>
" レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register history/yank<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=files file_mru directory_mru<CR>
" ブックマーク一覧
nnoremap <silent> [unite]bl :<C-u>Unite bookmark<CR>
" ブックマークに追加
nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd<CR>
" アウトライン解析
nnoremap <silent> [unite]oi  :<C-u>Unite outline -start-insert<CR>
nnoremap <silent> [unite]ov  :<C-u>Unite -no-quit -vertical -winwidth=50 outline<CR>
" セッションロード
nnoremap <silent> [unite]sl :<C-u>UniteSessionLoad<CR>
" unite-outline
let g:unite_source_outline_filetype_options = {
\ '*': {
\   'auto_update': 1,
\   'auto_update_event': 'write',
\ },
\ 'cpp': {
\   'auto_update': 0,
\ },
\}
call unite#set_buffer_name_option('outline', 'ignorecase', 1)
call unite#set_buffer_name_option('outline', 'smartcase',  1)
" unite-tag
nnoremap <silent> [unite]tt  :<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag<CR>
nnoremap <silent> [unite]ti  :<C-u>UniteWithCursorWord -buffer-name=tag tag/include<CR>
"autocmd MyAutoCmd BufEnter *
"  \  if empty(&buftype) |
"  \    nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR> |
"  \  endif
" unite-help
nnoremap <silent> [unite]hi :<C-u>Unite -start-insert help<CR>
nnoremap <silent> [unite]hc :<C-u>UniteWithCursorWord help<CR>
" unite-grep
nnoremap <silent> [unite]g  :<C-u>Unite grep -buffer-name=search -no-quit<CR>
" unite-colorscheme
nnoremap <silent> [unite]pc :<C-u>Unite -auto-preview colorscheme<CR>
" unite-alignta
let g:unite_source_alignta_preset_arguments = [
\ ["Align at '='", '=>\='],
\ ["Align at ':'", '01 :'],
\ ["Align at '|'", '|'   ],
\ ["Align at ')'", '0 )' ],
\ ["Align at ']'", '0 ]' ],
\ ["Align at '}'", '}'   ],
\]
let s:comment_leadings = '^\s*\("\|#\|/\*\|//\|<!--\)'
let g:unite_source_alignta_preset_options = [
\ ["Justify Left",      '<<' ],
\ ["Justify Center",    '||' ],
\ ["Justify Right",     '>>' ],
\ ["Justify None",      '==' ],
\ ["Shift Left",        '<-' ],
\ ["Shift Right",       '->' ],
\ ["Shift Left  [Tab]", '<--'],
\ ["Shift Right [Tab]", '-->'],
\ ["Margin 0:0",        '0'  ],
\ ["Margin 0:1",        '01' ],
\ ["Margin 1:0",        '10' ],
\ ["Margin 1:1",        '1'  ],
\
\ 'v/' . s:comment_leadings,
\ 'g/' . s:comment_leadings,
\]
unlet s:comment_leadings

nnoremap <silent> [unite]a :<C-u>Unite alignta:options<CR>
xnoremap <silent> [unite]a :<C-u>Unite alignta:arguments<CR>

" uniteを開いている間のキーマッピング
autocmd MyAutoCmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  "入力モードのときjjでノーマルモードに移動
  imap <buffer> jj <Plug>(unite_insert_leave)
  "入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "ctrl+jで縦に分割して開く
  nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  "ctrl+lで横に分割して開く
  nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  "ctrl+oでその場所に開く
  nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
endfunction"}}}
"}}}

" vimfiler "{{{
" vimfiler prefix key.
nnoremap [vimfiler] <Nop>
nmap <Leader>f [vimfiler]
" vimfilerをデフォルトのファイラにする
let g:vimfiler_as_default_explorer = 1
" vimfiler, sourceが内部で保存するディレクトリ
let g:vimfiler_data_directory = expand('$MY_VIM_TMPDIR/.vimfiler')
" セーフモード設定
let g:vimfiler_safe_mode_by_default = 0
" 自動cdのON/OFF
let g:vimfiler_enable_auto_cd = 0
" ファイル編集アクション
"let g:vimfiler_edit_action = 'tabopen'
if s:iswin
  " Use trashbox.
  let g:unite_kind_file_use_trashbox = 1
endif
" ファイル関連付け
call vimfiler#set_execute_file('txt', 'vim')
" キーマッピング
nnoremap <silent> [vimfiler]e :<C-u>VimFilerExplorer<CR>

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()"{{{
  nmap <silent> <Space>m <Plug>(vimfiler_toggle_mark_current_line)
  nmap <silent> <S-Space>m <Plug>(vimfiler_toggle_mark_current_line_up)
endfunction"}}}
"}}}

" vimproc "{{{
"}}}

" vimshell "{{{
" vimshell prefix key.
nnoremap [vimshell] <Nop>
nmap <Leader>s [vimsh]

" 一時ディレクトリ
let g:vimshell_temporary_directory = expand('$MY_VIM_TMPDIR/.vimshell')
" ユーザ用プロンプト
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" Initialize execute file list.
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['rb'] = 'ruby'
let g:vimshell_execute_file_list['pl'] = 'perl'
let g:vimshell_execute_file_list['py'] = 'python'
" キーマッピング
noremap <silent> [vimsh]h :<C-u>VimShell<CR>
noremap <silent> [vimsh]c :<C-u>VimShellCreate<CR>
noremap <silent> [vimsh]t :<C-u>VimShellTab<CR>
noremap <silent> [vimsh]p :<C-u>VimShellPop<CR>
"}}}

" vim-indent-guides "{{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=DarkCyan ctermbg=DarkCyan
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=DarkBlue ctermbg=DarkBlue
nmap <silent> <Leader>ig <Plug>IndentGuidesToggle
"}}}

" vim-fontzoom "{{{
"}}}

" vim-powerline "{{{
let g:Powerline_symbols = 'fancy'
"}}}

" vim-quickrun "{{{
" g:quickrun_config の初期化
if !exists("g:quickrun_config")
  let g:quickrun_config={}
endif

" デフォルトの設定
" 非同期で実行
" 出力先
" エラー : quickfix
" 成功   : buffer
let g:quickrun_config["_"] = {
\ "runner/vimproc/updatetime" : 80,
\ "outputter/buffer/split" : ":rightbelow 8sp",
\ "outputter/error/error" : "quickfix",
\ "outputter/error/success" : "buffer",
\ "outputter" : "error",
\ "runner" : "vimproc",
\ }

" コンパイラ言語用の outputter
" :QuickRun -outputter
" プロセスの実行中しているときは、buffer に出力し、
" プロセスが終了したら、quickfix へ出力を行う
let my_outputter= quickrun#outputter#multi#new()
let my_outputter.config.targets = ["buffer", "quickfix"]
function! my_outputter.init(session)
  " quickfix を閉じる
  :cclose
  " 元の処理を呼び出す
  call call(quickrun#outputter#multi#new().init, [a:session], self)
endfunction

function! my_outputter.finish(session)
  call call(quickrun#outputter#multi#new().finish, [a:session], self)
  " 出力バッファの削除
  bwipeout [quickrun
endfunction

" quickrun に outputter を登録
call quickrun#register_outputter("my_outputter", my_outputter)

" C++
" バイナリの出力のみ行う（実行は別）
let g:quickrun_config["cpp"] = {
\    "type"    : "cpp",
\    "command" : "g++",
\    "cmdopt"    : "-Wall -I ".$MY_BOOST_PATH,
\    "outputter" : "my_outputter"
\ }

" シンタックスチェック用コンフィグ
let g:quickrun_config["CppSyntaxCheck"] = {
\ "type" : "cpp",
\ "exec" : "%c %o %s:p ",
\ "command" : "g++",
\ "cmdopt" : "-fsyntax-only ",
\ "outputtter" : "my_outputter"
\ }

command! CppSyntaxCheck :QuickRun CppSyntaxCheck

"}}}

" vim-ref "{{{
let g:ref_cache_dir = expand('$MY_VIM_TMPDIR/.ref_cache_dir')
let g:ref_use_vimproc = 1
"}}}

" vim-smartchr "{{{
function! EnableSmartchrBasic()
"  inoremap <buffer><expr> + smartchr#one_of(' + ', '+', '++')
"  inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
  inoremap <buffer><expr> , smartchr#one_of(', ', ',')
"  inoremap <buffer><expr> <Bar> smartchr#one_of('<Bar>', ' <Bar><Bar> ', '<Bar>')
  inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  \ : search('\(\*\<bar>!\)\%#')? '= '
  \ : smartchr#one_of(' = ', ' == ', '=')
endfunction
autocmd MyAutoCmd FileType c,cpp,php,python,java,javascript,ruby,vim call EnableSmartchrBasic()
autocmd MyAutoCmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
"}}}

" vim-fugitive "{{{
nnoremap <Leader>gd :<C-u>Gdiff<Enter>
nnoremap <Leader>gs :<C-u>Gstatus<Enter>
nnoremap <Leader>gl :<C-u>Glog<Enter>
nnoremap <Leader>ga :<C-u>Gwrite<Enter>
nnoremap <Leader>gc :<C-u>Gcommit<Enter>
nnoremap <Leader>gC :<C-u>Git commit --amend<Enter>
nnoremap <Leader>gb :<C-u>Gblame<Enter>
"}}}

" vim-surround "{{{
"}}}

" vim-visualstar "{{{
" 検索後に移動しない設定
map * <Plug>(visualstar-*)N
map # <Plug>(visualstar-#)N
"}}}

" taglist "{{{
" 現在編集中のソースのタグしか表示しない
let Tlist_Show_One_File = 1
nnoremap <Leader>tl :<C-u>TlistToggle<CR>
"}}}

"}}}

