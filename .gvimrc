"----------------------------------------
" 全般設定
"----------------------------------------
scriptencoding utf-8

"エラー時の音とビジュアルベルの抑制。
set noerrorbells
set novisualbell
set visualbell t_vb=

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    "XIMの入力開始キー
    "set imactivatekey=C-space
  endif
endif

"----------------------------------------
" 表示設定
"----------------------------------------
"ツールバー、メニューバーを非表示
set guioptions&
set guioptions-=T
set guioptions-=m
"コマンドラインの高さ
set cmdheight=2
"行間設定
set linespace=4

"カラー設定:
"colorscheme desert
colorscheme desert256
"colorscheme molokai
"colorscheme moria
"colorscheme solarized
"colorscheme torte
"colorscheme xoria256
"colorscheme zenburn

"カーソル行に下線表示
"set cursorline
"highlight CursorLine gui=underline guifg=NONE guibg=NONE

" ボップアップのハイライトを設定
" highlight Pmenu ctermbg=5 guibg=DarkMagenta
" highlight PmenuSel ctermbg=1 guibg=DarkBlue
highlight Pmenu ctermbg=1 guibg=DarkBlue
highlight PmenuSel ctermbg=5 guibg=DarkMagenta
highlight PmenuSbar ctermbg=0 guibg=Black

"IMEの状態をカラー表示
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=Green
  highlight CursorIM guifg=NONE guibg=Purple
endif

"フォント設定
"guifont : 半角フォントの指定
"guifontwide : 全角フォントの指定
"ambiwidth : 特殊文字(句読点や引用符など)の指定
if has('xfontset')
"  set guifontset=a14,r14,k14
elseif has('unix')

elseif has('mac')
"  set guifont=Osaka-Mono:h14
elseif has('win32') || has('win64')
"  set guifont=Inconsolata:h13:cSHIFTJIS
"  set guifontwide=TakaoGothic:h13:cSHIFTJIS
"  set guifont=Envy_Code_R_for_Powerline:h12
"  set guifontwide=TakaoGothic:h12
  set guifont=Ricty\ Regular\ for\ Powerline:h12
  set guifontwide=Ricty\ Regular:h12
  set ambiwidth=double
endif

"印刷用フォント
if has('printer')
  if has('win32') || has('win64')
"    set printfont=MS_Mincho:h12:cSHIFTJIS
"    set printfont=MS_Gothic:h12:cSHIFTJIS
  endif
endif


" Window位置の保存と復帰
let s:infofile = '$MY_VIM_TMPDIR/.vimpos'

function! s:SaveWindowParam(filename)
  redir => pos
  exec 'winpos'
  redir END
  let pos = matchstr(pos, 'X[-0-9 ]\+,\s*Y[-0-9 ]\+$')
  let file = expand(a:filename)
  let str = []
  let cmd = 'winpos '.substitute(pos, '[^-0-9 ]', '', 'g')
  cal add(str, cmd)
  let l = &lines
  let c = &columns
  cal add(str, 'set lines='. l.' columns='. c)
  silent! let ostr = readfile(file)
  if str != ostr
    call writefile(str, file)
  endif
endfunction

augroup SaveWindowParam
  autocmd!
  execute 'autocmd SaveWindowParam VimLeave * call s:SaveWindowParam("'.s:infofile.'")'
augroup END

if filereadable(expand(s:infofile))
  execute 'source '.s:infofile
endif
unlet s:infofile

"----------------------------------------
" マウス設定
"----------------------------------------
" ビジュアル選択を自動的にクリップボードへ
set guioptions+=a

"----------------------------------------
" 背景透過設定
"----------------------------------------
gui
set transparency=230

