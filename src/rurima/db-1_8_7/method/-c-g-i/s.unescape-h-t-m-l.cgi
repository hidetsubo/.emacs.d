visibility=public
kind=defined
names=unescapeHTML

--- unescapeHTML(string) -> String
与えられた文字列中の実体参照のうち、&amp; &gt; &lt; &quot;
と数値指定がされているもの (&#0ffff など) を元の文字列に置換します。

@param string 文字列を指定します。

        require "cgi"

        p CGI.unescapeHTML("3 &gt; 1")   #=> "3 > 1"

