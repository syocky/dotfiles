#-----------------------------------------------------------------
# パス設定
#-----------------------------------------------------------------
#
# パスを登録
# (N-/): 存在しないディレクトリは登録しない
#   パス(...): ...という条件にマッチするパスのみ残す
#           N: NULL_GLOBオプション設定
#              globがマッチしなかったり存在しないパスを無視する
#           -: シンボリックリンク先のパスを評価
#           /: ディレクトリのみ残す
path=($HOME/bin(N-/)
      $path
      /bin(N-/)
      /usr/*/bin(N-/)
      /usr/local/*/bin(N-/))

manpath=($HOME/local/share/man(N-/)
         /usr/*/man(N-/)
         /usr/local/*/man(N-/))

# LD_LIBRARY_PATH でも (N-/) を使ったり、重複パスを削除したい
if [ -z "${ld_library_path}" ]; then
    typeset -T LD_LIBRARY_PATH ld_library_path
fi

ld_library_path=(/usr/local/lib(N-/)
                 $HOME/usr/local/lib(N-)
                 ${ld_library_path})

# 重複したパスを登録しない
typeset -U path manpath ld_library_path

export PATH MANPATH LD_LIBRARY_PATH

#-----------------------------------------------------------------
# 環境変数
#-----------------------------------------------------------------
# エディタ
export EDITOR=vim
# 端末タイプ
export TERM=xterm-256color
