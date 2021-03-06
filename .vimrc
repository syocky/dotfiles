" encoding {{{ =================================================================
if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif

scriptencoding utf-8
" }}}

" 初期設定 {{{ =================================================================

let s:iswin = has('win32') || has('win64')

if s:iswin
  " Windowsでディレクトリパスの区切り文字表示に / を使えるようにする
  set shellslash
endif

" 自動コマンド初期化
augroup MyAutoCmd
  autocmd!
augroup END

" ユーザランタイムパス
if s:iswin
  let $MY_VIMRUNTIME = expand('~/vimfiles')
else
  let $MY_VIMRUNTIME = expand('~/.vim')
endif

" 一時ファイルパス
let $MY_VIM_TMPDIR = $MY_VIMRUNTIME . '/.tmp'

" プラグインのパス
let s:plugin_dir = $MY_VIMRUNTIME . '/bundle'

" neobundleのパス
let s:neobundle_dir = s:plugin_dir . '/neobundle.vim'

filetype off

if has("vim_starting")
  if !isdirectory(s:neobundle_dir)
    " neobundleがインストールされていない場合、インストールを行う
    if !executable("git")
      echo "Please install git."
      finish
    endif

    function! s:install_neobundle()
      if input("Install neobundle.vim? [Y/N] : ") =~? '^y\(es\)\=$'
        if !isdirectory(s:plugin_dir)
          call mkdir(s:plugin_dir, "p")
        endif
        execute "!git clone git://github.com/Shougo/neobundle.vim " . s:neobundle_dir
        echo "neobundle installed. Please restart vim."
      else
        echo "Canceled."
      endif
    endfunction
    autocmd MyAutoCmd VimEnter * call s:install_neobundle()
    finish
  else
    " ローカル設定ファイル読み込み
    if filereadable(expand('~/.vimrc.local'))
      execute 'source' expand('~/.vimrc.local')
    endif
    " NeoBundleをロード
    if &runtimepath !~ '/neobundle.vim'
      execute 'set runtimepath+=' . s:neobundle_dir
    endif
  endif
endif

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

function! s:SIDP()
  return '<SNR>' . s:SID() . '_'
endfunction

" <Leader>を , に設定
let g:mapleader=","

" セッション項目
set sessionoptions=blank,buffers,curdir,folds,help,localoptions,slash,tabpages

" }}}

" プラグイン群 {{{ =============================================================

call neobundle#begin(s:plugin_dir)

NeoBundle 'alpaca-tc/alpaca_tags'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundleLazy 'elzr/vim-json',
              \ {
              \   'autoload' : {
              \     'filetypes' : 'json'
              \   }
              \ }
NeoBundle 'fatih/vim-go'
NeoBundleLazy 'glidenote/memolist.vim',
              \ {
              \   'autoload' : {
              \     'commands' : [
              \       'MemoNew',
              \       'MemoList',
              \       'MemoGrep',
              \     ]
              \   }
              \ }
NeoBundleLazy 'heavenshell/vim-jsdoc', {
\                 'autoload' : {
\                   'filetypes' : ['javascript']
\                 }
\ }
NeoBundle 'itchyny/landscape.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'jceb/vim-hier'
" NeoBundleLazy 'kana/vim-smartchr',
"               \ {
"               \   'autoload' : {
"               \       'insert' : 1,
"               \   }
"               \ }
NeoBundleLazy 'jelera/vim-javascript-syntax', {
\                 'autoload' : {
\                   'filetypes' : ['javascript']
\                 }
\ }
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'kana/vim-submode'
NeoBundle 'KazuakiM/vim-qfstatusline'
NeoBundleLazy 'marijnh/tern_for_vim', {
\             'build' : {
\               'others' : 'npm install'
\             },
\             'autoload' : {
\               'filetypes' : ['javascript']
\             }
\ }
NeoBundleLazy 'mattn/excitetranslate-vim',
              \ { 'autoload' : {
              \     'commands' : 'ExciteTranslate',
              \   }
              \ }
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-reanimate'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundleLazy 'Shougo/neosnippet',
              \ {
              \   'autoload' : {
              \     'insert' : 1,
              \   }
              \ }
NeoBundleLazy 'Shougo/neosnippet-snippets',
              \ {
              \   'autoload' : {
              \     'insert' : 1,
              \   }
              \ }
NeoBundle 'Shougo/tabpagebuffer.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc',
          \ { 'build' : {
          \     'windows' : 'tools\\update-dll-mingw',
          \     'unix'    : 'make -f make_unix.mak',
          \   }
          \ }
NeoBundle 'Shougo/vimshell'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'sgur/unite-qf'
NeoBundle 'syngan/vim-vimlint'
NeoBundleLazy 'thinca/vim-fontzoom',
              \ {
              \   'gui' : 1,
              \   'autoload' : {
              \     'mappings' : [
              \       ['n', '<Plug>(fontzoom-larger)'],
              \       ['n', '<Plug>(fontzoom-smaller)'],
              \     ]
              \   }
              \ }
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-quickrun'
NeoBundleLazy 'thinca/vim-ref',
              \ {
              \   'autoload' : {
              \     'commands' : 'Ref',
              \   }
              \ }
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/caw.vim'
NeoBundleLazy 'tyru/open-browser.vim',
              \ {
              \   'autoload' : {
              \      'mappings' : '<Plug>(openbrowser-smart-search)',
              \   }
              \ }
NeoBundle 'tyru/restart.vim'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundleLazy 'vim-jp/cpp-vim',
              \ { 'autoload' : {
              \     'filetypes' : ['c', 'cpp'],
              \   }
              \ }
