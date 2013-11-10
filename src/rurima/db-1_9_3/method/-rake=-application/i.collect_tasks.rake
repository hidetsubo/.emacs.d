kind=defined
visibility=public 
names=collect_tasks

--- collect_tasks(argv) -> Array

コマンドライン引数を解析して実行するタスクのリストを返します。

実行するタスクが指定されていない場合はデフォルトのタスクのみ返します。
また、このとき環境変数の解析も行います。

