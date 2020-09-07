;; -*- coding: utf-8 -*-
(toggle-frame-fullscreen)

;; custom lisp
(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'load-path "/srv/sximada/elnode")

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


;; MONKEY PATCHING
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
   '(company-idle-delay .1)
   '(company-tooltip-idle-delay .1))
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
(bind-key "M-SPC" 'our-async-exec-interactive)  ;; M-SPCでコマンド実行可能にする

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

(with-current-buffer (find-file-noselect "/Users/sximada/.config/mastodon/mstdn.jp")
  (dotenv-mode-apply-all))