NeoBundleLazy 'vim-scripts/DirDiff.vim',
              \ {
              \   'autoload' : {
              \     'commands' : 'DirDiff',
              \   }
              \ }
NeoBundleLazy 'vim-scripts/DoxygenToolkit.vim',
              \ {
              \   'autoload' : {
              \     'commands' : 'Dox',
              \   }
              \ }
NeoBundleLazy 'vim-scripts/taglist.vim',
              \ {
              \   'autoload' : {
              \     'commands' : 'TlistToggle',
              \   }
              \ }
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'ynkdir/vim-vimlparser'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'zhaocai/unite-scriptnames'

call neobundle#end()

filetype plugin indent on

" インストールチェック
NeoBundleCheck

" }}}

" 文字コード {{{ ===============================================================

set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

set fileformat=unix
set fileformats=unix,dos,mac

" }}}

" 基本設定 {{{ =================================================================

" エラー時の音とビジュアルベルの抑制
set noerrorbells
set visualbell t_vb=
autocmd MyAutoCmd GUIEnter * set visualbell t_vb=

" バックアップ、スワップファイル
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
" viminfoの出力先
set viminfo& viminfo+=n$MY_VIM_TMPDIR/.viminfo
" undofile無効
set noundofile
" ビジュアルモードで選択したテキストが自動でクリッポボードに入る
set clipboard& clipboard+=autoselect
" 8進数を無効にする
set nrformats-=octal
" 編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set hidden
" ヒストリの保存数
set history=100
" 日本語の行の連結時には空白を入力しない、コメントリーダーを削除する
set formatoptions& formatoptions+=mMj
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
set wildmode=list:longest,full
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
" helpの検索順序
set helplang=ja,en
" スペルチェック
set nospell
set spelllang& spelllang+=cjk

" }}}

" 検索 {{{ =====================================================================

" 検索の時に大文字小文字を区別しない
" ただし大文字小文字の両方が含まれている場合は大文字小文字を区別する
set ignorecase
set smartcase
" 検索時にファイルの最後まで行ったら、そこで検索をやめる
set nowrapscan
" インクリメンタルサーチ
set incsearch
" Migemo
if has('migemo')
  set migemo
  nnoremap / g/
  nnoremap ? g?
endif
" 検索文字の強調表示
set hlsearch
" w,bの移動で認識する文字
"set iskeyword=a-z,A-Z,48-57,_,.,-,>
"vimgrep をデフォルトのgrepとする場合internal
set grepprg=internal
"set grepprg=grep\ -nH
" vimgrepでの検索後、QuickFixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost vimgrep cw
" 検索で飛んだらそこを真ん中に
for s:maptype in ['n', 'N', '*', '#', 'g*', 'g#', 'G']
  execute 'nmap' s:maptype s:maptype . 'zz'
endfor
unlet s:maptype
" コマンドラインモードでの検索で自動エスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" }}}

" 表示設定 {{{ =================================================================

if !has('gui_running')
  " 256色モード
  set t_Co=256
  " モードにあわせてカーソル形状変更
  if exists('$TMUX')
    let &t_ti = "\ePtmux;\e\e[2 q\e\\"
    let &t_SI = "\ePtmux;\e\e[6 q\e\\"
    let &t_EI = "\ePtmux;\e\e[2 q\e\\"
    let &t_te = "\ePtmux;\e\e[6 q\e\\"
  elseif &term == 'xterm'
    let &t_ti = "\e[2 q"
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    let &t_te = "\e[6 q"
  endif
endif
" スプラッシュ(起動時のメッセージ)を表示しない
"set shortmess& shortmess+=I
" マクロ実行中などの画面再描画を行わない
"set lazyredraw
" 行番号表示
set number
" 括弧の対応表示時間
"set showmatch
set matchtime=0
" タブ設定
set ts=2 sw=2 sts=2 ex
" インデント
set autoindent
set smartindent
" Cインデント
set cindent
set cinoptions& cinoptions+=:0,g0,j1
" Vimスクリプトでバックスラッシュ挿入でインデント抑止
let g:vim_indent_cont = 0
" タイトルを表示
set title
set titlestring=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ \ %{getcwd()}
set titlelen=200
" タブページを常に表示
set showtabline=2
" タブのラベル表示設定
set guitablabel=%N:%t
" コマンドラインの高さ
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
set listchars=tab:^\ ,trail:~,extends:>,precedes:<,nbsp:%
" スクロール時に表示を5行確保
set scrolloff=10
" カーソルが常に中央行
" set scrolloff=999
" 行間
set linespace=2
" フォールディング
set foldmethod=marker
set foldlevel=100
" diff
set diffopt=filler,vertical
" 補完選択時にScratchウィンドウを開かないようにする
set completeopt=menuone,preview
" 他のバッファから補完をしない
set complete=.
" conceal
if has('conceal')
  set conceallevel=1
  set concealcursor=
endif
" 改行でコメント自動挿入抑止
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=ro
" 自動折り返しを無効化
autocmd MyAutoCmd FileType * setlocal textwidth=0
" 編集行を強調
autocmd MyAutoCmd InsertLeave * setlocal nocursorline
autocmd MyAutoCmd InsertEnter * setlocal cursorline

" ファイルタイプ毎のインデント
autocmd MyAutoCmd FileType c          setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType cs         setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType css        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType diff       setlocal sw=4 sts=4 ts=4 noet
autocmd MyAutoCmd FileType go         setlocal sw=4 sts=4 ts=4 noet
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
autocmd MyAutoCmd FileType zsh        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType scala      setlocal sw=2 sts=2 ts=2 et

