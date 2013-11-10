kind=defined
visibility=public 
names=add_option

--- add_option(*opts){|value, options| ... }

コマンドに対するコマンドラインオプションとハンドラを追加します。

ブロックには、コマンドライン引数の値とそのオプションが渡されます。
オプションはハッシュになっています。

@param opts オプションを指定します。

@see [[m:OptionParser#make_switch]]

