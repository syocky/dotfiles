#-----------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------
#
# 補完の利用設定
autoload -Uz compinit; compinit
# カラー記述を簡略化
autoload -Uz colors; colors
# Ctrl+Sによる端末ロック機能を無効
stty stop undef

#-----------------------------------------------------------------
# プロンプト
#-----------------------------------------------------------------
#
# プロンプト変数
# %% = %自身
# %) = )自身
# %l = シェルが利用しているTTY名の先頭から"/dev"または"/dev/tty"（の長いほう）を取り除いた部分
# %y = シェルが利用しているTTY名の先頭から"/dev"を取り除いた部分
# %M = ホスト名すべて
# %m = %Mと同じだがホスト名中に含まれる最初のピリオド以降を削ったもの
# %n = ユーザ名
# %# = 実行中の権限が一般ユーザなら"%"、スーパーユーザなら"#"
# %? = 直前に実行したコマンドの終了コード
# %_ = シェルのパーサが持っている状態名
# %d または %/ = カレントディレクトリのフルパス
# %~ = %dと同様だが、カレントディレクトリのフルパス名の先頭部分がシェル変数か環境変数のどれかの値に一致したときは
#      一致部分が"~ その変数名"に置き換えて表示される
# %h または %! = 現在のイベント番号
# %i = デバッグ用のプロンプト変数PS4で有用。スクリプトファイルをsourceしているときの現在実行中の行番号に置き換えられる
# %N = %iと同様だが、スクリプトファイル名に置き換えられる
# %j = 現在保持しているジョブ数
# %L = 環境変数SHLVLの値
# %D = YY-MM-DD書式での日付
# %T = 24時間表記の時刻
# %* = %Tに秒を加えたもの
# %t または %@ = 12時間表記の時刻
# %w = "曜日名 日付"
# %W = MM/DD/YY書式での日付
# %D{FMT} = strftime関数に与える書式と同じものをFMTに指定して得られる日付文字列
# %E = 行末まで消去する
# %B～%b = %Bで太字を開始して%bで元に戻す
# %U～%u = %Uで下線付き文字列を開始して%uで元に戻す
# %S～%s = %Sで強調文字列を開始して%sで元に戻す
# %{ ... %} = 囲まれた文字列内にエスケープシーケンスがあればそのまま処理する
# %v = $PSVARの先頭要素。数引数でN番目の要素を指定することもできる
# %(A|B|C) = 真偽値を持つAの値によってBまたはCのどちらに置換するかを切り替える
# %<STRING< = 数引数nで指定した文字数よりもプロンプト文字列が長くなった場合に、
#             プロンプト先頭の何文字かを切り捨て、STRINGに置き換えて全体の文字数をnにする
# %>STRING> = %<STRING< と同様だがプロンプトの末尾何文字化をSTRINGに置き換えてn文字に合わせる
#
# プロンプトをスーパーユーザと一般ユーザで色分けする
case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}[%/]#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}[%_]#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  ;;
*)
  PROMPT="%{${fg[green]}%}[%/]$%{${reset_color}%} "
  PROMPT2="%{${fg[green]}%}[%_]$%{${reset_color}%} "
  SPROMPT="%{${fg[green]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  ;;
esac

# 右プロンプトに日時表示
# Vi入力モードに応じて色を変更する
function zle-line-init zle-keymap-select {
  case $KEYMAP in
  vicmd)
    RPROMPT="%B%{${reset_color}%}[%D %T]%b"
  ;;
  main|viins)
    RPROMPT="%B%{${fg[cyan]}%}[%D %T]%{${reset_color}%}%b"
  ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