if has('gui_running')
  " GUIオプション
  set guioptions&
  set guioptions-=T
  set guioptions-=m
  " ビジュアル選択を自動的にクリップボードへ
  set guioptions+=a
  " カーソルを点滅させない
  set guicursor=a:blinkon0

  " フォント
  if s:iswin
    let &guifont = "Ricty Discord for Powerline:h13.5:cSHIFTJIS, Ricty_Discord:h13.5:cSHIFTJIS, MeiryoKe_Gothic:h12:cSHIFTJIS"
    let &guifontwide = &guifont
    set renderoptions=type:directx

    " 最大化
    autocmd MyAutoCmd GUIEnter * simalt ~x
  else
    let &guifont = "Ricty\ Discord\ for\ Powerline 12, Ricty\ Discord 12, Monospace 10, VLゴシック 11"
    let &guifontwide = &guifont

    " 最大化
    set lines=999 columns=999
  endif

  " 半透明化
  " gui
  " set transparency=240
endif

" ハイライトを有効
syntax on

" カラースキーム
"colorscheme torte
"colorscheme desert256
"colorscheme jellybeans
"colorscheme hybrid
colorscheme landscape

" ボップアップのハイライト
function! s:SetPmenuHighlight()
  highlight Pmenu ctermfg=245 ctermbg=235 guifg=#8a8a8a guibg=#262626
  highlight PmenuSel ctermfg=15 ctermbg=27 guifg=#ffffff guibg=#005fff
  highlight PmenuSbar ctermbg=235 guibg=#262626
  highlight PmenuThumb ctermbg=240 guibg=#585858
endfunction
if has('syntax')
  autocmd MyAutoCmd ColorScheme * call s:SetPmenuHighlight()
  call s:SetPmenuHighlight()
endif

" IMEの状態をカラー表示
if has('multi_byte_ime') || has('xim')
  highlight Cursor guifg=NONE guibg=White
  highlight CursorIM guifg=NONE guibg=DarkRed
endif

" Javaのハイライト
" 全てのクラスをハイライトする
let g:java_highlight_all = 1
" メソッド宣言文をハイライト
let g:java_highlight_functions = 1
" デバッグ分(print系)をハイライト
let g:java_highlight_debug = 1
" 余分な空白に対してハイライト
let g:java_space_errors = 1

" doxygenのハイライト
let g:load_doxygen_syntax = 1

" ステータスラインに文字コード等表示 {{{
" if has('iconv')
"   set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=[0x%{s:FencB()}]\ (%v,%l)/%L%8P\
" else
"   set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\
" endif

" FencB() : カーソル上の文字コードをエンコードに応じた表示にする
" function! s:FencB()
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
" }}}

" UTF8、SJIS(CP932)、EUCJPで開き直す {{{
command! -bang -nargs=? Utf8
\ edit<bang> ++enc=utf-8 <args>
command! -bang -nargs=? Sjis
\ edit<bang> ++enc=cp932 <args>
command! -bang -nargs=? Euc
\ edit<bang> ++enc=eucjp <args>
" }}}

" }}}

" キーマッピング {{{ ===========================================================

" タイムアウト
set timeout
set timeoutlen=1000
set ttimeoutlen=100

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
noremap <silent> <Space>s :<C-u>sp<CR>
noremap <silent> <Space>v :<C-u>vs<CR>
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
nnoremap <silent> <Space>wc <C-w>c
nnoremap <silent> <Space>w> <C-w>>
nnoremap <silent> <Space>w< <C-w><
nnoremap <silent> <Space>w+ <C-w>+
nnoremap <silent> <Space>w- <C-w>-
" タブ
nnoremap <silent> <Space>tn :<C-u>tabnew<CR>
nnoremap <silent> <Space>tc :<C-u>tabclose<CR>

" 折りたたみの開閉
if has('folding')
  nnoremap <expr>h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : '<Left>'
  nnoremap <expr>l foldclosed(line('.')) != -1 ? 'zo' : '<Right>'
endif
" 折りたたみオープン、クローズ
nnoremap <silent> <space>fc :<C-u>%foldclose<CR>
nnoremap <silent> <space>fo :<C-u>%foldopen<CR>

" ESCキー連打でハイライトを消す
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" カーソル位置の単語をヤンク文字列に置換
nnoremap <silent> cy ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
" ビジュアルモードで選択した部分をヤンク文字列で置換
vnoremap <silent> cy c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

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
" fコマンドなどでのIMEをOFFにする
let g:IMState = 0
autocmd MyAutoCmd InsertEnter * let &iminsert = g:IMState
autocmd MyAutoCmd InsertLeave * let g:IMState = &iminsert|set iminsert=0 imsearch=0

" インデント変更後も選択を継続する
vnoremap < <gv
vnoremap > >gv

" 選択部分をクリップボードにコピー
"vnoremap <C-C> "*y
" 挿入モード時、クリップボードから貼り付け
"inoremap <C-V> <ESC>"*pa
" 選択部分をクリップボードの値に置き換え
"vnoremap <C-V> d"*P
" コマンドライン時、クリップボードから貼り付け
cnoremap <C-V> <C-R>*
" 選択部分をクリップボードに切り取り
"vnoremap <C-X> "*d<ESC>

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

" VisualModeでの加算/減算
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" }}}

" Vimスクリプト {{{ ============================================================

