(setq custom-file "~/.emacs.d/custom-file.el")
(load-file custom-file)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; disable menu bar
(menu-bar-mode -1)
;; highlight current line
(global-hl-line-mode t)
;; show line/column numbers
(global-display-line-numbers-mode)
(setq column-number-mode t)

;; https://www.reddit.com/r/emacs/comments/l42oep/suppress_nativecomp_warnings_buffer/
(setq comp-async-report-warnings-errors nil)
(setq native-comp-async-report-warnings-errors nil)

;;;; Next two sections of things make startup slower.
;;;; Unclear if they're actually necessary?

;; require and initialize `package`
;(add-to-list 'load-path "~/.emacs.d/pkgs/")
(require 'package)
;(add-to-list 'package-archives
;             '("melpa" . "https://melpa.org/packages/") t)
;(add-to-list 'package-archives
;             '("gnu" . "https://elpa.gnu.org/packages/") t)
;(add-to-list 'package-archives
;             '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
;(package-initialize)

;; make sure we have `use-package`
;(when (not (package-installed-p 'use-package))
;  (package-refresh-contents)
;  (package-install 'use-package))
(require 'use-package)

(require 'cmake-mode)

;; color theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)
(add-to-list 'default-frame-alist '(background-color . "color-16"))

;; lsp config (used by both Rust and C{++})
(use-package lsp-mode
    :ensure t
    :custom
    (lsp-rust-server 'rust-analyzer)
    (lsp-rust-analyzer-cargo-watch-command "clippy")
    (lsp-eldoc-render-all nil)
    (lsp-signature-auto-activate nil) 
    (lsp-signature-doc-lines 1)
    (lsp-idle-delay 0.6)
    (lsp-rust-analyzer-server-display-inlay-hints t)
    (lsp-rust-analyzer-inlay-hints-mode t)
    (lsp-ui-doc-enable nil)
    (lsp-signature-render-documentation nil)
    :config
    (use-package lsp-ui
      :ensure t)
    ;;;; Seems company-lsp is no more
    ;;(use-package company-lsp
    ;;  :ensure t)
    (use-package company
      :ensure t
      :config
      (setq lsp-completion-provider :capf)))

;; rust configuration
(use-package rust-mode
  :ensure t
  :config
  ;; C-c C-c {C-c, C-r, C-t} to build, run, or test
  (use-package cargo 
    :ensure t
    :hook (rust-mode . cargo-minor-mode))
  ;; rustfmt for formatting code
  (add-hook 'rust-mode-hook 
            (lambda ()
              (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
  ;; racer does code completion
  ;;; M-. goes to definition, M-, goes back
 (use-package racer 
   :ensure t
   :hook (rust-mode . racer-mode)
    :init
    (use-package company :ensure t) ;; needed for racer
    (setq racer-cmd "~/.cargo/bin/racer") ;; racer binary path
    (setq racer-rust-src-path "~/code/rust/library")
    :config
    (add-hook 'racer-mode-hook #'eldoc-mode)
    (add-hook 'racer-mode-hook #'company-mode))
  ;; compiles code on the fly and reports errors
  (use-package flycheck-rust 
    :ensure t
    :config
    (add-hook 'rust-mode-hook 'flycheck-mode)
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
    (use-package flycheck-inline
      :ensure t
      :config
      (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)))
  ;; Rusty Object Notation syntax support
  (use-package ron-mode
    :ensure t)
  ;; rust language server for inline type annotations
  (add-hook 'rust-mode-hook 'lsp)
  ;; format Rust buffers (using rustfmt) and run clippy on save
  (add-hook 'before-save-hook 
            (lambda ()
              (when (eq major-mode 'rust-mode)
                (rust-format-buffer)))))

;; Markdown Configuration
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gmf-mode)
  :init (setq markdown-command "multimarkdown")
  :config
  (setq markdown-list-indent-width 2)
  (setq markdown-enable-math t)
  (setq markdown-enable-html t)
  (setq markdown-fontify-code-blocks-natively t))


;; Javascript Configuration
(setq js-indent-level 2)
(setq rjsx-indent-level 2)
(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  ;; Better imenu
  (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
  (use-package js2-refactor
    :ensure t
    :config
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    ;; to use js2-refactor commands name "C-c C-c (command)"
    (js2r-add-keybindings-with-prefix "C-c C-r")
    (define-key js2-mode-map (kbd "C-k") #'js2r-kill))
  ;; M-. jump to definition
  ;; M-? jump to references
  ;; M-, pop back to where M-. was last invokde
  (use-package xref-js2
    :ensure t
    :config
    ;; js-mode binds "M-." which conflicts with xref-js2 so we unbind it
    (define-key js-mode-map (kbd "M-.") nil)
    (add-hook 'js2-mode-hook (lambda ()
                               (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))
  ;; code formatter (automatically runs on save)
  ;; install with `npm install -g prettier'
  (use-package prettier-js
    :ensure t
    :config
    (add-hook 'js2-mode-hook #'prettier-js-mode)
    ;; should I have this?
    ;(add-hook 'web-mode-hook #'prettier-js-mode)
    (setq prettier-js-args '("--single-quote" "true"))))
          

;; When using C/C++, remember to generate compile_commands.json,
;; e.g. by adding set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE) to CMakeLists.txt
;; you may need to symlink it to your project root (from your build folder)

;; C/C++ Configuration (see e.g. https://github.com/MaskRay/ccls/wiki/lsp-mode )
(use-package ccls
  :ensure t
  :config
  (add-hook 'c-mode-common-hook 'lsp)
  (add-hook 'c++-mode-hook 'lsp)
  (setq c-basic-offset 2)
  ;; semantic highlighting
  ;(setq ccls-sem-highlight-method 'font-lock)
  ;; I have no idea what these next two lines did
  ;(lsp-find-custom "$ccls/call")
  ;(lsp-find-custom "$ccls/vars")
  )