#-----------------------------------------------------------------
# シェル変数設定
#-----------------------------------------------------------------
#
### ディレクトリ
#
# カレントディレクトリに指定したディレクトリが無い場合に cd が検索するディレクトリのリスト
#cdpath=($HOME)
# ディレクトリスタックに最大で記憶できるディレクトリの個数
DIRSTACKSIZE=32
# cd するときの指定パスに'..'が含まれるとき、それを物理パスの位置から見た親ディレクトリに変換
#setopt chase_dots
# chase_dotsと同様の効果を'..'以外にも適用する
#setopt chase_links
# ディレクトリ名だけで cd する
setopt auto_cd
# ディレクトリ移動時にディレクトリスタックに元いたディレクトリを追加
setopt auto_pushd
# cd で存在しないディレクトリを指定した場合、それがスラッシュで始まらない単語であれば、
# 名前付きディレクトリへの cd を試みる
#setopt cdable_vars
# ディレクトリスタックに同じものを追加しない
setopt pushd_ignore_dups
# ディレクトリスタックの各要素へのアクセス時の + と - の意味を反転する
#setopt pushd_minus
# pushd, popd 時にそのときのディレクトリスタックの内容を非表示
#setopt pushd_silent
# pushd を引数なしで起動したときにホームディレクトリに移動
#setopt pushd_to_home

### ヒストリ
#
# メモリ内に記憶しておくヒストリの最大イベント数
HISTSIZE=4096
# ヒストリの保存先ファイル
HISTFILE=~/.zsh_history
# HISTFILEに保存するヒストリの最大イベント数
SAVEHIST=4096
# ヒストリファイルにヒストリを追加
setopt append_history
# ヒストリファイルに保存する際に、コマンド入力時間と実行時間を合わせて保存する
setopt extended_history
# ファイルへのリダイレクトを行った場合に、ヒストリには自動的に'>|'に置き換える
#setopt hist_allow_clobber
# 存在しないヒストリを取り出そうとしたときにビープ音
#setopt hist_beep
# ヒストリのイベント数がHISTSIZEに達したとき、古いものから削除せず、重複があるものを消去する
# ただし、hist_ignore_all_dupsをセットしている場合は無意味。
# また、SAVEHISTをHISTSIZEより大きくしておかないと、あまり効果的ではない
#setopt hist_expire_dups_first
# ラインエディタでヒストリ検索してヒットした場合、さらに先に重複したものがあっても表示しない
#setopt hist_find_no_dups
# ヒストリに追加するときに、既に同一のコマンドがあればそれを削除する
setopt hist_ignore_all_dups
# 直前のコマンドと同一のコマンドは、ヒストリに追加しない
setopt hist_ignore_dups
# 先頭にスペースを入れたコマンドはヒストリに追加しない
# いったんは保存されるが、次のコマンド入力で消去される
setopt hist_ignore_space
# 関数定義のためのコマンドはヒストリに追加しない
# いったんは保存されるが、次のコマンド入力で消去される
#setopt hist_no_functions
# ヒストリ参照コマンド（history, fc -l）はヒストリに追加しない
setopt hist_no_store
# コマンド中にある余分な空白は削除してヒストリに追加する
setopt hist_reduce_blanks
# ヒストリファイルに保存するときに重複したコマンドは古い方を削除する
setopt hist_save_no_dups
# ヒストリ展開を利用した場合、すぐに実行せずに、マッチしたものをいったん表示する
setopt hist_verify
# 入力したコマンドをすぐにヒストリファイルに追加する
setopt inc_append_history
# 複数端末間でヒストリを共有する
#setopt share_history

### プロンプト
#
# PROMPT変数に対して変数展開、コマンド置換、算術展開を施す
setopt prompt_subst
# プロンプト文字列内の ! を次に保存されるヒストリ番号に置換する
#setopt prompt_bang
# プロンプトで'%'を特殊文字として扱い、'%'記号の展開を行う
#setopt prompt_percent
# プロンプト文字列生成時にCRを出力する
#setopt prompt_cr
# PROMPT_CRがONのときにコマンド出力の最後が見えなくなる場合があるという問題を解決するためのもの
#setopt prompt_sp
# コマンド実行時に右プロンプトを消去する。コマンド入力操作画面を後からコピペするときに便利
#setopt transient_prompt
# 候補一覧は出力した後、新しくプロンプトを出さずに元のプロンプトに留まる
setopt always_last_prompt