" 最後に編集した場所にカーソルを移動する {{{
autocmd MyAutoCmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line('$') |
\   execute "normal! g`\"" |
\ endif
" }}}

" 挿入モード時、ステータスラインのカラー変更 {{{
" let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
"
" if has('syntax')
"   autocmd MyAutoCmd InsertEnter * call s:StatusLine('Enter')
"   autocmd MyAutoCmd InsertLeave * call s:StatusLine('Leave')
" endif
" if has('unix') && !has('gui_running')
"   " ESCですぐに反映されない対策
"   inoremap <silent> <ESC> <ESC>
" endif
"
" let s:slhlcmd = ''
" function! s:StatusLine(mode)
"   if a:mode == 'Enter'
"     silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
"     silent execute g:hi_insert
"   else
"     highlight clear StatusLine
"     silent execute s:slhlcmd
"     redraw
"   endif
" endfunction
"
" }}}

" 全角スペース、行末スペースを強調表示 {{{
function! s:GetHighlight(hi)
  redir => hl
  execute 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

function! s:HighlightSpace()
  if &filetype ==# 'unite'
    return
  endif
  silent! let hi = s:GetHighlight('HighlightSpace')
  if hi =~ 'E411' || hi =~ 'cleared$'
    highlight HighlightSpace cterm=underline ctermfg=red gui=underline guifg=red
  endif
endfunction

if has('syntax')
  autocmd MyAutoCmd ColorScheme       * call  s:HighlightSpace()
  autocmd MyAutoCmd VimEnter,WinEnter * match HighlightSpace /　\|\s\+$/
  call s:HighlightSpace()
endif
" }}}

" カレントディレクトリをファイルと同じディレクトリに移動する {{{
"if exists('+autochdir')
"  " autochdirがある場合カレントディレクトリを移動
"  set autochdir
"else
"  " autochdirが存在しないが、カレントディレクトリを移動したい場合
"  autocmd MyAutoCmd BufEnter * execute ":silent! lcd " . escape(expand("%:p:h"), ' ')
"endif
" }}}

" セッションを自動保存・復元する {{{
" セッション保存ファイルのフルパス
"let s:last_session = $MY_VIM_TMPDIR . '/.vim_last_session'
" VIM終了時にセッション保存ファイルに上書き保存
"autocmd MyAutoCmd VimLeave * execute "mks! " . s:last_session
" 起動時にセッションファイルがあるかどうかチェック
"if argc() == 0 && filereadable(s:last_session)
  " あった場合読み込む
"  autocmd MyAutoCmd VimEnter * execute "so " . s:last_session
"endif
"unlet s:last_session
" }}}

" matchitスクリプトを読み込む
"source $MY_VIMRUNTIME/macros/matchit.vim

" Quickfixウィンドウの開閉をトグル {{{
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
  endif
endfunction
nnoremap <silent> <Space>qt :<C-u>call <SID>toggle_quickfix_window()<CR>
" }}}

" clipboardにunnamedを追加 {{{
function! s:toggle_clipboard_unnamed()
  if &clipboard =~# 'unnamed'
    set clipboard-=unnamed
    echo 'clipboard mode OFF'
  else
    set clipboard^=unnamed
    echo 'clipboard mode ON'
  endif
endfunction
command! ToggleClipboardUnnamed call s:toggle_clipboard_unnamed()
nnoremap <silent> <Space>P :<C-u>call <SID>toggle_clipboard_unnamed()<CR>
" }}}

" 末尾空白削除 {{{
function! s:trim_last_white_space() range
  execute a:firstline . ',' . a:lastline . 's/\s\+$//e'
endfunction
command! -range=% Trim :<line1>,<line2>call <SID>trim_last_white_space()
nnoremap <silent> <Space>tr :<C-u>%Trim<CR>
vnoremap <silent> <Space>tr :<C-u>Trim<CR>
" }}}

" 縦に連番を入力する {{{
nnoremap <silent> <Space>co :ContinuousNumber <C-a><CR>
vnoremap <silent> <Space>co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber
\ let c = col('.') |
\ for n in range(1, <count>?<count>-line('.'):1) |
\   execute 'normal! j' . n . <q-args> |
\   call cursor('.', c) |
\ endfor
" }}}

" スワップファイルの削除 {{{
function! s:remove_swapfile()
  let target = &directory
  let list = split(glob(target."**/*.*.sw{p,o}"), '\n')
  echo "remove"
  for file in list
    echo file
    call delete(file)
  endfor
endfunction
command! RemoveSwapFile :<C-u>call <SID>remove_swapfile()
" }}}

" http://vim-users.jp/2010/03/hack130/ {{{
command! -complete=file -nargs=+ VimGrep  call s:grep([<f-args>])
function! s:grep(args)
  execute 'vimgrep' '/'.a:args[-1].'/' join(a:args[:-2]) | :Unite qf
endfunction
" }}}

" }}}

" プラグイン設定 {{{ ===========================================================

" unite prefix key.
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap <Leader>u [unite]
xmap <Leader>u [unite]

