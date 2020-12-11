(setq custom-file "~/.emacs.d/custom-file.el")
(load-file custom-file)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; disable menu bar
(menu-bar-mode -1)
;; highlight current line
(global-hl-line-mode t)
;; show line numbers
(global-display-line-numbers-mode)

;; require and initialize `package`
(add-to-list 'load-path "~/.emacs.d/pkgs/")
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; make sure we have `use-package`
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; color theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)
(add-to-list 'default-frame-alist '(background-color . "color-16"))


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
  (use-package racer 
    :ensure t
    :hook (rust-mode . racer-mode)
    :init
    (use-package company :ensure t) ;; needed for racer
    (setq racer-cmd "~/.cargo/bin/racer") ;; racer binary path
    (setq racer-rust-src-path "/home/niven/code/rust/library")
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
  ;; format rust buffers on save using rustfmt
  (add-hook 'before-save-hook 
            (lambda ()
              (when (eq major-mode 'rust-mode)
                (rust-format-buffer)))))