### 未整理
#
# カーソル位置を保ち、そこに*を補ったかのようにして、先頭＋末尾両方を見て補完
setopt complete_in_word
# 候補が複数あるときに自動的に一覧を出力
setopt auto_list
# AUTO_LIST同様、自動的に一覧を出力するが、同じ単語に対して2度続けて補完キーを押したときに一覧を出力
#setopt bash_auto_list
# 候補が複数あるときに補完キー錬だで自動的にメニュー補完に移行
setopt auto_menu
# 候補が複数あるときの補完で直ちにメニュー補完に移行
#setopt menu_complete
# 変数名を補完するときに、自動挿入されるスペースや"}"を、
# 次の入力文字が":", "}"など変数名の直後に来るべき文字であるときに自動的に削除する
setopt auto_param_keys
# 変数名補完時に、その値がディレクトリ名なら直後にスラッシュを補う
setopt auto_param_slash
# ディレクトリを補完したときに自動的に付くスラッシュを、その次の入力文字がデリミタであるときに削除する
setopt auto_remove_slash
# 補完時に、コマンドのエイリアスを内部的に置き換えることをしない
setopt complete_aliases
# カーソル位置の単語にグロッピングパターンが含まれる状態で補完したとき、
# その展開結果すべてを挿入せずに、メニュー補完で候補を循環させる
#setopt glob_complete
# コマンド補完時にコマンドハッシュを確認する
#setopt hash_list_all
# AUTO_LISTやBASH_AUTO_LISTで候補一覧を自動的に出す場合に、
# 補完キーを押す前後で単語が全く変わらない場合のみ自動一覧を出力
#setopt list_ambiguous
# BEEPがONのとき、補完結果が1つに確定しないときにビープ音を鳴らす
#setopt list_beep
# 一覧の行数をなるべく少なくする
setopt list_packed
# 候補一覧を横進みにする。デフォルトはlsと同様の縦進み
#setopt list_rows_first
# 候補一覧のファイル名の末尾にファイル種別を表す記号を付ける
setopt list_types
# 現在の単語に完全一致するものがある場合に、別の候補があっても確定する
#setopt rec_exact
# 補完時にスペルチェック
#setopt auto_correct
# スペルミスを補完
#setopt correct
# コマンドライン全てのスペルチェックをする
#setopt correct_all
# n分後に自動的にログアウト
#setopt AUTOLOGOUT=n
# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst
# 補完候補リストの日本語を正しく表示
setopt print_eight_bit
# 右プロンプトに入力がきたら消す
setopt transient_rprompt
# ビープ音を消す
setopt no_beep
# ログアウト時にバックグラウンドジョブをkillしない
setopt no_hup
# ログアウト時にバックグラウンドジョブを確認しない
setopt no_checkjobs
# バックグラウンドジョブが終了したら(プロンプトの表示を待たずにすぐに知らせる
setopt notify
# rm * を実行する前に確認
#setopt rm_star_wait
# rm * を実行する前に確認しない
setopt rm_star_silent
# リダイレクトで上書きを禁止
#setopt no_clobber
# リダイレクトで上書きを許可
unsetopt no_clobber
# C-s/C-qによるフロー制御をOFF
unsetopt flowcontrol

#-----------------------------------------------------------------
# 補完スタイル設定
#-----------------------------------------------------------------
# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# lsコマンドの補完候補にも色付き表示
eval `dircolors`
zstyle ':completion:*:default' list-colors ${LS_COLORS}
# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#-----------------------------------------------------------------
# キーバインド設定
#-----------------------------------------------------------------
# viライクキーバインド
bindkey -v
# Emacsライクキーバインド
#bindkey -e

# コマンド履歴の検索機能の設定
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "OA" history-beginning-search-backward-end
# bindkey "OB" history-beginning-search-forward-end
# bindkey "[A" history-beginning-search-backward-end
# bindkey "[B" history-beginning-search-forward-end
# 複数行コマンドの場合、上記の設定だと少々不都合
# tcshの様にする場合は以下のようにする
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end

# インクリメンタルサーチの設定
bindkey "" history-incremental-search-backward
bindkey "" history-incremental-search-forward

# コマンドラインスタックの設定
bindkey "" push-line-or-edit

#-----------------------------------------------------------------
# エイリアス設定
#-----------------------------------------------------------------
alias ls='ls --color=auto'
alias h='history -E -32'
alias ll='ls -laF --color | more'
alias cp='cp -irf'
alias mv='mv -i'
alias vi='vim';

#-----------------------------------------------------------------
# ローカル設定
#-----------------------------------------------------------------
if [ -f ~/.zshrc_local ]; then
  . ~/.zshrc_local
fi
