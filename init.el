;; -*- coding: utf-8 -*-
(toggle-frame-fullscreen)

;; custom lisp
(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'load-path "/srv/sallies/our.el/")


;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(setq custom-theme-directory "~/.emacs.d/themes")
(load-theme 'sximada-dark t)

(when window-system
  (global-hl-line-mode t))
(unless window-system
  (setq hl-line-face 'underline)
  (global-hl-line-mode))

;; locale
(setenv "LANG" "ja_JP.UTF-8")
(set-buffer-file-coding-system 'utf-8-unix)

;; toolbar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; fonts
(set-face-attribute 'default nil :family "Menlo" :height 120)

(let ((typ (frame-parameter nil 'font)))
  (unless (string-equal "tty" typ)
    (set-fontset-font typ 'japanese-jisx0208
                      (font-spec :family "Hiragino Kaku Gothic ProN"))))
(add-to-list 'face-font-rescale-alist
             '(".*Hiragino Kaku Gothic ProN.*" . 1.2))
;; backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Splash
(setq initial-buffer-choice
      (lambda ()
	(switch-to-buffer "*Messages*")))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq custom-file (locate-user-emacs-file "custom.el"))

;; package
(require 'package nil 'noerror)

;; elpa/gnutls workaround
(if (string< emacs-version "26.3")
    (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(setq
 package-enable-at-startup t
 package-user-dir (expand-file-name "~/.elpa")
 package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
		    ("melpa" . "https://melpa.org/packages/")
		    ("org" . "https://orgmode.org/elpa/")
		    ;; ("marmalade" . "http://marmalade-repo.org/packages/")
		    ("melpa-stable" . "http://stable.melpa.org/packages/")
		    ))
(eval-when-compile
  (unless (file-exists-p (locate-user-emacs-file "tmp/bootstrap-stamp"))
    (package-refresh-contents)
    (with-temp-buffer (write-file (locate-user-emacs-file "tmp/bootstrap-stamp")))
    ))
(package-initialize)

(progn ;; Setup packaging tools
  (package-install 'use-package)
  (use-package quelpa :ensure t)
  (quelpa
   '(quelpa-use-package
     :fetcher git
     :url "https://github.com/quelpa/quelpa-use-package.git"))
  (require 'quelpa-use-package)
  (use-package el-get :ensure t))

;;; for qiita
(use-package ox-qmd :ensure t
  :quelpa (ox-qmd :fetcher github :repo "0x60df/ox-qmd"))

(use-package gist
  :ensure t :defer t
  :custom
  (gist-ask-for-filename t)
  (gist-ask-for-description t))


;;; Environment Variable
(require 'cl)
(require 'subr-x)

(setq exec-path (delete-duplicates
		 (append `(
			   "/Library/TeX/texbin"
			   "/usr/local/opt/mysql-client/bin"
			   "/usr/local/bin"
			   "/usr/local/opt/openjdk/bin"
			   "/usr/local/opt/apr-util/bin"
			   "/usr/local/opt/binutils/bin"
			   "/usr/local/opt/curl-openssl/bin"
			   "/usr/local/opt/gettext/bin"
			   "/usr/local/opt/icu4c/bin"
			   "/usr/local/opt/icu4c/sbin"
			   "/usr/local/opt/libpq/bin"
			   "/usr/local/opt/libxml2/bin"
			   "/usr/local/opt/llvm/bin"
			   "/usr/local/opt/ncurses/bin"
			   "/usr/local/opt/openldap/bin"
			   "/usr/local/opt/openldap/sbin"
			   "/usr/local/opt/openssl/bin"
			   "/usr/local/opt/php@7.2/bin"
			   "/usr/local/opt/php@7.2/sbin"
			   "/usr/local/opt/sqlite/bin"
			   "/usr/local/opt/texinfo/bin"
			   ;; "/Users/sximada/.nvm/versions/node/v10.16.3/bin"
			   ;; "/Users/sximada/.nvm/versions/node/v12.6.0/bin"
			   ;; "/Users/sximada/.nvm/versions/node/v8.16.1/bin"
			   "/Users/sximada/.nvm/versions/node/v8.15.0/bin"
			   ;; "/Users/sximada/development/flutter/bin"
			   "/usr/local/opt/openssl@1.1/bin"
			   ,(expand-file-name "~/.goenv/bin")
			   ,(expand-file-name "~/.goenv/shims")
			   ,(expand-file-name "~/development/flutter/bin")
			   ,(expand-file-name "~/.cargo/bin")
			   ,(expand-file-name "~/.local/bin")
			   ,(expand-file-name "~/.poetry/bin")
			   ,(expand-file-name "~/Library/Python/3.7/bin")
			   ,(expand-file-name "~/Library/Python/3.8/bin")
			   ,(expand-file-name "~/google-cloud-sdk/bin")
			   )
			 (split-string (getenv "PATH") ":")
			 exec-path)))

(setenv "PATH" (string-join exec-path ":"))

(setenv "LDFLAGS" (string-join '(
				 "-L/usr/local/opt/mysql-client/lib"
				 "-L/usr/local/opt/binutils/lib"
				 "-L/usr/local/opt/curl-openssl/lib"
				 "-L/usr/local/opt/gettext/lib"
				 "-L/usr/local/opt/icu4c/lib"
				 "-L/usr/local/opt/libffi/lib"
				 "-L/usr/local/opt/libpq/lib"
				 "-L/usr/local/opt/libxml2/lib"
				 "-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
				 "-L/usr/local/opt/llvm/lib"
				 "-L/usr/local/opt/openldap/lib"
				 "-L/usr/local/opt/openssl/lib"
				 "-L/usr/local/opt/openssl@1.1/lib"
				 "-L/usr/local/opt/php@7.2/lib"
				 "-L/usr/local/opt/readline/lib"
				 "-L/usr/local/opt/readline/lib"
				 "-L/usr/local/opt/sqlite/lib"
				 "-L/usr/local/opt/texinfo/lib"
				 "-L/usr/local/opt/ncurses/lib"
				 ;; "-L/usr/local/opt/openssl@1.1/lib"
				 ) " "))
(setenv "CPPFLAGS" (string-join '(
				  "-I/usr/local/opt/openjdk/include"
				  "-I/usr/local/opt/mysql-client/include"
				  "-I/usr/local/opt/binutils/include"
				  "-I/usr/local/opt/curl-openssl/include"
				  "-I/usr/local/opt/gettext/include"
				  "-I/usr/local/opt/icu4c/include"
				  "-I/usr/local/opt/libpq/include"
				  "-I/usr/local/opt/libxml2/include"
				  "-I/usr/local/opt/llvm/include"
				  "-I/usr/local/opt/openldap/include"
				  "-I/usr/local/opt/openssl/include"
				  "-I/usr/local/opt/openssl@1.1/include"
				  "-I/usr/local/opt/php@7.2/include"
				  "-I/usr/local/opt/readline/include"
				  "-I/usr/local/opt/readline/include"
				  "-I/usr/local/opt/sqlite/include"
				  "-I/usr/local/opt/ncurses/include"
				  ;; "-I/usr/local/opt/openssl@1.1/include"
				  ) " "))

(setenv "PKG_CONFIG_PATH" (string-join '(
					 "/usr/local/opt/libffi/lib/pkgconfig"
					 "/usr/local/opt/libxml2/lib/pkgconfig"
					 "/usr/local/opt/openssl/lib/pkgconfig"
					 "/usr/local/opt/openssl@1.1/lib/pkgconfig"
					 "/usr/local/opt/readline/lib/pkgconfig"
					 "/usr/local/opt/sqlite/lib/pkgconfig"
					 "/usr/local/opt/curl-openssl/lib/pkgconfig"
					 "/usr/local/opt/icu4c/lib/pkgconfig"
					 "/usr/local/opt/readline/lib/pkgconfig"
					 "/usr/local/opt/ncurses/lib/pkgconfig"
					 "/usr/local/opt/mysql-client/lib/pkgconfig"
					 ) ":"))

;;; Environment Variable Ends here

(require 'windmove)

(setenv "GIT_PAGER" "cat")  ;; Do not use the git command pager
(use-package magit :defer t :ensure t :no-require t)
(use-package monky :defer t :ensure t :no-require t)
(use-package transient :defer t :ensure t :no-require t)

;; Input I/F
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)

(use-package smex :ensure t :no-require t
  :config
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
  )

(use-package ido-vertical-mode :ensure t :no-require t
  :config
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only)
  (setq ido-vertical-show-count t)
  )

(use-package ido-completing-read+ :ensure t :defer t :no-require t
  :config
  (ido-ubiquitous-mode 1))

;;; For Silver Searcher (ag)
(use-package ag :ensure t :defer t :no-require t)

;;; For Nginx
(use-package nginx-mode :ensure t)


;;; For Docker
(use-package docker :defer t :ensure t :no-require t)
(use-package docker-compose-mode :defer t :ensure t :no-require t)
(use-package docker-tramp :defer t :ensure t :no-require t)
(use-package dockerfile-mode :defer t :ensure t :no-require t)

;;; For LSP
(use-package eglot :defer t :ensure t :no-require t
  :init
  (add-hook 'python-mode-hook 'eglot-ensure)
  :config
  (define-key eglot-mode-map (kbd "M-.") 'xref-find-definitions)
  (define-key eglot-mode-map (kbd "M-,") 'pop-tag-mark))

;;; For restclient
(use-package restclient :defer t :ensure t :no-require t)

;;; For babel
(require 'ob-plantuml)
(setq org-plantuml-jar-path "/usr/local/Cellar/plantuml/1.2019.1/libexec/plantuml.jar")

(use-package ob-restclient :defer t :ensure t :no-require t)
(use-package ob-async :ensure t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (emacs-lisp . t)
   (python . t)
   (restclient . t)
   ;;(rustic . t)
   (shell . t)
   (sql . t)))

;;; Editorconfig
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;;; For Rust
(use-package rustic :defer t :ensure t :no-require t
  :init
  (setq rustic-lsp-server 'rust-analyzer)
  (setq rustic-rls-pkg 'eglot))


;;; For Python
(use-package pyvenv :ensure t :no-require t)

;; https://github.com/jorgenschaefer/pyvenv/blob/fa6a028349733b0ecb407c4cfb3a715b71931eec/pyvenv.el#L168-L184
(defun pyvenv-create (venv-name python-executable)
  "Create virtualenv.  VENV-NAME  PYTHON-EXECUTABLE."
  (interactive (list
                (read-from-minibuffer "Name of virtual environment: ")
                (read-file-name "Python interpreter to use: "
                                (file-name-directory (executable-find "python3.7"))
                                nil nil "python")))
  (let ((venv-dir (concat (file-name-as-directory (pyvenv-workon-home))
                          venv-name)))
    (unless (file-exists-p venv-dir)
      (run-hooks 'pyvenv-pre-create-hooks)
      (with-current-buffer (generate-new-buffer "*virtualenv*")
        (call-process python-executable nil t t
		      "-m" "venv" venv-dir)
        (display-buffer (current-buffer)))
      (run-hooks 'pyvenv-post-create-hooks))
    (pyvenv-activate venv-dir)))

;;; For TypeScript
(use-package typescript-mode :defer t :ensure t :no-require t
  :config
  (custom-set-variables '(typescript-indent-level 2)))

;;; For React
(use-package rjsx-mode :defer t :ensure t :no-require t
  :config
  (setq indent-tabs-mode nil)
  (setq js-indent-level 2)
  (setq js2-strict-missing-semi-warning nil))

;;; Our Async Exec
(defvar our-async-exec-cmd-history nil)
(defvar our-async-exec-cwd-history nil)
(defvar our-async-exec-cmd nil)

(defun our-create-buffer-name (cmd &optional cwd)
  (format "`%s`%s"
	  (let ((elms (split-string cmd)))
	    (mapconcat 'identity
		       (append (last (split-string (car elms) "/"))
			       (cdr elms))
		       " "))
	  (if (and cwd (> (length cwd) 0)) (format ": %s" cwd) "")))


(defun our-async-exec (cmd &optional cwd buffer)
  (let ((buf (or buffer (get-buffer-create (our-create-buffer-name cmd cwd)))))
    (with-current-buffer buf
      (setq-local default-directory (or cwd default-directory))
      (async-shell-command cmd buf)
      ;; (our-async-exec-mode)
      (setq-local default-directory (or cwd default-directory))
      (setq-local our-async-exec-cmd cmd))))


(defun our-async-exec-retry ()
  (interactive)
  (if-let* ((cmd our-async-exec-cmd))
      (progn
	(async-shell-command our-async-exec-cmd (current-buffer))
	(our-async-exec-mode)
	(setq-local our-async-exec-cmd cmd))))


(defun our-async-exec-interactive (cmd &optional cwd buffer)
  (interactive
   (list (read-string "Command: "
		      ""
		      'our-async-exec-cmd-history
		      "")
	 (read-string "Directory: "
		      default-directory
		      'our-async-exec-cwd-history
		      default-directory)))
  (our-async-exec cmd cwd buffer))

(defun our-async-exec-close ()
  (interactive)
  (kill-buffer (current-buffer)))


(defun our-get-buffer-create (&optional name)
  (interactive "sBuffer Name: ")
  (let ((buf-name (format "*%s*" name)))
    (get-buffer-create buf-name)
    (message (format "Created a buffer: %s" buf-name))))


;; ---------------
;; MONKEY PATCHING
;; ---------------

;; for simple.el
;;
;; async-shell-commandで長い出力を表示する場合にEmacsが固まる問題を回避する
(defun comint-output-filter (process string)
  (let ((oprocbuf (process-buffer process)))
    ;; First check for killed buffer or no input.
    (when (and string oprocbuf (buffer-name oprocbuf))
      (with-current-buffer oprocbuf
	;; Run preoutput filters
	(let ((functions comint-preoutput-filter-functions))
	  (while (and functions string)
	    (if (eq (car functions) t)
		(let ((functions
                       (default-value 'comint-preoutput-filter-functions)))
		  (while (and functions string)
		    (setq string (funcall (car functions) string))
		    (setq functions (cdr functions))))
	      (setq string (funcall (car functions) string)))
	    (setq functions (cdr functions))))

	;; Insert STRING
	(let ((inhibit-read-only t)
              ;; The point should float after any insertion we do.
	      (saved-point (copy-marker (point) t)))

	  ;; We temporarily remove any buffer narrowing, in case the
	  ;; process mark is outside of the restriction
	  (save-restriction
	    (widen)

	    (goto-char (process-mark process))
	    (set-marker comint-last-output-start (point))

            ;; Try to skip repeated prompts, which can occur as a result of
            ;; commands sent without inserting them in the buffer.
            (let ((bol (save-excursion (forward-line 0) (point)))) ;No fields.
              (when (and (not (bolp))
                         (looking-back comint-prompt-regexp bol))
                (let* ((prompt (buffer-substring bol (point)))
                       (prompt-re (concat "\\`" (regexp-quote prompt))))
                  (while (string-match prompt-re string)
                    (setq string (substring string (match-end 0)))))))
            (while (string-match (concat "\\(^" comint-prompt-regexp
                                         "\\)\\1+")
                                 string)
              (setq string (replace-match "\\1" nil nil string)))

	    ;; insert-before-markers is a bad thing. XXX
	    ;; Luckily we don't have to use it any more, we use
	    ;; window-point-insertion-type instead.
	    (insert string)

	    ;; Advance process-mark
	    (set-marker (process-mark process) (point))

	    (unless comint-inhibit-carriage-motion
	      ;; Interpret any carriage motion characters (newline, backspace)
	      (comint-carriage-motion comint-last-output-start (point)))

	    ;; Run these hooks with point where the user had it.
	    (goto-char saved-point)
	    (run-hook-with-args 'comint-output-filter-functions string)
	    (set-marker saved-point (point))

	    (goto-char (process-mark process)) ; In case a filter moved it.

	    (unless comint-use-prompt-regexp
              (with-silent-modifications
                (add-text-properties comint-last-output-start (point)
                                     '(front-sticky
				       (field inhibit-line-move-field-capture)
				       rear-nonsticky t
				       field output
				       inhibit-line-move-field-capture t))))

	    ;; Highlight the prompt, where we define `prompt' to mean
	    ;; the most recent output that doesn't end with a newline.
	    (let ((prompt-start (save-excursion (forward-line 0) (point)))
		  (inhibit-read-only t))
	      (when comint-prompt-read-only
		(with-silent-modifications
		  (or (= (point-min) prompt-start)
		      (get-text-property (1- prompt-start) 'read-only)
		      (put-text-property (1- prompt-start)
					 prompt-start 'read-only 'fence))
		  (add-text-properties prompt-start (point)
				       '(read-only t front-sticky (read-only)))))
	      (when comint-last-prompt
		;; There might be some keywords here waiting for
		;; fontification, so no `with-silent-modifications'.
		(font-lock--remove-face-from-text-property
		 (car comint-last-prompt)
		 (cdr comint-last-prompt)
		 'font-lock-face
		 'comint-highlight-prompt))
	      (setq comint-last-prompt
		    (cons (copy-marker prompt-start) (point-marker)))
	      ;; ここのプロパティ設定によりとてつもなく処理がおもくなるためコメントアウト
	      ;; (font-lock-prepend-text-property prompt-start (point)
	      ;; 				       'font-lock-face
	      ;; 				       'comint-highlight-prompt)
	      (add-text-properties prompt-start (point) '(rear-nonsticky t)))
	    (goto-char saved-point)))))))


(easy-mmode-define-minor-mode our-async-exec-mode
			      "This is our-async-exec-mode"
			      nil
			      "OurAsyncExec"
			      '(("C-c C-g" . our-async-exec-retry)
				("C-c C-q" . our-async-exec-close)))

;;; Our Async Exec Ends here.

;;; Our Git Clone
(defun our-git-config-entry (name email ssh-private-key-path)
  `((name . ,name)
    (email . ,email)
    (key . ,ssh-private-key-path)))

(defvar our-git-config nil)


(defun our-git-fetch-unshallow (repo label cwd name)
  (interactive
   (list
    (completing-read "Repository: " nil)
    (ido-completing-read
     "Git configuration: "
     (mapcar (lambda (n) (car n)) our-git-config)
     nil nil nil nil nil)
    (ido-read-directory-name "Directory: ")
    (completing-read "Name: " nil)))

  (unless (file-exists-p cwd)
    (make-directory cwd))

  (let ((entry (cdr (assoc label our-git-config))))
    (our-async-exec
     (format "git -c core.sshCommand='ssh -i %s -F /dev/null' clone %s %s"
	     (cdr (assoc 'key entry))
	     repo name)
     cwd)))


(defun our-git-clone (repo label cwd name)
  (interactive
   (list
    (completing-read "Repository: " nil)
    (ido-completing-read
     "Git configuration: "
     (mapcar (lambda (n) (car n)) our-git-config)
     nil nil nil nil nil)
    (ido-read-directory-name "Directory: ")
    (completing-read "Name: " nil)))

  (unless (file-exists-p cwd)
    (make-directory cwd))

  (let ((entry (cdr (assoc label our-git-config))))
    (our-async-exec
     (format "git -c core.sshCommand='ssh -i %s -F /dev/null' clone  --depth 1 %s %s"
	     (cdr (assoc 'key entry))
	     repo name)
     cwd)))


(defun our-git-submodule-add (repo label cwd name)
  (interactive
   (list
    (completing-read "Repository: " nil)
    (ido-completing-read
     "Git configuration: "
     (mapcar (lambda (n) (car n)) our-git-config)
     nil nil nil nil nil)
    (ido-read-directory-name "Directory: ")
    (completing-read "Name: " nil)))

  (unless (file-exists-p cwd)
    (make-directory cwd))

  (let ((entry (cdr (assoc label our-git-config))))
    (our-async-exec
     (format "git -c core.sshCommand='ssh -i %s -F /dev/null' submodule add %s %s"
	     (cdr (assoc 'key entry))
	     repo name)
     cwd)))

(defun our-git-config-apply (label cwd)
  (interactive
   (list
    (ido-completing-read
	  "Git configuration: "
	  (mapcar (lambda (n) (car n)) our-git-config)
	  nil nil nil nil nil)
    (ido-read-directory-name "Directory: ")))

  (let ((entry (cdr (assoc label our-git-config))))
    (our-async-exec
     (format "git config user.name '%s' && git config user.email '%s' && git config core.sshCommand 'ssh -i %s -F /dev/null'"
	     (cdr (assoc 'name entry))
	     (cdr (assoc 'email entry))
	     (cdr (assoc 'key entry)))

     cwd)))
;;; Our Git Clone Ends here.

;;; Our open user init file
(defun our-open-user-init-file ()
  (interactive)
  (switch-to-buffer
   (find-file-noselect
    user-init-file)))
;;; Our open init file Ends here.

;;; Our open user task file
(defun our-open-user-task-file ()
  (interactive)
  (find-file "~/Dropbox/tasks/README.org"))
;;; Our open user task file Ends here.

(defun lang-install-rust ()
  (interactive)
  (async-shell-command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)"))

;;; For elscreen
(use-package elscreen :ensure t :no-require t
  :init
  (setq elscreen-display-tab nil)
  (setq elscreen-tab-display-kill-screen nil)
  (setq elscreen-tab-display-control nil)
  (bind-key* "C-t C-t" 'elscreen-previous)
  :config
  (elscreen-start)
  (elscreen-create))

;;; For flycheck
(use-package flycheck :defer :ensure t :no-require t
  :init
  (add-hook 'python-mode-hook 'flycheck-mode))

;;; For vue.js
(use-package add-node-modules-path :ensure t :defer t)
(require 'flycheck)
(use-package vue-mode :ensure t :defer t
  :init
  (flycheck-add-mode 'javascript-eslint 'vue-mode)
  (flycheck-add-mode 'javascript-eslint 'vue-html-mode)
  (flycheck-add-mode 'javascript-eslint 'css-mode)
  :config
  (add-hook 'vue-mode-hook #'add-node-modules-path)
  (add-hook 'vue-mode-hook 'flycheck-mode))

(bind-keys*
 ("¥" . "\\")
 ("C-h" . backward-delete-char-untabify)
 ("C-c C-w" . comment-or-uncomment-region)

 ;; keyboard macro
 ("<f1>" . start-kbd-macro)
 ("<f2>" . end-kbd-macro)
 ("<f3>" . call-last-kbd-macro)

 ;; move buffer
 ("C-t h" . windmove-left)
 ("C-t j" . windmove-down)
 ("C-t k" . windmove-up)
 ("C-t l" . windmove-right)
 ("C-t C-h" . windmove-left)
 ("C-t C-j" . windmove-down)
 ("C-t C-k" . windmove-up)
 ("C-t C-l" . windmove-right)

 ("C-t C-h" . windmove-left)
 ("C-t C-j" . windmove-down)
 ("C-t C-k" . windmove-up)
 ("C-t C-l" . windmove-right)

 ;; Git
 ("C-x C-v" . magit-status)

 ;; My Customize
 ;; ("M-_" . our-async-exec-interactive)
 ("s-`" . our-async-exec-interactive)
 ("<C-ESC>" . our-async-exec-interactive)
 ("C-t C-c" . our-async-exec-interactive)

 ;; File open utility
 ("<f12>" . our-open-user-init-file)
 ("S-<f12>" . our-open-user-task-file)
 )

(load-file "~/.emacs.d/settings.el")

(use-package org
  :config
  (setq org-hide-leading-stars t)
  (setq org-startup-indented t)
  (setq org-display-inline-images t)
  (setq org-redisplay-inline-images t)
  (setq org-startup-with-inline-images "inlineimages")
  :bind (("<f9>" . 'org-set-effort)
	 ("<S-f10>" . 'org-clock-in)
	 ("<S-f11>" . 'org-clock-out)))

;; org-export
(custom-set-variables '(org-export-with-sub-superscripts nil))

;; org-agenda
;; (setq org-agenda-overriding-columns-format "%TODO %7EFFORT %PRIORITY     %100ITEM 100%TAGS")
(use-package company :ensure t :pin melpa
  :config
  (global-company-mode)
  (custom-set-variables
   '(company-idle-delay nil)
   '(company-tooltip-idle-delay nil))
  )

(defun our-buffer-copy-current-file-path ()
  "バッファのファイルパスをクリップボードにコピーする"
  (interactive)
  (let ((path (buffer-file-name)))
    (if path
      (progn
        (kill-new path)
        (message (format "Copied: %s" path)))
      (message (format "Cannot copied")))))

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

(bind-key* "C-t C-a" 'org-agenda)
(bind-key* "C-t a" 'org-agenda)
;; (bind-key* "C-t C-j" 'org-capture)

;; n https://github.com/tj/n
(setenv "N_PREFIX" (expand-file-name "~/.local"))
(put 'set-goal-column 'disabled nil)
(bind-key "C-[ C-[" 'mark-word)
(bind-key* "M-]" 'mark-word)

(bind-key "s-t" nil)  ;; command + t でfontの設定画面が開いてしまうが使わないので開かないように設定する.
(bind-key* "C-x C-w" 'ido-kill-buffer)

;; カレンダーの表示に星をつける
(setq calendar-month-header
      '(propertize (format " %s %d " (calendar-month-name month) year)
		   'font-lock-face 'calendar-month-header))

;; (use-package emoji-fontset
;;   :if window-system
;;   :init
;;   (emoji-fontset-enable "Symbola"))

;; org-agenda
(custom-set-variables
 '(org-agenda-span 1)
 '(org-todo-keywords '((sequence
			"INBOX" "MAYBE" "ACTION" "WAITING" "TODO"
			"|"
			"DONE" "CANCEL")))
 '(org-global-properties '(("Effort_ALL" . "1 2 3 5 8 13 21 34 55 89 144 233 377 610 987")))
 '(org-columns-default-format "%TODO %PRIORITY %Effort{:} %DEADLINE %ITEM %TAGS")
 '(org-agenda-columns-add-appointments-to-effort-sum t)
 '(org-deadline-warning-days 0)  ;; 当日分のeffortを集計するためにdeadlineが今日でないものは除外する
 '(org-agenda-custom-commands
   '(("W" "Weekly Review"
      ((agenda "" ((org-agenda-span 7))); review upcoming deadlines and appointments
					; type "l" in the agenda to review logged items
       (stuck "") ; review stuck projects as designated by org-stuck-projects
       (todo "ISSUE") ; review all projects (assuming you use todo keywords to designate projects)
       (todo "INBOX")
       (todo "MAYBE")
       (todo "ACTION")
       (todo "TODO")
       (todo "WAITING")
       (todo "DONE")
       (todo "CANCEL")))
     )))


(bind-key* "C-t t" #'org-clock-jump-to-current-clock)

(require 'org-agenda)
(bind-keys :map org-agenda-mode-map
	   ("C-c C-c" . org-agenda-todo)
	   ("C-c C-e" . org-agenda-set-effort)
	   ("C-c C-i" . org-agenda-clock-in)
	   ;; ("C-c C-o" . org-agenda-clock-out)
	   )

;; #+PROPERTY: Effort_ALL 1 2 3 5 8 13 21 34 55 89 144 233
;; #+STARTUP: indent hidestars inlineimages
;; #+TODO: TODO(t) ISSUE(i) EPIC(e) IDEA(i) BLOCK(b) SURVEY(s) PENDING(p) WIP(w) | DONE(d!) CANCEL(c!) DOC SPEC
;; #+COLUMNS: %40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM
;; (put 'narrow-to-region 'disabled nil)


;; setup golang
(progn
  (use-package lsp-mode
    :ensure t
    :commands (lsp lsp-deferred)
    :hook (go-mode . lsp-deferred))

  ;; Set up before-save hooks to format buffer and add/delete imports.
  ;; Make sure you don't have other gofmt/goimports hooks enabled.
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

  ;; Optional - provides fancier overlays.
  (use-package lsp-ui
    :ensure t
    :commands lsp-ui-mode)

  ;; Company mode is a standard completion package that works well with lsp-mode.
  (use-package company
    :ensure t
    :config
    ;; Optionally enable completion-as-you-type behavior.
    (setq company-idle-delay 0)
    (setq company-minimum-prefix-length 1))

  ;; Optional - provides snippet support.
  (use-package yasnippet
    :ensure t
    :commands yas-minor-mode
    :hook (go-mode . yas-minor-mode))
  )

;; org-agendaの項目を開いたら作業時間を自動で計測する
(defun org-clock-in-interactive (&optional starting-p)
  (when (yes-or-no-p "Clock In?")
    (org-clock-in)))

(add-hook 'org-agenda-after-show-hook #'org-narrow-to-subtree)
(add-hook 'org-agenda-after-show-hook #'org-clock-in-interactive)
(add-hook 'org-clock-out-hook #'org-agenda-list)
(add-hook 'org-clock-out-hook #'widen)

(bind-key "C-c C-x C-t o" #'org-clock-out)
(bind-key "C-c C-x C-t b" #'org-clock-in-last)


(use-package unicode-escape :ensure t :defer t)  ;; for qiita
(use-package avy-menu :ensure t :defer t)  ;; for terraform
(use-package sudden-death :ensure t :defer t)
(use-package dired-filter :ensure t :defer t)
(use-package google-translate :ensure t :defer t)

;; github-review
(use-package github-review :defer t :ensure t)

;; My Package
(el-get-bundle gist:e8a10244aac6308de1323d1f6685658b:change-case)
(require 'change-case)

(el-get-bundle gist:c4c6ee198a1c576220a144ab825fa2f0:mastodon)
(require 'mastodon)

(el-get-bundle foreman-mode :type "git" :url "git@github.com:collective-el/foreman-mode.git")
(require 'foreman-mode)

(el-get-bundle dotenv-mode :type "git" :url "git@github.com:TakesxiSximada/emacs-dotenv-mode.git")
(require 'dotenv-mode)

(el-get-bundle elnode :type "git" :url "git@github.com:collective-el/elnode.git")
(require 'elnode)

(with-current-buffer (find-file-noselect "/Users/sximada/.config/mastodon/mstdn.jp")
  (dotenv-mode-apply-all))


;; -----------
;; our-package
;; -----------
;; (require 'our)
;; (require 'our-brew)
;; (require 'our-cider)
;; (require 'our-circleci)
;; (require 'our-discord)
;; (require 'our-freewifi)
;; (require 'our-macos)
;; (require 'our-magit)
;; (require 'our-mastodon)
;; (require 'our-need-install)
;; (require 'our-org)
;; (require 'our-pyvenv)
;; (require 'our-qiita)
;; (require 'our-simeji)
;; (require 'our-terraform)
;; (require 'our-wakatime)

;; (add-to-list 'our-org--target-dir-list "~/Dropbox/tasks")

;; (load-file "~/.emacs.d/env/discord.el")
;; (load-file "~/.emacs.d/env/mastodon.el")
;; (load-file "~/.emacs.d/env/wakatime.el")
;; (load-file "~/.emacs.d/env/cloudapp.el")

;; -------------
;; external tool
;; -------------
(unless (executable-find "redis-cli") (our-async-exec "brew install redis"))
(unless (executable-find "chromedriver") (our-async-exec "brew cask install chromedriver"))



;; -------
;; clojure
;; -------
;; (unless (executable-find "java") (our-async-exec "brew cask install java"))
;; (unless (executable-find "clj") (our-async-exec "brew install clojure"))
;; (unless (executable-find "lein") (our-async-exec "brew install leiningen"))
(use-package rainbow-delimiters :ensure t :defer t)
(use-package paredit :ensure t :defer t
  :config
  (bind-keys :map paredit-mode-map
             ("C-h" . paredit-backward-delete)))
(use-package clojure-mode :ensure t :defer t)
(use-package clj-refactor :ensure t :defer t
  :diminish clj-refactor-mode
  :config (cljr-add-keybindings-with-prefix "C-c j"))
(use-package cider :ensure t :defer t
  :init
  (add-hook 'cider-mode-hook #'clj-refactor-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t
        cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        cider-overlays-use-font-lock t)
  (cider-repl-toggle-pretty-printing))


;; --------
;; wakatime
;; --------
;; (require 'our-wakatime)
;; (use-package wakatime-mode :ensure t :defer t
;;   :init
;;   (our-wakatime-setup)
;;   (if (and wakatime-api-key
;; 	   (file-exists-p wakatime-cli-path))
;;       (global-wakatime-mode)))



;; --------
;; org-mode
;; --------
;; (defun our-org-mode-setup ()
;;   (org-indent-mode)  ;; org-modeの表示をインデントモードにする
;;   (org-display-inline-images)  ;; 画像表示
;;   (setq org-src-fontify-natively t)

;;   (setq org-todo-keywords
;;       '((sequence
;;          "TODO(t)"
;; 	 "WIP(w)"
;; 	 "PENDING(e)"
;; 	 "REVIEW(r)"
;; 	 "PROPOSAL(P)"
;; 	 "PROBREM(p)"
;; 	 "QUESTION(q)"
;; 	 "RESEARCH(R)"
;; 	 "FEEDBACK(f)"
;; 	 "EPIC(g)"
;; 	 "|"
;;          "WHY(W)"
;;          "DONE(x)"
;; 	 "CANCEL(c)"
;; 	 "RESOLVED(o)"
;; 	 "KEEP(k)"
;; 	 "DOC(d)"
;; 	 "FAQ(f)"
;; 	 "SPEC(s)"
;; 	 "TIPS(t)")))

;;   (setq org-global-properties
;; 	(quote (("Effort_ALL" . "1 2 3 5 8 13 21 34 55 89")
;; 		("STYLE_ALL" . "habit")))))

;; (add-hook 'org-mode-hook 'our-org-mode-setup)


;; ---------
;; org-babel
;; ---------
;; (use-package ob-restclient :ensure t :defer t)
;; (use-package org-preview-html :ensure t :defer t)
;; (our-need-install "plantuml" "plantuml" :darwin "brew install plantuml")
;; (setq org-plantuml-jar-path "/usr/local/Cellar/plantuml/1.2019.1/libexec/plantuml.jar")
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '(
;;    (dot . t)
;;    (emacs-lisp . t)
;;    (plantuml . t)
;;    (restclient . t)
;;    (shell . t)
;;    (python . t)
;;    (sql . t)
;;    ))


;; ----------
;; kubernetes
;; ----------
;; (use-package kubernetes
;;   :ensure t
;;   :commands (kubernetes-overview))



;; ----------
;; others
;; ----------
;; (our-need-install "basictex" "basictex" :darwin "brew cask install basictex # M-x our-latex-update")
;; (defun our-latex-update ()
;;   (interactive)
;;   (our-async-exec
;;    (string-join '(;; パッケージのアップデート
;; 		  "sudo tlmgr update --self --all"
;; 		  ;; デフォルトで A4 用紙を使う
;; 		  "sudo tlmgr paper a4"
;; 		  ;; 日本語用パッケージ群のインストール
;; 		  "sudo tlmgr install collection-langjapanese"
;; 		  ;; 和文フォント ヒラギノのインストールと設定
;; 		  "sudo tlmgr repository add http://contrib.texlive.info/current tlcontrib"
;; 		  "sudo tlmgr pinning add tlcontrib '*'"
;; 		  "sudo tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree ptex-fontmaps-macos cjk-gs-integrate-macos"
;; 		  "sudo cjk-gs-integrate --link-texmf --cleanup"
;; 		  "sudo cjk-gs-integrate-macos --link-texmf"
;; 		  "sudo mktexlsr"
;; 		  "sudo kanji-config-updmap-sys --jis2004 hiragino-highsierra-pron"
;; 		  ;; 日本語環境でソースコードの埋め込み
;; 		  ;; FIXME: ここではうまくjlisting.sty.bz2がダウンロード出来ていないのでコメントアウトするしかない
;; 		  ;; "curl https://ja.osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/ | bzip2 -d "
;; 		  ;; "sudo mv ~/Downloads/jlisting.sty /usr/local/texlive/2018basic/texmf-dist/tex/latex/listings/"
;; 		  ;; "sudo chmod +r /usr/local/texlive/2018basic/texmf-dist/tex/latex/listings/jlisting.sty"
;; 		  ;; "sudo mktexlsr"
;; 		  )
;; 		" && ")))

;; (our-need-install "ghostscript" "ghostscript" :darwin "brew install ghostscript")
;; (our-need-install "latexit" "latexit" :darwin "brew cask install latexit")
;; (our-need-install "pandoc" "pandoc" :darwin "brew install pandoc")


;; -----
;; elenv
;; -----
;; (setq elenv-root-directory "/srv/")
;; (add-hook
;;  'elenv-initialize-package-after-hook
;;  (lambda ()
;;    (require 'use-package)

;;    (use-package powerline :ensure t :defer t)

;;    (use-package exec-path-from-shell :ensure t :defer t
;;      :init
;;      (when (memq window-system '(mac ns x))
;;        (exec-path-from-shell-initialize)))

;;    (use-package helm :ensure t :defer t
;;      :init
;;      (require 'helm-config)
;;      :config
;;      (helm-mode t)
;;      (dired-async-mode t)
;;      (setq helm-M-x-fuzzy-match t)
;;      (bind-keys :map helm-map
;; 		("<tab>" . helm-execute-persistent-action)
;; 		("C-i" . helm-execute-persistent-action)
;; 		("C-z" . helm-select-action)))
;;    (use-package helm-ag :ensure t :defer t
;;      :init
;;      (setq helm-ag-use-agignore t))
;;    (use-package elscreen :ensure t
;;      :init
;;      (setq elscreen-display-tab nil)
;;      (setq elscreen-tab-display-kill-screen nil)
;;      (setq elscreen-tab-display-control nil)
;;      (elscreen-start)
;;      (elscreen-create))
;;    (use-package magit :ensure t :defer t)

;;    (use-package async-await :ensure t :defer t)
;;    ;; (use-package json :ensure t :defer t)
;;    (use-package request :ensure t :defer t)
;;    (use-package async-await :ensure t :defer t)
;;    (use-package gist :ensure t :defer t)
;;    (use-package helm-themes :ensure t :defer t)
;;    (use-package http :ensure t :defer t)
;;    (use-package markdown-mode :ensure t)
;;    (use-package quickrun :ensure t :defer t)
;;    (use-package restclient :ensure t :defer t
;;      :config
;;      (add-to-list 'restclient-content-type-modes '("text/csv" . http-mode)))
;;    (use-package websocket :ensure t :defer t)
;;    (use-package yaml-mode :ensure t :defer t)
;;    (use-package dockerfile-mode :ensure t :defer t)
;;    (use-package company :ensure t :defer nil
;;      :init
;;      (setq company-idle-delay 0) ; default = 0.5
;;      (setq company-minimum-prefix-length 2) ; default = 4
;;      (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
;;      :bind
;;      ("C-M-i" . company-complete)
;;      :config
;;      (global-company-mode 1)
;;      (bind-keys :map company-active-map
;; 		("C-n" . company-select-next)
;; 		("C-p" . company-select-previous)
;; 		("C-s" . company-filter-candidates)
;; 		("C-i" . company-complete-selection)
;; 		("C-M-i" . company-complete)))

;;    (use-package spacemacs-theme :ensure t :defer t
;;      :no-require t
;;      :init
;;      (load-theme 'tsdh-dark t))
;;    (use-package foreman-mode :ensure t :defer t)
;;    ))
