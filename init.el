;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Load path etc.

(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

;; Load up ELPA, the package manager

(add-to-list 'load-path dotfiles-dir)

(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit"))

(setq autoload-file (concat dotfiles-dir "loaddefs.el"))
(setq package-user-dir (concat dotfiles-dir "elpa"))
(setq custom-file (concat dotfiles-dir "custom.el"))

(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")))
  (add-to-list 'package-archives source t))
(package-initialize)
(require 'starter-kit-elpa)

;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

;; backport some functionality to Emacs 22 if needed
(require 'dominating-file)

;; Load up starter kit customizations

(require 'starter-kit-defuns)
(require 'starter-kit-bindings)
(require 'starter-kit-misc)
(require 'starter-kit-registers)
(require 'starter-kit-eshell)
(require 'starter-kit-lisp)
(require 'starter-kit-perl)
(require 'starter-kit-ruby)
(require 'starter-kit-js)

(regen-autoloads)
(load custom-file 'noerror)

;; You can keep system- or user-specific customizations here
(setq system-specific-config (concat dotfiles-dir system-name ".el")
      user-specific-config (concat dotfiles-dir user-login-name ".el")
      user-specific-dir (concat dotfiles-dir user-login-name))
(add-to-list 'load-path user-specific-dir)

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-dir)
  (mapc #'load (directory-files user-specific-dir nil ".*el$")))
(if (file-exists-p user-specific-config) (load user-specific-config))

;;; init.el ends here

;;; MAT init el
;; nxhtml
(load "~/.emacs.d/lib/nxhtml/autostart.el")
(add-to-list 'load-path "~/.emacs.d/lib/")

;; zenburn theme
(add-to-list 'load-path "~/.emacs.d/lib/color-theme-6.6.0/")
(require 'color-theme)
(load-theme 'zenburn)  ;; requires that zenburn.el is in your load path
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-zenburn)))

;; disable different background coloring w/ nxhtml
;; don't edit by hand! use:
;; M-x customize-option RET mumamo-chunk-coloring RET
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(initial-buffer-choice t)
 '(mumamo-chunk-coloring 900))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

; line numbers, etc
;; Show line-number in the mode line
(line-number-mode 1)
;; Show column-number in the mode line
(column-number-mode 1)
;; Dont split words across lines
(global-visual-line-mode t)
;; Set the fill column 
;(setq-default fill-column 72)
;; Show line numbers left of each line
(global-linum-mode t)

;; disable auto-fill behaviour
(setq auto-fill-mode -1)
(setq-default fill-column 99999)
(setq fill-column 99999)

;; bind return to newline and indent (turn on autoindentation)
(define-key global-map (kbd "RET") 'newline-and-indent)

;; ===== Set standard indent ====
(setq standard-indent 4)

;; ===== Turn off tab character =====
;; Emacs normally uses both tabs and spaces to indent lines. If you
;; prefer, all indentation can be made from spaces only. To request this,
;; set `indent-tabs-mode' to `nil'. This is a per-buffer variable;
;; altering the variable affects only the current buffer, but it can be
;; disabled for all buffers.
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally 
(setq-default indent-tabs-mode nil) 

;; switch between windows hotkeys
(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

; dired+
(add-to-list 'load-path "~/.emacs.d/libs")
(require 'dired+)

; dired-details-hide
(require 'dired-details)
(dired-details-install)

;; dired order directories first
(defun sof/dired-sort ()
  "Dired sort hook to list directories first."
  (save-excursion
   (let (buffer-read-only)
     (forward-line 2) ;; beyond dir. header  
     (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (and (featurep 'xemacs)
       (fboundp 'dired-insert-set-properties)
       (dired-insert-set-properties (point-min) (point-max)))
  (set-buffer-modified-p nil))

 (add-hook 'dired-after-readin-hook 'sof/dired-sort)

;; dired hide hidden files
(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

;; ^ in dired mode use same buffer, use a to use same buffer when
;; opening selected dir, too
(add-hook 'dired-mode-hook
 (lambda ()
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ; was dired-up-directory
 ))

;; set-frame-width-interactive
(defun set-frame-width-interactive (arg)
   (interactive "p")
   (set-frame-width (selected-frame) arg))

;; dired remote (tramp) default ssh
(setq tramp-default-method "ssh")

; fix php/C {'s, http://stackoverflow.com/questions/168621/php-mode-for-emacs
(setq c-default-style "bsd"
      c-basic-offset 4)

;; set automated backups dir
; Enable backup files.
;(setq make-backup-files t)
; Enable versioning with default values (keep five last versions, I think!)
;(setq version-control t)
; Save all backup file in this directory.
;(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/")))
(setq backup-directory-alist `(("." . "~/.emacs_backups")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; comment/uncomment regions hotkey
(global-set-key (kbd "M-_") 'comment-region)
(global-set-key (kbd "M-:") 'uncomment-region)

;; indent hotkey
(global-set-key (kbd "M-M") 'indent-region)

;; truncate lines 
(setq-default truncate-lines t) 
(global-set-key (kbd "<f6>") 'toggle-truncate-lines) ; bind f6 to toggle
(add-hook 'latex-mode-hook (lambda () (setq truncate-lines nil))) ; dont truncate in latex mode
(add-hook 'compilation-mode-hook (lambda () (setq truncate-lines t))) ; please truncate in compilation mode
(add-hook 'buffer-menu-mode-hook (lambda () (setq truncate-lines t))) ; please truncate in buffer menu
(add-hook 'c-mode-hook (lambda () (setq truncate-lines t))) ; please truncate in c-mode
(add-hook 'lisp-mode-hook (lambda () (setq truncate-lines t))) ; please truncate in lisp-mode
(setq line-move-visual nil) ; C-e goes to *actual* end of line

;; bash autocompletion in emacs shell
(require 'bash-completion)
(bash-completion-setup)

;; auto-complete
(add-to-list 'load-path "~/.emacs.d/lib/auto-complete/")
(require 'auto-complete)
;(global-auto-complete-mode 1) ; (uncomment to enable by default)

;; bind F5 to recompile (use M-x compile first!)
(global-set-key (kbd "<f5>") 'recompile)

;; delete whitespace from point to word
(defun whack-whitespace (arg)
  "Delete all white space from point to the next word.  With prefix ARG
    delete across newlines as well.  The only danger in this is that you
    don't have to actually be at the end of a word to make it work.  It
    skips over to the next whitespace and then whacks it all to the next
    word."
  (interactive "P")
  (let ((regexp (if arg "[ \t\n]+" "[ \t]+")))
    (re-search-forward regexp nil t)
    (replace-match "" nil nil)))
(global-set-key (kbd "M-K") 'whack-whitespace)

;; breadcrumbs easier bookmarks
(require 'breadcrumb)
(global-set-key [(meta I)]              'bc-set)            ;; Shift-SPACE for set bookmark
(global-set-key [(meta P)]              'bc-local-previous) ;; M-j for jump to previous
(global-set-key [(meta N)]              'bc-local-next)     ;; Shift-M-j for jump to next
(global-set-key [(control c)(j)]        'bc-goto-current)   ;; C-c j for jump to current bookmark
(global-set-key [(control x)(meta j)]   'bc-list)           ;; C-x M-j for the bookmark menu list
(global-set-key [(meta C)]              'bc-clear)          ;; M-c to clear bookmarks
; also bc-previous, bc-next (can also jump between buffers)

;; indent comment to same column as previous line comment
(global-set-key (kbd "C-<tab>") 'indent-for-comment)

;; ############################################
; From:
; http://paradox1x.org/2010/06/making-emacs-wi/
;; visible bell
(setq visible-bell nil)
;; allow selection deletion
(delete-selection-mode t)
;; make sure delete key is delete key
(global-set-key [delete] 'delete-char)
;; turn on the menu bar
(menu-bar-mode 1)
;; have emacs scroll line-by-line
(setq scroll-step 1)
;; ;; set color-theme
;; ;(color-theme-zenburn)
;; (load-theme 'zenburn t)
(defun my-zoom (n)
"Increase or decrease font size based upon argument"
(set-face-attribute 'default (selected-frame) :height
(+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10))))
(global-set-key (kbd "C-+")      '(lambda nil (interactive) (my-zoom 1)))
(global-set-key [C-kp-add]       '(lambda nil (interactive) (my-zoom 1)))
(global-set-key (kbd "C--")      '(lambda nil (interactive) (my-zoom -1)))
(global-set-key [C-kp-subtract]  '(lambda nil (interactive) (my-zoom -1)))
(message "All done!")
;; ############################################

;; set mouse scroll to line by line
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
;; nicer mouse scroll
(setq mouse-wheel-progressive-speed nil)
;; smooth scrolling
;(require 'smooth-scrolling)
;(require 'smooth-scroll)
;(smooth-scroll-mode t)
;; dont scroll as much with M-v and C-v
(setq next-screen-context-lines 10)
;; nicer scrolling behaviour
;(setq scroll-step 1)
;(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

(show-paren-mode t)

(put 'dired-find-alternate-file 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; dired-fixups.el --- fixups for dired mode

;; Author: Dino Chiesa
;; Created: Sat, 31 Mar 2012  10:31
;; Version: 0.1
;;

(require 'ls-lisp)

    ;; (defun ls-lisp-format-time (file-attr time-index now)
    ;;   "################")

(defun ls-lisp-format-file-size (file-size human-readable)
  "This is a redefinition of the function from `dired.el'. This
fixes the formatting of file sizes in dired mode, to support very
large files. Without this change, dired supports 8 digits max,
which is up to 10gb.  Some files are larger than that.
"
  (if (or (not human-readable)
          (< file-size 1024))
      (format (if (floatp file-size) " %11.0f" " %11d") file-size)
    (do ((file-size (/ file-size 1024.0) (/ file-size 1024.0))
         ;; kilo, mega, giga, tera, peta, exa
         (post-fixes (list "k" "M" "G" "T" "P" "E") (cdr post-fixes)))
        ((< file-size 1024) (format " %10.0f%s"  file-size (car post-fixes))))))


(defun dired-sort-toggle ()
  "This is a redefinition of the fn from dired.el. Normally,
dired sorts on either name or time, and you can swap between them
with the s key.  This function one sets sorting on name, size,
time, and extension. Cycling works the same.
"
  (setq dired-actual-switches
        (let (case-fold-search)
          (cond
           ((string-match " " dired-actual-switches) ;; contains a space
            ;; New toggle scheme: add/remove a trailing " -t" " -S",
            ;; or " -U"
            ;; -t = sort by time (date)
            ;; -S = sort by size
            ;; -X = sort by extension

            (cond

             ((string-match " -t\\'" dired-actual-switches)
              (concat
               (substring dired-actual-switches 0 (match-beginning 0))
               " -X"))

             ((string-match " -X\\'" dired-actual-switches)
              (concat
               (substring dired-actual-switches 0 (match-beginning 0))
               " -S"))

             ((string-match " -S\\'" dired-actual-switches)
              (substring dired-actual-switches 0 (match-beginning 0)))

             (t
              (concat dired-actual-switches " -t"))))

           (t
            ;; old toggle scheme: look for a sorting switch, one of [tUXS]
            ;; and switch between them. Assume there is only ONE present.
            (let* ((old-sorting-switch
                    (if (string-match (concat "[t" dired-ls-sorting-switches "]")
                                      dired-actual-switches)
                        (substring dired-actual-switches (match-beginning 0)
                                   (match-end 0))
                      ""))

                   (new-sorting-switch
                    (cond
                     ((string= old-sorting-switch "t") "X")
                     ((string= old-sorting-switch "X") "S")
                     ((string= old-sorting-switch "S") "")
                     (t "t"))))
              (concat
               "-l"
               ;; strip -l and any sorting switches
               (dired-replace-in-string (concat "[-lt"
                                                dired-ls-sorting-switches "]")
                                        ""
                                        dired-actual-switches)
               new-sorting-switch))))))

  (dired-sort-set-modeline)
  (revert-buffer))


(defun dired-sort-set-modeline ()
 "This is a redefinition of the fn from `dired.el'. This one
properly provides the modeline in dired mode, supporting the new
search modes defined in the new `dired-sort-toggle'.
"
  ;; Set modeline display according to dired-actual-switches.
  ;; Modeline display of "by name" or "by date" guarantees the user a
  ;; match with the corresponding regexps.  Non-matching switches are
  ;; shown literally.
  (when (eq major-mode 'dired-mode)
    (setq mode-name
          (let (case-fold-search)
            (cond ((string-match "^-[^t]*t[^t]*$" dired-actual-switches)
                   "Dired by time")
                  ((string-match "^-[^X]*X[^X]*$" dired-actual-switches)
                   "Dired by ext")
                  ((string-match "^-[^S]*S[^S]*$" dired-actual-switches)
                   "Dired by sz")
                  ((string-match "^-[^SXUt]*$" dired-actual-switches)
                   "Dired by name")
                  (t
                   (concat "Dired " dired-actual-switches)))))
    (force-mode-line-update)))


(provide 'dired-fixups)

;;; dired-fixups.el ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; WEB ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun web/trim (str)
  (replace-regexp-in-string "^[[:space:]]*\\|[[:space:]]*$" "" str))


(defun web/css-propertyp (property)
  "Checks if something can be considered a CSS property."
  (or (string= "-" (substring property 0 1))
      (member (downcase property) css-property-ids)))


(defun web/css-prettify-selectors (selectors)
  "Returns a properly sorted string with selectors."
  (concat (replace-regexp-in-string " *, *"
                                    (concat ",\n")
                                    selectors)
          " {"))


(defun web/css-fix-property-spacing ()
  "Converts things like 'color:x' to `color: x'.

It expects a properly indented CSS"
  (interactive)
  (save-excursion)
  (goto-char (point-min))
  (while (re-search-forward "^ *\\([^:]+\\) *: *" nil t)
    (if (web/css-propertyp (match-string 1))
        (replace-match (concat "    "
                               (match-string 1)
                               ": ")))))


(defun web/css-indent-buffer ()
  "Indents the whole buffer correctly."
  (interactive)
  (indent-region (point-min) (point-max)))


(defun web/css-unminify ()
  "Unminifies the whole CSS."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "{" nil t)
      (replace-match "{\n")))
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "}" nil t)
      (replace-match "\n}\n")))
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward ";" nil t)
      (replace-match ";\n")))
  (web/css-indent-buffer)
  (web/css-align-properties))


(defun web/css-align-properties ()
  "Aligns the properties with align-region"
  (interactive)
  (align-regexp (point-min) (point-max) "^ +\\([^:]+ *\\)\\(: *\\) " 2 1 nil))


(defun web/css-fix-selectors ()
  "Uses one selector per line"
  (interactive)
  (save-excursion)
  (goto-char (point-min))
  (while (re-search-forward "^\\(.+\\) *{ *" nil t)
    (replace-match (web/css-prettify-selectors (match-string 1)))))


(defun web/css-fix-brace-spacing ()
  "Fixes brace spacing"
  (interactive)
  (save-excursion)
  (goto-char (point-min))
  (while (re-search-forward " *{ *$" nil t)
    (replace-match " {")))


(defun web/css-remove-semicolons ()
  "Removes semicolons from the end of the line to make it moar clean."
  (interactive)
  (save-excursion)
  (goto-char (point-min))
  (while (re-search-forward " *; *$" nil t)
    (replace-match "")))


(defun web/css-fix-formatting ()
  "Fixes all the formatting in the file."
  (interactive)
  (web/css-fix-selectors)
  (web/css-indent-buffer)
  (web/css-fix-property-spacing)
  (web/css-fix-brace-spacing)
  (web/css-align-properties))



(defun web/css->stylus ()
  "Converts a css file to stylus"
  (interactive)
  (web/css-fix-formatting)
  (web/css-remove-semicolons))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Using generic mode for blackfin assembly

(require 'generic-x)

;; Bfin assembly mode
(define-generic-mode 
    'bfin-mode                      ; name of the mode to create
  '("#")                            ; comments start with '!!'
  '("LSETUP" "RTS")       ; some keywords
  '(("=" . 'font-lock-operator)     ; '=' is an operator
    (";" . 'font-lock-builtin)     ; ';' is a built-in
    ("\\(^\s*\\.[a-zA-Z0-9]+:?\\)" . 'font-lock-keyword-face) ; labels: .something:
    ("\\(\s+0[xX][0-9a-fA-F]+\\)" . 'font-lock-variable-name-face) ; hex numbers
    ("\\(\s+[0-9a-f]+\\)" . 'font-lock-variable-name-face) ; decimal numbers
    ("\\(^\s*_[a-zA-Z0-9]+:?\\)" . 'font-lock-function-name-face)) ; _something:
  '("\\.s$")                        ; files for which to activate this mode 
  nil                               ; other functions to call
  "A mode for bfin assembly"        ; doc string for this mode
  )
(eval-after-load 'bfin 
  '(define-key bfin-mode [(tab)] 'c-indent-line-or-region))

;; Allow copying to system clipboard
(setq x-select-enable-clipboard t)

;; Semantic mode
(add-hook 'semantic-mode-hook (lambda () (global-semantic-idle-summary-mode 1)))
(add-hook 'semantic-mode-hook (lambda () (global-semantic-idle-completions-mode 1)))

;; MATLAB mode http://www.emacswiki.org/MatlabMode
(add-to-list 'load-path "~/.emacs.d/lib/matlab-emacs")
(load-library "matlab-load")
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")

; for latex
(setq-default TeX-master nil) ; Query for master file.

;; auto scroll compilation window
(setq compilation-auto-scroll t)
(setq compilation-scroll-output t)

;; svn for emacs23
(add-to-list 'load-path "~/.emacs.d/lib/vc-svn17-el")
(require 'vc-svn17)

;; swap C-x <left> and C-x <right> since its reversed in 23 vs 24
;(setq Buffer-menu-sort-column nil)
;(setq Buffer-menu-user-frame-buffer-list nil)

; not working??

;; completely disable flyspell
(eval-after-load "flyspell"
  '(defun flyspell-mode (&optional arg)))

(add-to-list 'TeX-command-list'("Make full" "%`%l%(mode)%' %t; dvips -o %s.ps %s.dvi && ps2pdf %s.ps" TeX-run-TeX t t :help "Run latex dvips ps2pdf"))
