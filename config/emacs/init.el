(custom-set-variables
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(column-number-mode t)
 '(custom-safe-themes
   '("fe1682ca8f7a255cf295e76b0361438a21bb657d8846a05d9904872aa2fb86f2" default))
 '(fill-column 100)
 '(package-selected-packages
   '(powerline magit gruvbox-theme smart-mode-line-powerline-theme powerline-evil graphene))
 '(show-paren-mode t)
 '(tool-bar-mode nil))

; Default font size
(set-face-attribute 'default nil :height 125)

; Set window size at startup
(when window-system (set-frame-size (selected-frame) 80 24))

; Show matching parentheses
(load-library "paren")
(show-paren-mode 1)

; Set window title
(setq frame-title-format '(buffer-file-name "%f - Emacs" "%b - Emacs"))

; Disable startup screen
(setq inhibit-startup-screen t)

; Remember history of mini buffer and other stuff
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

; Remember position in files
(save-place-mode 1)

; Disable backup
(setq backup-inhibited t)

; Disable auto save
(setq auto-save-default nil)

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
(setq delete-by-moving-to-trash t)

; Allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote top))
(setq dired-recursive-deletes (quote top))
; “always” means no asking.
; “top” means ask once (top = top dir).
; any other symbol means ask each and every time for a dir and subdir.

; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)

; Enable dired extra features
(require 'dired-x)

; Show matching parentheses
(load-library "paren")
(show-paren-mode 1)

; Set window title
(setq frame-title-format '(buffer-file-name "%f - Emacs" "%b - Emacs"))

;; Add the marmalade repo
(require 'package)
(add-to-list 'package-archives 
             '("marmalade" . "https://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

; Disable the menu bar and the toolbar
; (menu-bar-mode -1)
(tool-bar-mode -1)

; Load the 'evil' (vim) mode
(require 'evil) (evil-mode 0)
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

; Load stuff in ~/.emacs.d/lisp/
(add-to-list 'load-path "~/.config/emacs/lisp")

; Load dirtree
(autoload 'dirtree "dirtree" "Add directory to tree view" t)
; Make it work with eproject
(defun ep-dirtree ()
  (interactive)
  (dirtree-in-buffer eproject-root t))

; Load theme
(load-theme 'deeper-blue t)

; Faster than scp
(setq tramp-default-method "ssh")

(require 'powerline)
(powerline-center-theme)
