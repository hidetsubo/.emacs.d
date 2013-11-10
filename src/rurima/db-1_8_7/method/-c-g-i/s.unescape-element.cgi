visibility=public
kind=defined
names=unescapeElement

--- unescapeElement(string, *elements) -> String

特定の要素だけをHTMLエスケープから戻す。

@param string 文字列を指定します。

@param elements HTML タグの名前を一つ以上指定します。文字列の配列で指定することも出来ます。

例：
        require "cgi"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', "A", "IMG")
          # => "&lt;BR&gt;<A HREF="url"></A>"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', %w(A IMG))
          # => "&lt;BR&gt;<A HREF="url"></A>"

