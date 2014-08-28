(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fill-column 120))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 90))))
 '(linum ((t (:inherit (shadow default) :background "white"))))
 '(mode-line ((t (:background "white" :foreground "brightblack" :box (:line-width -1 :style released-button))))))

; Show matching parentheses
(load-library "paren")
(show-paren-mode 1)

; Set window title
(setq frame-title-format '(buffer-file-name "%f - Emacs" "%b - Emacs"))

; Disable startup screen
(setq inhibit-startup-screen t)

; Use a single backup directory
(setq backup-directory-alist
'(("." . "~/.cache/emacs/backups")))

; Remember position in files
(setq save-place-file "~/.cache/emacs/saveplace") ;; keep my ~ clean
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package

; Disable backup
;(setq backup-inhibited t)

; Disable auto save
(setq auto-save-default nil)

; Show column and line numbers
(global-linum-mode 1)
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
(global-set-key [(tab)] 'smart-tab)
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

; Use trash
;(setq delete-by-moving-to-trash t)

; Allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote top))
(setq dired-recursive-deletes (quote top))
; “always” means no asking.
; “top” means ask once (top = top dir).
; any other symbol means ask each and every time for a dir and subdir.

; Show matching parentheses
(load-library "paren")
(show-paren-mode 1)

; Set window title
(setq frame-title-format '(buffer-file-name "%f - Emacs" "%b - Emacs"))

; Add the marmalade repo
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

; Add the MELPA repo
(require 'package)
(add-to-list 'package-archives 
    '("melpa" .
      "http://melpa.milkbox.net/packages/"))
(package-initialize)

; Disable the menu bar and the toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)

; Load the 'evil' (vim) mode
(add-to-list 'load-path "~/.emacs.d/evil") (require 'evil) (evil-mode 1)
(setq evil-motion-state-modes (append evil-emacs-state-modes evil-motion-state-modes))
   (setq evil-emacs-state-modes nil)

; Keybinding for switching to/from evil mode
(defun evil-toggle-input-method ()
      "when toggle on input method, switch to evil-insert-state if possible.
    when toggle off input method, switch to evil-normal-state if current state is evil-insert-state"
      (interactive)
      (if (not current-input-method)
          (if (not (string= evil-state "insert"))
              (evil-insert-state))
        (if (string= evil-state "insert")
            (evil-normal-state)
            ))
      (toggle-input-method))
    (global-set-key (kbd "C-\\") 'evil-toggle-input-method)