" alpaca_tags {{{
if neobundle#is_installed('alpaca_tags')
  let g:alpaca_tags#config = {
  \       '_' : '-R --sort=yes',
  \       'c' : '--languages=+c,c++',
  \       'cpp' : '--languages=+c,c++',
  \       'cs' : '--languages=+c#',
  \       'java' : '--languages=+java',
  \       'js' : '--languages=+JavaScript',
  \       'perl' : '--languages=+Perl',
  \       'php' : '--languages=+PHP',
  \       'python' : '--languages=+Python',
  \       'ruby' : '--languages=+Ruby',
  \       'sh' : '--languages=+Sh',
  \       'vim' : '--languages=+Vim',
  \ }
  let g:alpaca_tags#cache_dir = $MY_VIM_TMPDIR . '/.alpaca_tags'
  autocmd MyAutoCmd BufEnter * AlpacaTagsSet
  " autocmd MyAutoCmd BufWritePost * AlpacaTagsUpdate
  nnoremap <Leader>tu :<C-u>AlpacaTagsUpdate<CR>
endif
" }}}

" vim-autoformat {{{
if neobundle#is_installed('vim-autoformat')
  " 保存時に自動フォーマット
  autocmd MyAutoCmd FileType javascript autocmd MyAutoCmd BufWritePre <buffer> Autoformat
endif
" }}}

" vim-go {{{
if neobundle#is_installed('vim-go')
  " ハイライトを有効
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  " gofmtの代わりにgoimportsを使用
  let g:go_fmt_command = "goimports"
endif
" }}}

" memolist.vim {{{
if neobundle#is_installed('memolist.vim')
  let g:memolist_path = $MY_VIM_TMPDIR . '/.memolist'
  let g:memolist_prompt_tags = 1
  let g:memolist_prompt_categories = 1
  let g:memolist_vimfiler = 0
  let g:memolist_unite = 1
  let g:memolist_unite_option = "-auto-preview -start-insert"
  map <Leader>mn :<C-u>MemoNew<CR>
  map <Leader>ml :<C-u>MemoList<CR>
  map <Leader>mg :<C-u>MemoGrep<CR>
  nnoremap <silent> <Leader>mug :<C-u>Unite -buffer-name=search grep:<C-r>=substitute(g:memolist_path, ":", "\\\\:", "g")<CR><CR>
endif
" }}}

" landscape.vim {{{
if neobundle#is_installed('landscape.vim')
  let g:landscape_highlight_url = 1
  let g:landscape_highlight_todo = 1
  let g:landscape_syntax_vimfiler = 1
  let g:landscape_syntax_vimshell = 1
  let g:landscape_syntax_unite = 1
  let g:landscape_syntax_quickrun = 1

  " SpecialKey(Tabなど)の色を少し抑える
  autocmd MyAutoCmd ColorScheme landscape highlight SpecialKey guifg=#373b41
  if g:colors_name == 'landscape'
    highlight SpecialKey guifg=#373b41
  endif
endif
" }}}

" lightline.vim {{{
if neobundle#is_installed('lightline.vim')
  if !exists('g:lightline_patched_font_enable')
    " パッチフォント文字有効化
    let g:lightline_patched_font_enable = 1
  endif

  let g:lightline = {
        \ 'colorscheme': 'landscape',
        \ 'mode_map': { 'c': 'NORMAL' },
        \ 'active': {
        \   'left' : [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'reanimate' ] ],
        \   'right': [ ['syntaxcheck'], ['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype'] ]
        \ },
        \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
        \ 'component_expand': { 'syntaxcheck': 'qfstatusline#Update' },
        \ 'component_type': { 'syntaxcheck': 'error', },
        \ }

  let s:lightline_component_function = {
        \ 'modified': 'MyModified',
        \ 'readonly': 'MyReadonly',
        \ 'fugitive': 'MyFugitive',
        \ 'filename': 'MyFilename',
        \ 'fileformat': 'MyFileformat',
        \ 'filetype': 'MyFiletype',
        \ 'fileencoding': 'MyFileencoding',
        \ 'mode': 'MyMode',
        \ 'reanimate': 'MyReanimate',
        \ }
  let g:lightline.component_function = s:lightline_component_function

  function! MyModified()
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! MyReadonly()
    if g:lightline_patched_font_enable == 1
      return &ft !~? 'help\|vimfiler' && &readonly ? "\u2b64" : ''
    else
      return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
    endif
  endfunction

  function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
          \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
          \  &ft == 'unite' ? unite#get_status_string() :
          \  &ft == 'vimshell' ? vimshell#get_status_string() :
          \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ('' != MyModified() ? ' ' . MyModified() : '')
  endfunction

  function! MyFugitive()
    if &ft !~? 'vimfiler' && exists("*fugitive#head")
      if g:lightline_patched_font_enable == 1
        let _ = fugitive#head()
        return strlen(_) ? "\u2b60 "._ : ''
      else
        return fugitive#head()
      endif
    endif
    return ''
  endfunction

  function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  endfunction

  function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction

  function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  function! MyReanimate()
    return reanimate#is_saved() ? reanimate#last_point() : "no save"
  endfunction

  " パッチフォント文字有効化トグル
  function! s:lightline_patched_font_toggle()
    if g:lightline_patched_font_enable == 1
      let g:lightline.separator = { 'left': '', 'right': '' }
      let g:lightline.subseparator = { 'left': '|', 'right': '|' }
    else
      let g:lightline.separator = { 'left': "\u2b80", 'right': "\u2b82" }
      let g:lightline.subseparator = { 'left': "\u2b81", 'right': "\u2b83" }
    endif
    let g:lightline.component_function = s:lightline_component_function
    call lightline#init()
    call lightline#update()
    let g:lightline_patched_font_enable = !g:lightline_patched_font_enable
  endfunction
  command! ToggleLightLinePatchedFont call s:lightline_patched_font_toggle()
endif
" }}}

