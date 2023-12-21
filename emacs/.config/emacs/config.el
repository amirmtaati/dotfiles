(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")  
			 ("org"   . "https://orgmode.org/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
			 ("elpa"  . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t) 

(when (display-graphic-p)
      (global-hl-line-mode))
      (column-number-mode)
      (global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		org-agenda-mode-hook
		vterm-mode-hook
		eshell-mode-hook))

(add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq make-backup-files nil)
(setq debug-on-error t)
(setq visible-bell 1)
(setq electric-pair-preserve-balance nil)
(setq tab-width 4)
(setq frame-inhibit-implied-resize t)
(scroll-bar-mode -1)              
(tool-bar-mode   -1)             
(tooltip-mode    -1)            
(menu-bar-mode   -1)           
(electric-pair-mode 1)
(set-fringe-mode 20)

(defvar amt/frame-transparency '(90 . 90))
(set-frame-parameter (selected-frame) 'alpha amt/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,amt/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defvar amt/font-family "Fira Code Retina")
(defvar amt/font-size 145)

(set-face-attribute 'default nil
  :family amt/font-family
  :height amt/font-size)

(set-face-attribute 'fixed-pitch nil
  :family amt/font-family 
  :height amt/font-size)

(set-face-attribute 'variable-pitch nil
  :family amt/font-family 
  :height amt/font-size)

(use-package default-text-scale
  :bind
  (("C-)" . default-text-scale-reset)
   ("C-=" . default-text-scale-increase)
   ("C--" . default-text-scale-decrease)))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-set-footer nil)
  (setq dashboard-banner-logo-title "Welcome!")
  (setq dashboard-startup-banner 2)
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil)
  (dashboard-setup-startup-hook))

