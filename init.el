;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq scroll-conservatively 101) ; Scroll line by line
(setq inhibit-startup-message t) ; Disable startup message
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(menu-bar-mode -1)            ; Disable the menu bar

(electric-indent-mode t)

(global-hl-line-mode 1)

;; Transparent Editor
(set-frame-parameter (selected-frame) 'alpha 95)
(add-to-list 'default-frame-alist '(alpha . 95))

;; Line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
;; Disable line numbers inn certain mode
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                neotree-mode-hook
                treemacs-mode-hook
                ranger-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))
  (add-hook mode (lambda () (indent-guide-mode 0))))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Ermaolaoye Emacs")
  (setq dashboard-startup-banner "~/documents/emlylogo/1.png")
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-footer nil)
  (setq dashboard-center-content t)
  )

(set-face-attribute 'default nil :font "SpaceMono Nerd Font Mono" :height 160)
(set-face-attribute 'variable-pitch nil :font "ETBookOT" :height 200)
(set-face-attribute 'fixed-pitch nil :font "SpaceMono Nerd Font Mono" :height 160)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :diminish
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-escape
  :after evil
  :config
  (evil-escape-mode)
  (setq-default evil-escape-key-sequence "jk"))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer em/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  )

;; Keybonds
(global-set-key [(hyper a)] 'mark-whole-buffer)
(global-set-key [(hyper v)] 'yank)
(global-set-key [(hyper c)] 'kill-ring-save)
(global-set-key [(hyper s)] 'save-buffer)
(global-set-key [(hyper l)] 'goto-line)
(global-set-key [(hyper w)]
                (lambda () (interactive) (delete-window)))
(global-set-key [(hyper z)] 'undo)

(setq mac-command-modifier nil)
(setq mac-option-modifier 'meta)

;; ivy
(use-package swiper)

(use-package counsel
  :config
  (counsel-mode 1))

(use-package ivy
  :diminish
  :init
  (ivy-mode 1)
  :bind(("C-s" . swiper)
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
  (setq ivy-display-style 'fancy)
  )

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package all-the-icons)

;; doom-modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom(
          (doom-modeline-height 15)
          (doom-modline-icon t)
          (doom-modeline-unicode-fallback t))
  )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package doom-themes
  :init (load-theme 'doom-horizon t)
  :config
  (setq doom-themes-treemacs-enable-variable-pitch nil)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)
  (doom-themes-neotree-config)
  )

(use-package indent-guide
  :config
  (indent-guide-global-mode))

(defun em/org-mode-setup ()
  (setq org-image-actual-width nil)
  (auto-fill-mode 0)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (org-indent-mode)
  (setq evil-auto-indent nil)
  (setq org-startup-with-inline-images 1)
  (setq org-startup-with-latex-preview 1)
  (lambda()
    (setq-local line-spacing 0.45)))

(defun em/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "➤"))))))

  ;; LaTeX
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 3))
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.7)
                  (org-level-2 . 1.5)
                  (org-level-3 . 1.4)
                  (org-level-4 . 1.3)
                  (org-level-5 . 1.2)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "ETBookOT" :weight 'regular :height (cdr face))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
    (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
    (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
    (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-document-title nil :inherit 'fixed-pitch)
    )
  ) 

(defun em/org-structure-template-setup()
  )

(use-package org
                                        ;:hook (org-mode . dw/org-mode-setup)
  :hook (org-mode . em/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t)
  (em/org-font-setup)
  (em/org-structure-template-setup)
  )
(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun em/org-mode-visual-fill()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))


(use-package visual-fill-column
  :hook (org-mode . em/org-mode-visual-fill))

(use-package org-download
  :config
  (setq-default org-download-image-dir "./.images")
  :bind
  (""))


(require 'org-tempo)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package org-roam
  :bind (
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         )
  :config
  (setq org-roam-directory (file-truename "~/Documents/org-roam"))
  (org-roam-db-autosync-mode)
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.33)
                 (window-height . fit-window-to-buffer)))
  (setq org-return-follows-link t)
  )

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(use-package smartparens
  :hook prog-mode)

(use-package reveal-in-osx-finder)

(em/leader-key-def
  "ff" 'reveal-in-osx-finder
  )

(em/leader-key-def
  :state 'normal
  "\\" 'indent-region)

(defun em/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symboles))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :hook (lsp-mode . em/lsp-mode-setup)
  :hook (c-mode . lsp-deferred) ; C Mode hook to lsp
  :hook (c++-mode . lsp-deferred)
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp
  :commands lsp-treemacs-errors-list
  )
(use-package treemacs-evil)

(em/leader-key-def
  "t" '(:ignore t :which-key "treemacs-prefix")
  "tt" 'treemacs
  "td" 'treemacs-select-directory
  )

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (setq yas-triggers-in-field t))

(use-package cmake-mode
  :mode "CMakeLists.txt")

(em/leader-key-def
  "f" '(:ignore t :which-key "files")
  "fem" '((lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/emacs.org"))) :which-key "edit config")
  "fw" 'save-buffer
  "fq" 'kill-current-buffer
  "fn" 'dired-create-empty-file
  "fp" 'org-download-clipboard)