" vim-smartchr {{{
if neobundle#is_installed('vim-smartchr')
  function! EnableSmartchrBasic()
    inoremap <buffer><expr> + smartchr#one_of(' + ', '+', '++')
    inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
    inoremap <buffer><expr> , smartchr#one_of(', ', ',')
    inoremap <buffer><expr> <Bar> smartchr#one_of('<Bar>', ' <Bar><Bar> ', '<Bar>')
    inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
    \ : search('\(\*\<bar>!\)\%#')? '= '
    \ : smartchr#one_of(' = ', '=', ' == ')
  endfunction

  function! EnableSmartchrRegExp()
    inoremap <buffer><expr> ~ search('\(!\<bar>=\) \%#', 'bcn')? '<bs>~ ' : '~'
  endfunction

  autocmd MyAutoCmd FileType c,cpp,php,python,java,javascript,ruby,vim call EnableSmartchrBasic()
  autocmd MyAutoCmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
  autocmd MyAutoCmd FileType python,ruby,vim call EnableSmartchrRegExp()
  autocmd MyAutoCmd FileType ruby inoremap <buffer> <expr> > smartchr#one_of('>', ' => ')
endif
" }}}

" vim-easy-align {{{
if neobundle#is_installed('vim-easy-align')
  " Start interactive EasyAlign in visual mode
  vmap <Enter> <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object
  nmap <Leader>ea <Plug>(EasyAlign)
endif
" }}}

" vim-submode {{{
if neobundle#is_installed('vim-submode')
  call submode#enter_with('winsize', 'n', '', '<Space>w>', '<C-w>>')
  call submode#enter_with('winsize', 'n', '', '<Space>w<', '<C-w><')
  call submode#enter_with('winsize', 'n', '', '<Space>w+', '<C-w>+')
  call submode#enter_with('winsize', 'n', '', '<Space>w-', '<C-w>-')
  call submode#map('winsize', 'n', '', '>', '<C-w>>')
  call submode#map('winsize', 'n', '', '<', '<C-w><')
  call submode#map('winsize', 'n', '', '+', '<C-w>+')
  call submode#map('winsize', 'n', '', '-', '<C-w>-')

  call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
  call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
  call submode#map('changetab', 'n', '', 't', 'gt')
  call submode#map('changetab', 'n', '', 'T', 'gT')

  call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
  call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
  call submode#map('undo/redo', 'n', '', '-', 'g-')
  call submode#map('undo/redo', 'n', '', '+', 'g+')

  function! s:modulo(n, m)
    let d = a:n * a:m < 0 ? 1 : 0
    return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
  endfunction
  function! s:movetab(nr)
    execute 'tabmove' s:modulo(tabpagenr() + a:nr - 1, tabpagenr('$'))
  endfunction
  let s:movetab = ':<C-u>call ' . s:SIDP() . 'movetab(%d)<CR>'
  call submode#enter_with('movetab', 'n', '', '<Space>gt', printf(s:movetab, 1))
  call submode#enter_with('movetab', 'n', '', '<Space>gT', printf(s:movetab, -1))
  call submode#map('movetab', 'n', '', 't', printf(s:movetab, 1))
  call submode#map('movetab', 'n', '', 'T', printf(s:movetab, -1))
  unlet s:movetab
endif
" }}}

" vim-qfstatusline {{{
if neobundle#is_installed('vim-qfstatusline') && neobundle#is_installed('lightline.vim')
  let g:Qfstatusline#UpdateCmd = function('lightline#update')
endif
" }}}

" emmet-vim {{{
if neobundle#is_installed('emmet-vim')
  let g:user_emmet_leader_key = '<C-y>'
  let g:user_emmet_settings = {
  \     'variables' : {
  \       'lang' : 'ja',
  \     }
  \ }
endif
" }}}

" jellybeans.vim {{{
if neobundle#is_installed('jellybeans.vim')
  " jellybeansのコメントのitalicを解除
  let g:jellybeans_overrides = {
  \ 'Comment' : { 'gui' : 'NONE' }
  \ }
endif
" }}}

" vim-reanimate {{{
if neobundle#is_installed('vim-reanimate')
  " 保存先のディレクトリ
  let g:reanimate_save_dir = $MY_VIM_TMPDIR . '/.reanimate'

  " デフォルトの保存名
  let g:reanimate_default_save_name = "latest"

  " デフォルトのカテゴリ名
  let g:reanimate_default_category = "category"

  " sessionoptions
  let g:reanimate_sessionoptions = &sessionoptions

  " 無効イベント
  let g:reanimate_event_disables = {
  \       "_" : {
  \         "reanimate_confirm" : 1,
  \       }
  \ }

  " 終了時に自動保存
  autocmd MyAutoCmd VimLeavePre * ReanimateSave
  " 開始時に自動復元
  "autocmd MyAutoCmd VimEnter * ReanimateLoad

  " unite-reanimate
  " 保存
  nnoremap <silent> [unite]ss :<C-u>Unite reanimate -default-action=reanimate_save<CR>
  " 復元
  nnoremap <silent> [unite]sl :<C-u>Unite reanimate -default-action=reanimate_load<CR>
endif
" }}}

" neobundle.vim {{{

" プラグインのアップデート
nnoremap <silent> <Leader>bu :<C-u>NeoBundleUpdate<CR>
" プラグインのアップデートログ
nnoremap <silent> <Leader>bl :<C-u>NeoBundleUpdatesLog<CR>
" プラグインのアップデート
nnoremap <silent> [unite]bu :<C-u>Unite neobundle/update -auto-quit<CR>
" プラグインのインストール／アップデートログ
nnoremap <silent> [unite]bl :<C-u>Unite neobundle/log<CR>

