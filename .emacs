;;; .emacs --- Config
;;; Commentary:

;;; Code:
(require 'package)
(require 'cl)
;; Set load path
(add-to-list 'load-path "~/.emacs.d/lisp/")
(if (fboundp 'normal-top-level-add-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/lisp/")
           (default-directory my-lisp-dir))
      (progn
        (setq load-path
              (append
               (loop for dir in (directory-files my-lisp-dir)
                     unless (string-match "^\\." dir)
                     collecting (expand-file-name dir))
               load-path)))))
;;(add-to-list 'package-archives 
;;    '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Easy key bindings
(require 'bind-key)

; Ido mode for cool things like opening files etc.
(require 'ido)
(ido-mode t)

;; add useful package lists
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
  '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
  '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

;; set up theme
(load-theme 'misterioso t)


;; Indent with spaces only
 (setq-default indent-tabs-mode nil)

;; Enable backup files.
(setq make-backup-files t)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))

;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)
(setq delete-old-versions -1)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))


;; Use neotree (in melpa list packages)
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-smart-open t)

;; Remove menubar
(menu-bar-mode -1)

;; === Mode line elements ===
;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Display time and date
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; Mode line setup
(setq-default
 mode-line-format
 '(; Position, including warning for 80 columns
   (:propertize "%4l:" face mode-line-position-face)
   (:eval (propertize "%3c" 'face
                      (if (>= (current-column) 80)
                          'mode-line-80col-face
                        'mode-line-position-face)))
   ; emacsclient [default -- keep?]
   mode-line-client
   "  "
   ; read-only or modified status
   (:eval
    (cond (buffer-read-only
           (propertize " RO " 'face 'mode-line-read-only-face))
          ((buffer-modified-p)
           (propertize " ** " 'face 'mode-line-modified-face))
          (t "      ")))
   "    "
   ; directory and buffer/file name
   (:propertize (:eval (shorten-directory default-directory 30))
                face mode-line-folder-face)
   (:propertize "%b"
                face mode-line-filename-face)
   ; narrow [default -- keep?]
   " %n "
   ; mode indicators: vc, recursive edit, major mode, minor modes, process, global
   (vc-mode vc-mode)
   "  %["
   (:propertize mode-name
                face mode-line-mode-face)
   "%] "
   (:eval (propertize (format-mode-line minor-mode-alist)
                      'face 'mode-line-minor-mode-face))
   (:propertize mode-line-process
                face mode-line-process-face)
   (global-mode-string global-mode-string)
   "    "
   ))

;; Helper function
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

;; Extra mode line faces
(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)

(set-face-attribute 'mode-line nil
    :foreground "gray60" :background "gray20"
    :inverse-video nil
    :box '(:line-width 6 :color "gray20" :style nil))
(set-face-attribute 'mode-line-inactive nil
    :foreground "gray80" :background "gray40"
    :inverse-video nil
    :box '(:line-width 6 :color "gray40" :style nil))

(set-face-attribute 'mode-line-read-only-face nil
    :inherit 'mode-line-face
    :foreground "#4271ae"
    :box '(:line-width 2 :color "#4271ae"))
(set-face-attribute 'mode-line-modified-face nil
;;; =======

    :inherit 'mode-line-face
    :foreground "#c82829"
    :background "#ffffff"
    :box '(:line-width 2 :color "#c82829"))
(set-face-attribute 'mode-line-folder-face nil
    :inherit 'mode-line-face
    :foreground "gray60")
(set-face-attribute 'mode-line-filename-face nil
    :inherit 'mode-line-face
    :foreground "#eab700"
    :weight 'bold)
(set-face-attribute 'mode-line-position-face nil
    :inherit 'mode-line-face
    :family "Menlo" :height 100)
(set-face-attribute 'mode-line-mode-face nil
    :inherit 'mode-line-face
    :foreground "gray80")
(set-face-attribute 'mode-line-minor-mode-face nil
    :inherit 'mode-line-mode-face
    :foreground "gray40"
    :height 110)
(set-face-attribute 'mode-line-process-face nil
    :inherit 'mode-line-face
    :foreground "#718c00")
(set-face-attribute 'mode-line-80col-face nil
    :inherit 'mode-line-position-face
    :foreground "black" :background "#eab700")

;; Scrolling on penultimate line and don't jump
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; Enable wheel and trackpad scrolling
(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Perl
(fset 'perl-mode 'cperl-mode) ;; force cperl mode

(defun my/cperl-mode-hooks ()
  (my/turn-on flymake-mode))

(add-hook 'cperl-mode-hook 'my/cperl-mode-hooks)

;; Auto Complete
;;(require 'fuzzy)
;;(require 'auto-complete)
;;(setq ac-auto-show-menu t
;;      ac-quick-help-delay 0.5
;;      ac-use-fuzzy t)
;;(global-auto-complete-mode +1)

;; smex
;; (global-set-key "\M-x" 'smex)

;; Sentences end with single space
(setq sentence-end-double-space nil)

;; Text size
(bind-key "C-+" 'text-scale-increase)
(bind-key "C--" 'text-scale-decrease)

;; Move up buffer
(bind-key "ESC <up>" 'other-window)



;; Rainbow delimiters
(set-variable 'frame-background-mode 'dark)
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; indent new lines
(global-set-key (kbd "RET") 'newline-and-indent)

;; Unbind pesky sleep button
(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])

;; Windows Style Undo
(global-set-key [(control z)] 'undo)

;; Switch buffers with Shift + Arrow



; key binfing to change window
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
(global-set-key "\M-[1;2A" 'windmove-up)
(global-set-key "\M-[1;2B" 'windmove-down)
(global-set-key "\M-[1;2C" 'windmove-right)
(global-set-key "\M-[1;2D" 'windmove-left)

;;; ===
;;; C++
;;; ===

;; Always open .h files in c++-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;; =====
;;; Magit
;;; =====
(bind-key "C-x g" 'magit-status)

;;; =======
;;; Latex
;;; =======

(setq latex-run-command "lualatex")


;allows to retrieve previous commands typed in shell
;(define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
;(define-key comint-mode-map (kbd "<down>") 'comint-next-input)
(defun scroll-history-translations (&optional frame)
  (require 'comint)
  (with-selected-frame (or frame (selected-frame))
    (define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
    (define-key comint-mode-map (kbd "<down>") 'comint-next-input)
    ))
;; Evaluate both now (for non-daemon emacs) and upon frame creation
;; (for new terminals via emacsclient).
(scroll-history-translations)
(add-hook 'after-make-frame-functions 'scroll-history-translations)


(define-key isearch-mode-map (kbd "<up>") 'isearch-ring-advance)
(define-key isearch-mode-map (kbd "<down>") 'isearch-ring-retreat)


; opens python when i run mX run-python
(setq python-shell-interpreter "ipython"
    python-shell-interpreter-args "--simple-prompt -i")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (neotree magit win-switch))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Allow hash to be entered  
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))


;;; =======
;;; Startup
(setq inhibit-startup-screen t)
(shell)
(delete-other-windows)
(split-window-right)

