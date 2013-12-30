;; zenburn theme
(when (>= emacs-major-version 24)
  (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
  (load-theme 'zenburn t)
)
(when (<= emacs-major-version 23)
  (load-file "~/.emacs.d/themes/zenburn-theme.el")
)

;; Highlight active buffer
(set-face-attribute  'mode-line
                 nil 
                 :foreground "gray50"
                 :background "gray15" 
                 :box '(:line-width 1 :style released-button))
(set-face-attribute  'mode-line-inactive
                 nil 
                 :foreground "gray80"
                 :background "gray25"
                 :box '(:line-width 1 :style released-button))

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

; font size
(set-face-attribute 'default nil :height 80)

; some spacing after line numbers when using emacs no window
(unless window-system
  (add-hook 'linum-before-numbering-hook
            (lambda ()
              (setq-local linum-format-fmt
                          (let ((w (length (number-to-string
                                            (count-lines (point-min) (point-max))))))
                            (concat "%" (number-to-string w) "d"))))))

(defun linum-format-func (line)
  (concat
   (propertize (format linum-format-fmt line) 'face 'linum)
   (propertize " " 'face 'linum)))

(unless window-system
  (setq linum-format 'linum-format-func))

