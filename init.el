;; Put it in `~/.emacs.d/init.el` to use it for your
;; own Emacs. You can use as many or as few of these settings as
;; you would like. Experiment and try to find a set-up that suits
;; you!
;;
;; Some settings in this file are commented out. They are the ones
;; that require some choice of parameter (such as a color) or that
;; might be considered more intrusive than other settings (such as
;; linum-mode).
;;
;; Whenever you come across something that looks like this
;;
;;    (global-set-key (kbd "C-e") 'move-end-of-line)
;;
;; it is a command that sets the keyboard shortcut for some
;; function. If you find a function that you like, whose keyboard
;; shortcut you don't like, you can (and should!) always change it to
;; something that you do like.


;; ====================================
;; Add repositories / config package.el
;; ====================================
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("org" . "HTTP://orgmode.org/elpa/"))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


;; ============================================
;; Add function to check if package is
;; installed and if not automatically
;; install missing package
;; (http://stackoverflow.com/questions/10092322)
;; =============================================
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; ===========================
;; Activate installed packages
;; ===========================
(package-initialize)

;; ================================
;; Update package list
;; =================================
;(package-refresh-contents)

;; ===========
;; Appearance
;; ===========

;; Disable the menu bar (2013-08-20)
(menu-bar-mode -1)

;; Disable the tool bar (2013-08-20)
(tool-bar-mode -1)

;; Disable the scroll bar (2013-08-20)
(scroll-bar-mode -1)

;; Turn off annoying splash screen (2013-08-20)
(setq inhibit-splash-screen t)

;; Set which colors to use (2013-08-20)
;; You can see a list of all the available colors by checking the
;; variable "color-name-rgb-alist" (Type "C-h v color-name-rgb-alist
;; <RET>"). Most normal color names work, like black, white, red,
;; green, blue, etc.
; (set-background-color "black")
; (set-foreground-color "white")
; (set-cursor-color "white")

;; ================================
;; Check if packages are installed
;; ================================
(ensure-package-installed 
 'multiple-cursors 
 'autopair 'yasnippet 
 'auto-complete 
 'rust-mode 
 'markdown-mode 
 'toml-mode
 'fill-column-indicator
 'visual-regexp
 'linum-relative
 'indent-guide
 'imenu-anywhere
 'flycheck
 'monokai-theme
 'smart-mode-line
 'smart-mode-line-powerline-theme)
;; 'solarized-theme)


;; ================================
;; Add custom theme paths
;; ================================
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/solarized")

;; Set a custom color theme (2013-08-20)
;; NB! Needs Emacs 24.X!
;; You can also try using a custom theme, which changes more colors
;; than just the three above. For a list of all available themes,
;; press "M-x customize-themes <RET>". You can also use a theme in
;; combination with the above set-color-commands.
; (load-theme 'wombat) 
(load-theme 'monokai t)

;; ===========
;; mode line
;; ===========
(setq powerline-color1 "#ff0000")
(setq powerline-color2 "grey40")
(setq powerline-arrow-shape 'arrow)
(setq powerline-default-separator-dir '(right . left))
;; These two lines you really need.
(setq sml/theme 'powerline)
(setq sml/no-confirm-load-theme t)
(sml/setup)


;; ===========
;; Navigation
;; ===========

;; Show both line and column number in the bottom of the buffer (2013-08-20)
(column-number-mode t)

;; Show parenthesis matching the one below the cursor (2013-08-20)
(show-paren-mode t)

;; Show line numbers to the left of all buffers (2014-09-09)
(setq linum-format "%4d \u2502 ")
(global-linum-mode t)

;; Sentences are not followed by two spaces (2014-08-26)
;; Makes navigating with M-e and M-a (forward/backward senctence)
;; behave like you would expect
(setq sentence-end-double-space nil)

;; C-SPC after C-u C-SPC cycles mark stack (2013-08-20)
(setq-default set-mark-command-repeat-pop t)

;; Save-place (2013-08-20)
;; Remember the cursor position when you close a file, so that you
;; start with the cursor in the same position when opening it again
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;; Recent files (2013-08-20)
;; Enable a command to list your most recently edited files. If you
;; know you are opening a file that you have edited recently, this
;; should be faster than using find-file ("C-x C-f"). The code below
;; binds this to the keyboard shortcut "C-x C-r", which replaces the
;; shortcut for the command find-file-read-only.
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)


;; ===========
;; Editing
;; ===========

;; Allow deletion of selected text with <DEL> (2013-08-20)
(delete-selection-mode 1)

;; Use multiple spaces instead of tab characters (2013-08-20)
(setq-default indent-tabs-mode nil)

;; hippie-expand instead of dabbrev-expand (2013-08-20)
;; dabbrev-expand will try to expand the word under the cursor by
;; searching your open buffers for words beginning with the same
;; characters. For example, if you have written "printf" in an open
;; buffer you can just write "pr" and expand it to the full
;; word. hippie-expand does the same kind of search, plus some
;; additional searching, such as in your kill ring or the names of the
;; files you have open.
(global-set-key (kbd "M-/") 'hippie-expand)

;; =======================
;; SET TEMPORARY FOLDER
;; =======================
;; Save all tempfiles in $TMPDIR/emacs$UID/                                                        
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)


;; ==================================
;; Third party package settings
;; ==================================

;; Fill column indicator
(require 'fill-column-indicator)
(setq fci-rule-width 1)

;; Multiple cursors
;;
(require 'multiple-cursors)

(global-set-key (kbd "C-x C-\\") 'mc/mark-next-like-this)
(global-set-key (kbd "C-x C-]") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-\\") 'mc/mark-all-like-this)


;; Automatically add closing bracket
(require 'autopair)
(autopair-global-mode 1)
(setq autopair-mode t)

;; Yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"         ;; personal snippets
        "~/.emacs.d/yas-snippets"     ;; official snippets
        ))
(yas-global-mode 1)

;; Autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;; set trigger key so that it can work with yasnippet on tab key,
;; if the word exists in yasnippet, pressing tab will cause yasnippet
;; to activate, otherwise autocomplete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(ac-linum-workaround)

;; Visual regex
(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)

;; Linum relative
(require 'linum-relative)
(setq linum-relative-current-symbol  "0")
(setq linum-relative-format "%4s \u2502 ")

(global-set-key (kbd "C-c C-l") 'linum-relative-toggle)

;; Indent guide
;;(require 'indent-guide)
;;(indent-guide-global-mode)
;;(set-face-background 'indent-guide-face "dimgray")
;;(setq indent-guide-delay 0.1)
;;(setq indent-guide-recursive t) ;; show all levels of indentation
;;(setq indent-guide-char ":") ;; Custom indent char

;; Imenu-Anywhere
;; Language-aware navigation
(require 'imenu-anywhere)
;; Load custom menus
(setq imenu-auto-rescan t)
(global-set-key (kbd "C-c M-.") 'imenu-anywhere)

;; Flycheck
;;(require 'flycheck)
;;(global-flycheck-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
