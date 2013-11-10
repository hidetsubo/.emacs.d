requires=rdoc.context,rdoc.constant,rdoc.token_stream,rdoc,rdoc.stats,rdoc.anon_class,rdoc.top_level,rdoc.normal_class,rdoc.alias,irb.slex,rdoc.normal_module,rdoc.any_method,irb.notifier,rdoc.code_object,rdoc.meta_method,e2mmap,rdoc.single_class,rdoc.ghost_method,rdoc.attr,rdoc.require,rdoc.code_objects,irb.output=2dmethod,rdoc.class_module,rdoc.parser,rdoc.parser.simple,rdoc.include
category=
methods=
sublibraries=
classes=RDoc=RubyToken,RDoc=RubyLex,RDoc=Parser=Ruby
is_sublibrary=true

Ruby のソースコードを解析するためのサブライブラリです。

拡張子が .rb、.rbw のファイルを解析する事ができます。

=== メタプログラミングされたメソッド

動的に定義されたメソッドをドキュメントに含めたい場合、## でコメントを開始します。

  ##
  # This is a meta-programmed method!

  add_my_method :meta_method, :arg1, :arg2

[[c:RDoc::Parser::Ruby]] は上記の :meta_method ようにメソッドの定義を行
うような識別子の後に続くトークンをメソッド名として解釈します。メソッド
名が見つからなかった場合、警告が表示されます。また、この場合はメソッド
名は 'unknown' になります。

:method: 命令を使う事でメソッド名を指定する事もできます。

  ##
  # :method: woo_hoo!

デフォルトでは動的に定義されたメソッドはインスタンスメソッドとして解析
されます。特異メソッドとしたい場合は、:singleton-method: 命令を指定しま
す。

  ##
  # :singleton-method:

以下のようにメソッド名を指定する事もできます。

  ##
  # :singleton-method: woo_hoo!

また、属性についても同様に :attr:、 :attr_reader:、 :attr_writer:、
:attr_accessor: を指定する事ができます。属性の名前は省略できます。

  ##
  # :attr_reader: my_attr_name

=== 隠しメソッド、属性

:method:、 :singleton-method: や :attr: 命令を使う事で実際には定義され
ていないメソッドもドキュメントに含める事ができます。

  ##
  # :attr_writer: ghost_writer
  # There is an attribute here, but you can't see it!

  ##
  # :method: ghost_method
  # There is a method here, but you can't see it!

  ##
  # this is a comment for a regular method

  def regular_method() end
