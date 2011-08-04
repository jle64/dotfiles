(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fill-column 120)
 '(global-linum-mode 1))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:height 90)))))

; Theme for graphic mode only
;(require 'color-theme)
;(if window-system
;    (color-theme-resolve))

; Disable startup screen
(setq inhibit-startup-screen t)

; Use a single backup directory
(setq backup-directory-alist
'(("." . "~/.emacs-backups/")))

; Disable backup
;(setq backup-inhibited t)

; Disable auto save
(setq auto-save-default nil)

; Show column and line numbers
(column-number-mode 1)
(line-number-mode 1)

; Delete whitespaces at end of lines
(autoload 'nuke-trailing-whitespace "whitespace" nil t)

; Disable american-style double space at end of sentences
(setq sentence-end-double-space nil)

; Set french dictionnary for ispell
(setq ispell-dictionary "francais")

; Set european behavior for calendar
(setq european-calendar-style t)
(setq calendar-week-start-day 1)

; Use y or n instead of yes or no
(fset 'yes-or-no-p 'y-or-n-p)

; Delete selection when typing
(delete-selection-mode t)

; Simple auto-complete with tab
;(global-set-key [(tab)] 'smart-tab)
(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
        (dabbrev-expand nil))
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))
      (if (looking-at "\\_>")
          (dabbrev-expand nil)
        (indent-for-tab-command)))))

; Python auto-completion (need Pysmell)
;(require 'pysmell)
;(add-hook 'python-mode-hook (lambda () (pysmell-mode 1)))

; Tab bar
;(tabbar-mode)

; Transparency
(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

 ;; C-8 will increase opacity (== decrease transparency)
 ;; C-9 will decrease opacity (== increase transparency
 ;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

; Use trash
;(setq delete-by-moving-to-trash t)

;; allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))
;; “always” means no asking.
;; “top” means ask once (top = top dir).
;; any other symbol means ask each and every time for a dir and subdir.