" }}}

" neocomplete.vim {{{
if neobundle#is_installed('neocomplete.vim')
  " 自動有効
  let g:neocomplete#enable_at_startup = 1
  " 一時ディレクトリ
  let g:neocomplete#data_directory = $MY_VIM_TMPDIR . '/.neocomplete'
  " デリミタ自動補完
  let g:neocomplete#enable_auto_delimiter = 1
  " 区切り補完を有効
  let g:neocomplete#enable_auto_delimiter = 1
  " previewウィンドウを自動で閉じる
  let g:neocomplete#enable_auto_close_preview = 1
  " キーワードパターン定義
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'
  " オムニ補完
  autocmd MyAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd MyAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd MyAutoCmd FileType javascript setlocal omnifunc=tern#Complete
  autocmd MyAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd MyAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd MyAutoCmd FileType go setlocal omnifunc=gocomplete#Complete
  if filereadable($MY_VIMRUNTIME . '/plugin/eclim.vim')
    autocmd MyAutoCmd FileType java setlocal omnifunc=eclim#java#complete#CodeComplete
  endif
  " 辞書ファイルの定義
  let g:neocomplete#sources#dictionary#dictionaries = {
  \ 'default' : '',
  \ 'vimshell' : $MY_VIM_TMPDIR.'/.vimshell/command-history'
  \ }

  " キーマッピング
  " 手動でオムニ補完
  inoremap <expr><C-Space>  pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<C-Space>" :
  \ neocomplete#start_manual_complete()
  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction
  " 1つ前の補完を取り消す
  inoremap <expr><C-g>  neocomplete#undo_completion()
  " 補完ポップアップを閉じる
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "\<CR>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
endif
" }}}

" neosnippet {{{
if neobundle#is_installed('neosnippet')
  " ユーザー定義スニペット保存ディレクトリ
  let g:neosnippet#snippets_directory = $MY_VIMRUNTIME . '/snippets'
  " キーマッピング
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)
  xmap <C-l>     <Plug>(neosnippet_start_unite_snippet_target)
  " <Tab> でスニペット補完
  imap <expr><TAB> neosnippet#expandable() ?
  \ "\<Plug>(neosnippet_jump_or_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
  " スニペットで単語が選択されている場合でも <Tab> で次のプレースホルダへ移動する
  vmap <expr><TAB> neosnippet#expandable() ?
  \ "\<Plug>(neosnippet_jump_or_expand)" : "\<Tab>"
endif
" }}}

" unite.vim {{{
if neobundle#is_installed('unite.vim')
  " unite general settings
  " インサートモードで開始
  let g:unite_enable_start_insert = 1
  " unite, sourceが内部で保存するディレクトリ
  let g:unite_data_directory = $MY_VIM_TMPDIR . '/.unite'
  " 最近開いたファイル履歴の保存数
  let g:unite_source_file_mru_limit = 50
  " file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
  let g:unite_source_file_mru_filename_format = ''
  " uniteのステータスラインを無効
  let g:unite_force_overwrite_statusline = 0
  " デフォルトオプション設定
  call unite#custom#profile('default', 'context', {
  \       'prompt' : '> ',
  \       'ignorecase' : &ignorecase,
  \       'smartcase'  : &smartcase })

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
  nnoremap <silent> [unite]bl :<C-u>Unite -buffer-name=bookmark bookmark<CR>
  " ブックマークに追加
  nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd<CR>
  " grep
  nnoremap <silent> [unite]gr :<C-u>Unite -buffer-name=search -no-quit grep<CR>

  " uniteを開いている間のキーマッピング
  autocmd MyAutoCmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    " unite終了
    nmap <buffer> <C-j> <Plug>(unite_exit)
    imap <buffer> <C-j> <Plug>(unite_exit)
    " vimfiler
    nmap <silent><buffer><expr> f unite#do_action('vimfiler')
  endfunction
endif
" }}}

" unite-outline {{{
if neobundle#is_installed('unite-outline')
  nnoremap <silent> [unite]oi  :<C-u>Unite outline -start-insert<CR>
  nnoremap <silent> [unite]ov  :<C-u>Unite -no-quit -vertical -winwidth=50 outline<CR>

  " この設定をしないとエラーになる
  let g:unite_abbr_highlight = 'normal'

  let g:unite_source_outline_filetype_options = {
  \        '*': {
  \          'auto_update': 1,
  \          'auto_update_event': 'write',
  \        },
  \ }
endif
" }}}

" vimfiler {{{
if neobundle#is_installed('vimfiler')
  " vimfiler prefix key.
  nnoremap [vimfiler] <Nop>
  nmap <Leader>ff [vimfiler]

  " vimfilerをデフォルトのファイラにする
  let g:vimfiler_as_default_explorer = 1
  " vimfiler, sourceが内部で保存するディレクトリ
  let g:vimfiler_data_directory = $MY_VIM_TMPDIR . '/.vimfiler'
  " セーフモード設定
  let g:vimfiler_safe_mode_by_default = 0
  " 自動cdのON/OFF
  let g:vimfiler_enable_auto_cd = 0
  " vimfilerのステータスラインを無効
  let g:vimfiler_force_overwrite_statusline = 0
  if s:iswin
    " Use trashbox.
    let g:unite_kind_file_use_trashbox = 1
  endif
  " ドットファイルをデフォルト表示
  let g:vimfiler_ignore_pattern = "\%(^\..*\)"
  " キーマッピング
  nnoremap <silent> [vimfiler]e :<C-u>VimFilerExplorer<CR>

  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
  function! s:vimfiler_my_settings()
    nnoremap <silent><buffer><expr> <C-t> vimfiler#do_action('tabopen')
  endfunction
