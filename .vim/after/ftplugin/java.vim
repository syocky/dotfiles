"タブ設定
setlocal ts=4 sw=4 sts=4 et

"改行でコメント自動挿入抑止
setlocal formatoptions-=ro

"全てのクラスをハイライトする
let java_highlight_all=1
"メソッド宣言文をハイライト
let java_highlight_functions=1
"デバッグ分(print系)をハイライト
let java_highlight_debug=1
"余分な空白に対してハイライト
let java_space_errors=1
