;;; modus-themes-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "modus-operandi-theme" "modus-operandi-theme.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modus-operandi-theme.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modus-operandi-theme" '("modus-operandi")))

;;;***

;;;### (autoloads nil "modus-themes" "modus-themes.el" (0 0 0 0))
;;; Generated autoloads from modus-themes.el

(autoload 'modus-themes-contrast "modus-themes" "\
Measure WCAG contrast ratio between C1 and C2.
C1 and C2 are color values written in hexadecimal RGB.

\(fn C1 C2)" nil nil)

(autoload 'modus-themes-color "modus-themes" "\
Return color value for KEY.
The KEY is the car of each cons cell in the alists
`modus-themes-colors-operandi', `modus-themes-colors-vivendi'.

\(fn KEY)" nil nil)

(autoload 'modus-themes-color-alts "modus-themes" "\
Return color value for KEY-LIGHT and KEY-DARK.
Both arguments must reference the car of a cons cell in
`modus-themes-colors-operandi', `modus-themes-colors-vivendi'.

\(fn KEY-LIGHT KEY-DARK)" nil nil)

(autoload 'modus-themes-load-operandi "modus-themes" "\
Load `modus-operandi' and disable `modus-vivendi'.
Also run `modus-themes-after-load-theme-hook'.

\(fn)" nil nil)

(autoload 'modus-themes-load-vivendi "modus-themes" "\
Load `modus-vivendi' and disable `modus-operandi'.
Also run `modus-themes-after-load-theme-hook'.

\(fn)" nil nil)

(autoload 'modus-themes-toggle "modus-themes" "\
Toggle between `modus-operandi' and `modus-vivendi' themes.
Also runs `modus-themes-after-load-theme-hook' by virtue of
calling the internal `modus-themes-load-operandi' and
`modus-themes-load-vivendi' functions.

\(fn)" t nil)

(when (and (boundp 'custom-theme-load-path) load-file-name) (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name))))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modus-themes" '("modus-themes-")))

;;;***

;;;### (autoloads nil "modus-themes-core" "modus-themes-core.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modus-themes-core.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modus-themes-core" '("modus-themes-core-theme")))

;;;***

;;;### (autoloads nil "modus-vivendi-theme" "modus-vivendi-theme.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from modus-vivendi-theme.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "modus-vivendi-theme" '("modus-vivendi")))

;;;***

;;;### (autoloads nil nil ("modus-themes-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; modus-themes-autoloads.el ends here