endif
" }}}

" vimshell {{{
if neobundle#is_installed('vimshell')
  " vimshell prefix key.
  nnoremap [vimshell] <Nop>
  nmap <Leader>s [vimsh]

  " 一時ディレクトリ
  let g:vimshell_temporary_directory = $MY_VIM_TMPDIR . '/.vimshell'
  " ユーザ用プロンプト
  let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
	let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
  let g:vimshell_force_overwrite_statusline = 0
  " キーマッピング
  nnoremap <silent> [vimsh]h :<C-u>VimShell<CR>
  nnoremap <silent> [vimsh]c :<C-u>VimShellCreate<CR>
  nnoremap <silent> [vimsh]t :<C-u>VimShellTab<CR>
  nnoremap <silent> [vimsh]p :<C-u>VimShellPop<CR>
endif
" }}}

" vim-quickrun, vim-watchdogs {{{
if neobundle#is_installed('vim-quickrun') && neobundle#is_installed('vim-watchdogs')
  " g:quickrun_config の初期化
  if !exists("g:quickrun_config")
    let g:quickrun_config={}
  endif

  " QuickRun設定
  let g:quickrun_config = {
  \       "_" : {
  \         "runner/vimproc/updatetime" : 80,
  \         "outputter/buffer/split" : ":rightbelow 8sp",
  \         "outputter/error/error" : "quickfix",
  \         "outputter/error/success" : "buffer",
  \         "outputter" : "error",
  \         "runner" : "vimproc",
  \       },
  \
  \       "watchdogs_checker/_" : {
  \         "outputter/quickfix/open_cmd" : "",
  \         "hook/qfstatusline_update/enable_exit" : 1,
  \         "hook/qfstatusline_update/priority_exit" : 4,
  \         "runner/vimproc/updatetime" : 40,
  \       },
  \
  \       "javascript/watchdogs_checker" : {
  \         "type" : "eslint"
  \       },
  \
  \ }
  call watchdogs#setup(g:quickrun_config)

  " ファイル保存時のシンタックスチェックを有効にする
  let g:watchdogs_check_BufWritePost_enable = 1
endif
" }}}

" vim-ref {{{
if neobundle#is_installed('vim-ref')
  let g:ref_cache_dir = $MY_VIM_TMPDIR . '/.ref_cache_dir'
  let g:ref_use_vimproc = 1
endif
" }}}

" vim-visualstar {{{
if neobundle#is_installed('vim-visualstar')
  " 検索後に移動しない
  map * <Plug>(visualstar-*)N
  map # <Plug>(visualstar-#)N
endif
" }}}

" vim-fugitive {{{
if neobundle#is_installed('vim-fugitive')
  nnoremap <Leader>gd :<C-u>Gdiff<CR>
  nnoremap <Leader>gs :<C-u>Gstatus<CR>
  nnoremap <Leader>gl :<C-u>Glog<CR>
  nnoremap <Leader>ga :<C-u>Gwrite<CR>
  nnoremap <Leader>gc :<C-u>Gcommit -v<CR>
  nnoremap <Leader>gC :<C-u>Git commit --amend<CR>
  nnoremap <Leader>gb :<C-u>Gblame<CR>
endif
" }}}

" caw.vim {{{
if neobundle#is_installed('caw.vim')
  nmap <Leader>c  <Plug>(caw:prefix)
  vmap <Leader>c  <Plug>(caw:prefix)
  nmap <Leader>cc <Plug>(caw:I:toggle)
  vmap <Leader>cc <Plug>(caw:I:toggle)
endif
" }}}

" open-browser.vim {{{
if neobundle#is_installed('open-browser.vim')
  nmap <Leader>bs <Plug>(openbrowser-smart-search)
  vmap <Leader>bs <Plug>(openbrowser-smart-search)
endif
" }}}

" restart.vim {{{
if neobundle#is_installed('restart.vim')
  command!
  \   -bar
  \   RestartWithSession
  \   let g:restart_sessionoptions = &sessionoptions
  \   | Restart
endif
" }}}

" unite-help {{{
if neobundle#is_installed('unite-help')
  nnoremap <silent> [unite]hi :<C-u>Unite -start-insert help<CR>
  nnoremap <silent> [unite]hc :<C-u>UniteWithCursorWord help<CR>
endif
" }}}

" unite-tag {{{
if neobundle#is_installed('unite-tag')
  nnoremap <silent> [unite]tt  :<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag<CR>
  nnoremap <silent> [unite]ti  :<C-u>UniteWithCursorWord -buffer-name=tag tag/include<CR>
endif
" }}}

" unite-colorscheme {{{
if neobundle#is_installed('unite-colorscheme')
  nnoremap <silent> [unite]pc :<C-u>Unite -auto-preview colorscheme<CR>
endif
" }}}

" taglist.vim {{{
if neobundle#is_installed('taglist.vim')
  " 現在編集中のソースのタグしか表示しない
  let g:Tlist_Show_One_File = 1
  nnoremap <Leader>tl :<C-u>TlistToggle<CR>
endif
" }}}

" indentline {{{
if neobundle#is_installed('indentline')
  nmap <silent> <Leader>il :<C-u>IndentLinesToggle<CR>
endif
" }}}

" }}}
