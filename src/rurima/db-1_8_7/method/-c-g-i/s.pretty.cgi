visibility=public
kind=defined
names=pretty

--- pretty(string, shift = "  ") -> String

HTML を人間に見やすく整形しした文字列を返します。

@param string HTML を指定します。

@param shift インデントに使用する文字列を指定します。デフォルトは半角空白二つです。

例：
        require "cgi"

        print CGI.pretty("<HTML><BODY></BODY></HTML>")
          # <HTML>
          #   <BODY>
          #   </BODY>
          # </HTML>

        print CGI.pretty("<HTML><BODY></BODY></HTML>", "\t")
          # <HTML>
          #         <BODY>
          #         </BODY>
          # </HTML>