(defvar amt/theme 'doom-one)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t) 
  (load-theme amt/theme t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
  :map ivy-minibuffer-map
     ("TAB" . ivy-alt-done)
     ("C-l" . ivy-alt-done)
     ("C-j" . ivy-next-line)
     ("C-k" . ivy-previous-line)
  :map ivy-switch-buffer-map
     ("C-k" . ivy-previous-line)
     ("C-l" . ivy-done)
     ("C-d" . ivy-switch-buffer-kill)
  :map ivy-reverse-i-search-map
     ("C-k" . ivy-previous-line)
     ("C-d" . ivy-reverse-i-search-kill))
  :config
     (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
    (ivy-prescient-enable-filtering nil)
  :config
    (prescient-persist-mode 1)
    (ivy-prescient-mode 1))

(use-package all-the-icons-ivy-rich
  :init
  (all-the-icons-ivy-rich-mode 1))

(use-package counsel
	  :bind
	  ("M-x" . 'counsel-M-x)
	  ("C-x b" . 'counsel-switch-buffer)
	  ("C-x C-f" . 'counsel-find-file)
	  ("C-s" . 'swiper)

	  :config
	  (use-package flx)

	  (ivy-mode 1)
	  (setq ivy-use-virtual-buffers t)
	  (setq ivy-count-format "(%d/%d) ")
	  (setq ivy-initial-inputs-alist nil)
	  (setq ivy-re-builders-alist
			'((swiper . ivy--regex-plus)
			  (t . ivy--regex-fuzzy))))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :after (evil org)
  :demand t
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(global-set-key (kbd "<f1>") 'vterm)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (
  (org-mode . lsp)
  (python-mode . lsp)
  (go-mode . lsp)
  (rust-mode . lsp)
  (lua-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :ensure t
  :bind (:map company-active-map
	 ("<tab>" . company-complete-selection))
	(:map lsp-mode-map
	 ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package flycheck
  :demand t
  :ensure t
  :config
  (global-flycheck-mode))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
	      ("s-p" . projectile-command-map)
	      ("C-c p" . projectile-command-map)))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(add-to-list 'load-path "/home/mamad/.config/emacs/julia-emacs")
(add-to-list 'load-path "/home/mamad/.config/emacs/lsp-julia")
(require 'julia-mode)
(require 'lsp-julia)

(use-package go-mode
	:ensure-system-package (go . golang)
	:bind (:map go-mode-map ("C-c C-c" . compile)))

  (use-package protobuf-mode)

  (setenv "GOPATH" (expand-file-name "/home/mamad/go"))
;;  (+append-to-path (concat (getenv "GOPATH") "/bin"))

;;  (defun +install-go-save-hooks ()
;;    (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;    (add-hook 'before-save-hook #'lsp-organize-imports t t))
 
;;  (add-hook 'go-mode-hook #'+install-go-save-hooks)

(use-package rustic
  :bind (:map rustic-mode-map
	      ("M-j" . lsp-ui-imenu)
	      ("M-?" . lsp-find-references)
	      ("C-c C-c l" . flycheck-list-errors)
	      ("C-c C-c a" . lsp-execute-code-action)
	      ("C-c C-c r" . lsp-rename)
	      ("C-c C-c q" . lsp-workspace-restart)
	      ("C-c C-c Q" . lsp-workspace-shutdown)
	      ("C-c C-c s" . lsp-rust-analyzer-status))

  :config
  (setq lsp-rust-analyzer-cargo-watch-command "clippy")
  (setq lsp-rust-analyzer-server-display-inlay-hints t)

  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook '+rustic-mode-hook))

(defun +rustic-mode-hook ()
  (setq-local buffer-save-without-query t))

(use-package python-mode)

;;  (use-package elpy
;;    :after python-mode
;;    :custom
;;    (elpy-rpc-python-command "python3")
;;    :config
;;    (elpy-enable))

(use-package yasnippet
  :demand t
  :config
  (setq yas-indent-line 'auto)
  (yas-global-mode 1))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :config
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq org-ellipsis " ▾")

(defun efs/org-mode-visual-fill ()
(setq visual-fill-column-width 150 
      visual-fill-column-center-text t)
      (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(add-to-list 'load-path "~/.config/emacs/dash/")
(add-to-list 'load-path "~/.config/emacs/s/")
(add-to-list 'load-path "~/.config/emacs/f/")
(add-to-list 'load-path "~/.config/emacs/ob-ipython/")

(org-babel-do-load-languages
  'org-babel-load-languages
      '((emacs-lisp . t)
	(lua . t)
	(julia . t)))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-directory "~/Documents/org/")
(use-package org-roam
  :after org
  :init (setq org-roam-v2-ack t) 
  :custom
  (org-roam-directory (file-truename org-directory))
  :config
  (org-roam-setup)
  (setq org-roam-completion-system 'ido)
  :bind (("C-c n f" . org-roam-node-find)
	 ("C-c n r" . org-roam-node-random)		    
	 (:map org-mode-map
	       (("C-c n i" . org-roam-node-insert)
		("C-c n o" . org-id-get-create)
		("C-c n t" . org-roam-tag-add)
		("C-c n a" . org-roam-alias-add)
		("C-c n l" . org-roam-buffer-toggle)))))

(global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture)

  (setq org-agenda-files
			'("~/Documents/org/gtd/next.org"
			  "~/Documents/org/gtd/inbox.org"
			  "~/Documents/org/gtd/wait.org"
			  "~/Documents/org/gtd/projects.org"
			  "~/Documents/org/gtd/repeat.org"
			  "~/Documents/org/gtd/calendar.org"
			  "~/Documents/org/gtd/habits.org"))

  (setq org-todo-keywords
	      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w)" "HOLDING(h)" "|" "CANC(c)")))

  (setq org-log-done 'time)
  (setq org-enforce-todo-dependencies t)

  (setq org-todo-keyword-faces
	    '(("TODO" . org-warning) ("NEXT" . "green")
	      ("CANCELED" . (:foreground "blue" :weight bold))))

  (setq org-capture-templates
	      `(("i" "inbox")
	       ("ii" "Task" entry (file+olp "~/Documents/org/gtd/inbox.org" "Inbox")
		"* TODO %? %(org-set-tags \"inbox\") \n  %U \n" :empty-lines 1)
("n" "note")
("nn" "Note" entry (file+olp "~/Documents/org/notes/notes.org" "Notes")
		"* TODO %?  \n  %U \n" :empty-lines 1)

("b" "book")
("bb" "Book" entry (file+olp "~/Documents/org/notes/books.org" "Books")
		"* TODO %?  \n  %U \n" :empty-lines 1)

))

  (setq org-agenda-prefix-format '((agenda . " %i %?-12t% s")
				     (todo . " %i ")
				     (tags . " %i ")
				     (search . " %i ")))

  (setq org-agenda-dim-blocked-tasks 'invisible)

  (setq org-refile-targets (quote ((nil :maxlevel . 9)
					   (org-agenda-files :maxlevel . 9)))))
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-block-separator ?─
	    org-agenda-time-grid
	    '((daily today require-timed)
	      (800 1000 1200 1400 1600 1800 2000)
	      " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
	    org-agenda-current-time-string
	    "⭠ now ─────────────────────────────────────────────────")
	     (setq org-agenda-custom-commands '())

	     (add-to-list 'org-agenda-custom-commands
		   '("p" "Personal agenda"
		     ((tags-todo "inbox|tickler+SCHEDULED=\"<today>\"|tickler+DEADLINE=\"<today>\""
				 ((org-agenda-overriding-header "Inbox")))

		      (tags-todo "next"
				 ((org-agenda-overriding-header "Next")))

		      (tags-todo "habit"
				 ((org-agenda-overriding-header "Habits")))

		      (agenda ""
			      ((org-agenda-overriding-header "Calendar")
			       (org-agenda-tag-filter-preset '("-next" "-habit"))))

		      (tags-todo "project"
				 ((org-agenda-overriding-header "Projects"))))

		     ((org-agenda-skip-deadline-if-done t)
		      (org-agenda-skip-scheduled-if-done t)
		      (org-agenda-skip-timestamp-if-done t)
		      (org-agenda-hide-tags-regexp "calendar\\|habit\\|inbox\\|next\\|project")
		      (org-agenda-tag-filter-preset '("-duplicate" "-news" "-writing")))))

(use-package ox-hugo
  :ensure t   
  :pin melpa  
  :after ox)
(setq org-hugo-base-dir "~/Documents/websites/amirmtaati.github.io")
(setq org-hugo-default-section-directory "blog")

(use-package deft
      :bind ("<f8>" . deft)
      :commands (deft)
      :config (setq deft-directory "~/Documents/notes"
		    deft-extensions '("md" "org"))
(setq deft-use-filename-as-title t))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  
  ;;(setq vterm-shell "zsh")                      
  (setq vterm-max-scrollback 10000))

(use-package mu4e
  :ensure nil
  :config
  (require 'mu4e-org)

  (setq mu4e-change-filenames-when-moving t)

  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")

  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder  "/[Gmail]/Trash")

  (setq mu4e-maildir-shortcuts
      '(("/Inbox"             . ?i)
	("/[Gmail]/Sent Mail" . ?s)
	("/[Gmail]/Trash"     . ?t)
	("/[Gmail]/Drafts"    . ?d)
	("/[Gmail]/All Mail"  . ?a))))

(setq smtpmail-smtp-server "smtp.gmail.com"
	smtpmail-smtp-service 587
	smtpmail-stream-type  'ssl)

;;  (setq message-send-mail-function 'smtpmail-send-it)

;  (add-to-list 'load-path "~/.config/emacs/xelb/")
;  (add-to-list 'load-path "~/.config/emacs/exwm/")
;  (require 'exwm)
;  (require 'exwm-config)
;  (exwm-config-example)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  (setq dired-open-extensions '(("png" . "feh")
				("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(setq elfeed-feeds
  '("http://nullprogram.com/feed/"
    "https://planet.emacslife.com/atom.xml"
    "https://www.discoverdev.io/rss.xml"
    "https://harryrschwartz.com/atom.xml"
    "https://xkcd.com/atom.xml"
    "https://rss.slashdot.org/Slashdot/slashdot"
    "https://www.wired.com/feed"
    "https://www.nature.com/nature.rss?error=cookies_not_supported&code=99469743-ac82-4849-96e3-089171bb1eef"
    "http://feeds.feedburner.com/codinghorror"
    "https://news.ycombinator.com/rss"
    "https://www.schneier.com/blog/atom.xml"
    "https://daringfireball.net/feeds/main"))

(with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes '("letter" "\\documentclass{letter}"))
    )
(eval-after-load "ox-latex"

  ;; update the list of LaTeX classes and associated header (encoding, etc.)
  ;; and structure
  '(add-to-list 'org-latex-classes
		`("beamer"
		  ,(concat "\\documentclass[presentation]{beamer}\n"
			   "[DEFAULT-PACKAGES]"
			   "[PACKAGES]"
			   "[EXTRA]\n")
		  ("\\section{%s}" . "\\section*{%s}")
		  ("\\subsection{%s}" . "\\subsection*{%s}")
		  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
