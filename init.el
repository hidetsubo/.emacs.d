;; おまじない
1;(require 'cl)

(setq initial-frame-alist
      (append (list
	       '(width . 120) ;; ウィンドウ幅
	       '(height . 45) ;; ウィンドウの高さ
;	       '(top . 100) ;;表示位置
;	       '(left . 1300) ;;表示位置
	       )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
;;全画面
;(set-frame-parameter nil 'fullscreen 'fullboth) 
;; 起動時にwindowを分割
;;http://b0r0nji.blogspot.jp/2011/06/emacs-eshell.html
;(defun split-window-and-run-term()
;  (setq w (selected-window))
;  (setq w2 (split-window w nil t)) ;左右分割
;  (setq w3 (split-window w 45)) ;上下分割
;  (select-window w3)
;  (multi-term)
;  (select-window w))
;(add-hook 'after-init-hook (lambda() (split-window-and-run-term)))

;;font ricty-9
;(set-frame-font "ricty-10")

;;簡単移動
;(windmove-default-keybindings)

;; Emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)
;; スタートアップメッセージを非表示
;(setq inhibit-startup-screen t)

;; Emacs 23より前のバージョンを利用している方は
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (< emacs-major-version 23)
 (defvar user-emacs-directory "~/.emacs.d/"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; ▼要拡張機能インストール▼（ただし、Emacs24からはインストール不要）
;;; P115-116 Emacs Lisp Package Archive（ELPA）──Emacs Lispパッケージマネージャ
;; package.elの設定
;(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
;  (add-to-list 'package-archives
;               '("marmalade" . "http://marmalade-repo.org/packages/"))
;  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
 ; (package-initialize))

;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  ;; tool-barを非表示
  (tool-bar-mode t)
  ;; scroll-barを非表示
  (scroll-bar-mode t))

;; CocoaEmacs以外はメニューバーを非表示
(unless (eq window-system 'ns)
  ;; menu-barを非表示
  (menu-bar-mode 1))

;; C-mにnewline-and-indentを割り当てる。
;; 先ほどとは異なりglobal-set-keyを利用
;;(global-set-key (kbd "C-m") 'newline-and-indent)
;; 折り返しトグルコマンド
;;(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
;(define-key global-map (kbd "C-t") 'other-window)

;;; P82-83 パスの設定
;(add-to-list 'exec-path "/opt/local/bin")
;(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")

;;; P85 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; Mac OS Xの場合のファイル名の設定
;(when (eq system-type 'darwin)
;  (require 'ucs-normalize)
;  (set-file-name-coding-system 'utf-8-hfs)
;  (setq locale-coding-system 'utf-8-hfs))

;; Windowsの場合のファイル名の設定
;(when (eq window-system 'w32)
;  (set-file-name-coding-system 'cp932)
;  (setq locale-coding-system 'cp932))

;; カラム番号も表示
(column-number-mode t)
;; ファイルサイズを表示
(size-indication-mode t)

;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
   (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;; これだとエコーエリアがチラつく
      ;;(count-lines-region (region-beginning) (region-end))
      ""))

;(add-to-list 'default-mode-line-format
;             '(:eval (count-lines-and-chars)))

;;; P90 タイトルバーにファイルのフルパスを表示
;(setq frame-title-format "%f")
;; 行番号を常に表示する
;(global-linum-mode t)

(when (require 'color-theme nil t)
  ;; テーマを読み込むための設定
  (color-theme-initialize)
  ;; テーマhoberに変更する
  (color-theme-hober))

;; P100 現在行のハイライト
(defface my-hl-line-face
  ;; 背景がdarkならば背景色を紺に
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    ;; 背景がlightならば背景色を緑に
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; P101 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;; バックアップファイルを作成しない
;; (setq make-backup-files nil) ; 初期値はt
;; オートセーブファイルを作らない
;; (setq auto-save-default nil) ; 初期値はt

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t)))

;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; オートセーブファイル作成までの秒間隔
(setq auto-save-timeout 15)
;; オートセーブファイル作成までのタイプ間隔
(setq auto-save-interval 60)

;; ファイルが #! から始まる場合、+xを付けて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode-hook用の関数を定義
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;; auto-installの設定
(when (require 'auto-install nil t)	; ←1●
  ;; 2●インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; 3●install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup)) ; 4●

;; ▼要拡張機能インストール▼
;;; P114-115 auto-installを利用する
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;(when (require 'redo+ nil t)
  ;; C-' にリドゥを割り当てる
;  (global-set-key (kbd "C-'") 'redo)
  ;; 日本語キーボードの場合C-. などがよいかも
  ;; (global-set-key (kbd "C-.") 'redo)
;  ) ; ←ここでC-x C-eで設定反映

;;(auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
    (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; M-yにanything-show-kill-ringを割り当てる
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)

;;; P128-129 moccurを利用する──anything-c-moccur
(when (require 'anything-c-moccur nil t)
  (setq
   ;; anything-c-moccur用 `anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; バッファの情報をハイライトする
   anything-c-moccur-higligt-info-line-flag t
   ;; 現在選択中の候補の位置をほかのwindowに表示する
   anything-c-moccur-enable-auto-look-flag t
   ;; 起動時にポイントの位置の単語を初期パターンにする
   anything-c-moccur-enable-initial-pattern t)
  ;; C-M-oにanything-c-moccur-occur-by-moccurを割り当てる
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))

;;; P130-131 利用可能にする
(when (require 'auto-complete-config nil t)
;(when (require 'auto-complete nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
   (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
   (define-key ac-completing-map "C-." 'ac-stop)
   (ac-config-default)
   (add-hook 'ruby-mode-hook
     (lambda ()
       (require 'rcodetools)
       ;;auto-complete-ruby
       (require 'auto-complete-ruby)
       (make-local-variable 'ac-omni-completion-sources)
       (setq ac-omni-completion-sources '(("\\.\\=" . (ac-source-rcodetools)))))))

;;; P132 検索結果をリストアップする──color-moccur
;; color-moccurの設定
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; moccur-editの設定
(require 'moccur-edit nil t)
;; moccur-edit-finish-editと同時にファイルを保存する
;; (defadvice moccur-edit-change-file
;;   (after save-after-moccur-edit-buffer activate)
;;   (save-buffer))

;; wgrepの設定
;(require 'wgrep nil t)

;; undohistの設定
;(when (require 'undohist nil t)
;  (undohist-initialize))

;; undo-treeの設定
;(when (require 'undo-tree nil t)
;  (global-undo-tree-mode))

;; point-undoの設定
;(when (require 'point-undo nil t)
  ;; (define-key global-map [f5] 'point-undo)
  ;; (define-key global-map [f6] 'point-redo)
  ;; 筆者のお勧めキーバインド
;  (define-key global-map (kbd "M-[") 'point-undo)
;  (define-key global-map (kbd "M-]") 'point-redo)
;  )

;;; P163 js-modeの基本設定
(defun js-indent-hook ()
  ;; インデント幅を4にする
  (setq js-indent-level 2
        js-expr-indent-offset 2
        indent-tabs-mode nil)
  ;; switch文のcaseラベルをインデントする関数を定義する
  (defun my-js-indent-line () ; ←1●
    (interactive)
    (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status)))
      (back-to-indentation)
      (if (looking-at "case\\s-")
          (indent-line-to (+ indentation 2))
        (js-indent-line))
      (when (> offset 0) (forward-char offset))))
  ;; caseラベルのインデント処理をセットする
  (set (make-local-variable 'indent-line-function) 'my-js-indent-line)
  ;; ここまでcaseラベルを調整する設定
  )

;; js-modeの起動時にhookを追加
(add-hook 'js-mode-hook 'js-indent-hook)

;;php-mode
(require 'php-mode)
(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;*.phpのファイルのときにphp-modeを自動起動する

;; yaml-modeの設定
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))

(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))

;;; P172-173 Ruby編集用の便利なマイナーモード
;; 括弧の自動挿入──ruby-electric
(require 'ruby-electric nil t)
;; endに対応する行のハイライト──ruby-block
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))
;; インタラクティブRubyを利用する──inf-ruby
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(setq auto-mode-alist (append (list
                               '(".gnus" . emacs-lisp-mode)
                               '(".abbrev_defs" . emacs-lisp-mode)
                               '("\\.el$" . emacs-lisp-mode)
                               '("\\.txt$" . text-mode)
                               '("\\.yaml$" . yaml-mode)
                              auto-mode-alist)))

;; mac emacs24のインストール
;; http://viget.com/extend/emacs-24-rails-development-environment-from-scratch-to-productive-in-5-minu
;; ruby-modeのインデント設定
;;(require 'ruby-mode nil t)
(setq ruby-indent-level 2 ; インデント幅を3に。初期値は2
      ruby-deep-indent-paren-style nil ; 改行時のインデントを調整する
      ;; ruby-mode実行時にindent-tabs-modeを設定値に変更
      ruby-indent-tabs-mode nil ; タブ文字を使用する。初期値はnil
      ) 
;;; P172-173 Ruby編集用の便利なマイナーモード
;(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))

;; 括弧の自動挿入──ruby-electric
(require 'ruby-electric nil t)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;;http://d.hatena.ne.jp/kazu-yamamoto/20080304
;; endに対応する行のハイライト──ruby-block
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))
(defun ruby-mode-hook-ruby-block()
  (ruby-block-mode t))
(add-hook 'ruby-mode-hook '(lambda () (ruby-mode-hook-ruby-block)))

;; インタラクティブRubyを利用する──inf-ruby
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

;; ruby-mode-hook用の関数を定義
(defun ruby-mode-hooks ()
  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))
;; ruby-mode-hookに追加
(add-hook 'ruby-mode-hook 'ruby-mode-hooks)

;;autotest
(require 'autotest)
(define-key ruby-mode-map "\C-c\C-a" 'autotest-switch)
(define-key shell-mode-map "\C-c\C-a" 'autotest-switch)

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
;; Rinari
;(add-to-list 'load-path "~/.emacs.d/public_repos/rinari")
;(require 'rinari)

;;; P195-196 Rinari
;(when (require 'rhtml-mode nil t)
;  (add-to-list 'auto-mode-alist '("\\.rhtml\\'" . rhtml-mode)))

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/public_repos/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas--initialize)
(yas/load-directory "~/.emacs.d/public_repos/yasnippet/snippets")
;; rails-snippets
(yas/load-directory "~/.emacs.d/public_repos/yasnippets-rails/rails-snippets")

;; 7.2 Flymakeによる文法チェック                          ;;
(require 'flymake)
;;; P182-183 Makefileがあれば利用し、なければ直接コマンドを実行する
;; Makefileの種類を定義
(defvar flymake-makefile-filenames
  '("Makefile" "makefile" "GNUmakefile")
  "File names for make.")

;; Makefileがなければコマンドを直接利用するコマンドラインを生成
(defun flymake-get-make-gcc-cmdline (source base-dir)
  (let (found)
    (dolist (makefile flymake-makefile-filenames)
      (if (file-readable-p (concat base-dir "/" makefile))
          (setq found t)))
    (if found
        (list "make"
              (list "-s"
                    "-C"
                    base-dir
                    (concat "CHK_SOURCES=" source)
                    "SYNTAX_CHECK_MODE=1"
                    "check-syntax"))
      (list (if (string= (file-name-extension source) "c") "gcc" "g++")
            (list "-o"
                  "/dev/null"
                  "-fsyntax-only"
                  "-Wall"
                  source)))))

;; Flymake初期化関数の生成
(defun flymake-simple-make-gcc-init-impl
  (create-temp-f use-relative-base-dir
                 use-relative-source build-file-name get-cmdline-f)
  "Create syntax check command line for a directly checked source file.
Use CREATE-TEMP-F for creating temp copy."
  (let* ((args nil)
         (source-file-name buffer-file-name)
         (buildfile-dir (file-name-directory source-file-name)))
    (if buildfile-dir
        (let* ((temp-source-file-name
                (flymake-init-create-temp-buffer-copy create-temp-f)))
          (setq args
                (flymake-get-syntax-check-program-args
                 temp-source-file-name
                 buildfile-dir
                 use-relative-base-dir
                 use-relative-source
                 get-cmdline-f))))
    args))

;; 初期化関数を定義
(defun flymake-simple-make-gcc-init ()
  (message "%s" (flymake-simple-make-gcc-init-impl
                 'flymake-create-temp-inplace t t "Makefile"
                 'flymake-get-make-gcc-cmdline))
  (flymake-simple-make-gcc-init-impl
   'flymake-create-temp-inplace t t "Makefile"
   'flymake-get-make-gcc-cmdline))

;; 拡張子 .c, .cpp, c++などのときに上記の関数を利用する
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'"
               flymake-simple-make-gcc-init))

;;; P184 XMLとHTML
;; XML用Flymakeの設定
(defun flymake-xml-init ()
  (list "xmllint" (list "--valid"
                        (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))))

;; HTML用Flymakeの設定
(defun flymake-html-init ()
  (list "tidy" (list (flymake-init-create-temp-buffer-copy
                      'flymake-create-temp-inplace))))
;;emacs error
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html\\'" flymake-html-init))

;;emacs error
;; tidy error pattern
(add-to-list 'flymake-err-line-patterns
  '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
  nil 1 2 4))

;;; P185-186 JavaScript
;; JS用Flymakeの初期化関数の定義
(defun flymake-jsl-init ()
  (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
                                'flymake-create-temp-inplace))))
;; JavaScript編集でFlymakeを起動する
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.js\\'" flymake-jsl-init))
;;emacs error
(add-to-list 'flymake-err-line-patterns
 '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)"
   1 2 nil 4))

;;; P186 Ruby
;; Ruby用Flymakeの設定
;; flymake-ruby
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
          (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))
 
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
 
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
 
(add-hook 'ruby-mode-hook
          '(lambda ()
             ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                 (flymake-mode t))
             ))

;;; P189-190 gtagsとEmacsとの連携
;; gtags-modeのキーバインドを有効化する
(setq gtags-suggested-key-mapping t) ; 無効化する場合はコメントアウト
(require 'gtags nil t)

;; ctags.elの設定
(require 'ctags nil t)
(setq tags-revert-without-query t)
;; ctagsを呼び出すコマンドライン。パスが通っていればフルパスでなくてもよい
;; etags互換タグを利用する場合はコメントを外す
;; (setq ctags-command "ctags -e -R ")
;; anything-exuberant-ctags.elを利用しない場合はコメントアウトする
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

;; AnythingからTAGSを利用しやすくするコマンド作成
(when (and (require 'anything-exuberant-ctags nil t)
           (require 'anything-gtags nil t))
  ;; anything-for-tags用のソースを定義
  (setq anything-for-tags
        (list anything-c-source-imenu
              anything-c-source-gtags-select
              ;; etagsを利用する場合はコメントを外す
              ;; anything-c-source-etags-select
              anything-c-source-exuberant-ctags-select
              ))

  ;; anything-for-tagsコマンドを作成
  (defun anything-for-tags ()
    "Preconfigured `anything' for anything-for-tags."
    (interactive)
    (anything anything-for-tags
              (thing-at-point 'symbol)
              nil nil nil "*anything for tags*"))
  
  ;; M-tにanything-for-currentを割り当て
  (define-key global-map (kbd "M-t") 'anything-for-tags))

;;; P195-196 Rinari
(when (require 'rhtml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.rhtml\\'" . rhtml-mode)))

;; multi-termの設定
(when (require 'multi-term nil t)
  ;; 使用するシェルを指定
  (setq multi-term-program "/bin/bash"))

(require 'tramp)
(setq tramp-debug-buffer t)
(setq tramp-verbose 10)
(setq tramp-default-method "ssh")
(add-to-list 'tramp-default-proxies-alist '("\\'" "\\`root\\'" "/ssh:%h:"))	 ;; 追加
(add-to-list 'tramp-default-proxies-alist '("hidetsubo-no-iMac\\'" "\\`root\\'" nil)) ;; 追加
(add-to-list 'tramp-default-proxies-alist '("localhost\\'" "\\`root\\'" nil))	 ;; 追加

;; TRAMPでバックアップファイルを作成しない
;(add-to-list 'backup-directory-alist
;             (cons tramp-file-name-regexp nil))

;; ;;; 折り返し表示ON/OFF
;; ubulog.blogspot.com/2007/09/emacsonoff.html 
(defun toggle-truncate-lines ()
  "折り返し表示をトグル動作します."
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))
(global-set-key "\C-c\C-l" 'toggle-truncate-lines)

;;http://qiita.com/items/f02ab0c38ad5e9ba385a
(require 'smart-compile)
(define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
(define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))

;;rcodetools
(require 'rcodetools)
(define-key ruby-mode-map (kbd "C-c C-d") 'xmp)

;;rspec-mode
;;(install-elisp "http://perso.tls.cena.fr/boubaker/distrib/mode-compile.el")
(autoload 'mode-compile "mode-compile"
  "Command to compile current buffer file based on the major mode" t)
 (global-set-key "\C-cc" 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
  "Command to kill a compilation launched by `mode-compile'" t)
2 (global-set-key "\C-ck" 'mode-compile-kill)

;;rvm
(require 'rvm)
(defadvice ido-completing-read (around invaild-ido-completing-read activate)
  "ido-completing-read -> completing-read"
  (complete-read))
(rvm-use-default)

;;yari
(require 'yari)

;rubydb
(autoload 'rubydb "rubydb3x" "Run rubydb on program FILE in buffer *gud-FILE*.
The directory containing FILE becomes the initial working directory
and source-file directory for your debugger.")

;;http://cx4a.org/software/rsense/manual.ja.html
;;めちゃくちゃ遅い、その上落ちる
;;http://www.findthatzipfile.com/search-38808707-hZIP/winrar-winzip-download-rsense-0.3.zip.htm
;;遅いが取ってこれそう
;(setq rsense-home "/home/hide/.emacs.d/opt/rsense-0.3")
;; UNIX系システムでの例
;; (setq rsense-home "/home/tomo/opt/rsense-0.2")
;; あるいは
;; (setq rsense-home (expand-file-name "~/opt/rsense-0.2"))
;(add-to-list 'load-path (concat rsense-home "/etc"))
;(require 'rsense)
;; C-c .で補完
;(add-hook 'ruby-mode-hook
;          '(lambda ()
;             ;; .や::を入力直後から補完開始
;             (add-to-list 'ac-sources 'ac-source-rsense-method)
;             (add-to-list 'ac-sources 'ac-source-rsense-constant)
             ;; C-x .で補完出来るようキーを設定
;             (define-key ruby-mode-map (kbd "C-x .") 'ac-complete-rsense)))
;; wget http://www.ruby-lang.org/ja/man/archive/snapshot/ruby-refm-1.9.3-dynamic-snapshot.tar.gz
;(setq rsense-rurema-home "/home/hide/.emacs.d/src/rurima")
;(setq rsense-rurema-refe "refe-1_9_3")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
'(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(display-time-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
