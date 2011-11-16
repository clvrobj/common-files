(custom-set-variables
 '(safe-local-variable-values (quote ((encoding . utf8), (encoding . utf-8)))))

(column-number-mode t)

;;%b is buffer name
;;(setq frame-title-format "Emacs of ZhangC - %b")

;; format title bar to show full path of current file
(setq-default frame-title-format
	      (list '((buffer-file-name " %f"
					(dired-directory
					 dired-directory
					 (revert-buffer-function " %b"
								 ("%b - Dir:  " default-directory)))))))

;; auto indent
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
	   (and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode
						     clojure-mode    scheme-mode
						     haskell-mode    ruby-mode
						     rspec-mode      python-mode
						     c-mode          c++-mode
						     objc-mode       latex-mode
						     plain-tex-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
		  (indent-region (region-beginning) (region-end) nil))))))


(add-to-list 'load-path "~/.emacs.d/plugins/")

(add-to-list 'load-path "~/.emacs.d/plugins/js2.el")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode) ;; Auto-start on any markup modes

(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/emacs-goodies-el"))
(require 'emacs-goodies-el)

(require 'color-theme)
;;(color-theme-bharadwaj-slate)
(color-theme-calm-forest)
;;(color-theme-blue-mood)

;; snippet
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")
;; auto complete [{ pair
(require 'autopair)
(add-hook 'python-mode-hook #'(lambda () (autopair-mode))) ;; only python mode
;;(autopair-global-mode) ;; enable autopair in all buffers

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

(require 'highlight-80+)

(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
(setq ac-dwim t)

;;(require 'psvn)

(require 'nav)

(global-set-key (kbd "M-3") 'grep-find)
(setq grep-find-command
      "find . '(' -path '*/.svn' -o -path '*/.hg' ')' -prune -o -type f -print0 | xargs -0 grep -in ")

;; buffer move between windows
(require 'buffer-move)
;; (global-set-key (kbd "<C-S-left>")   'buf-move-left)
;; (global-set-key (kbd "<C-S-right>")  'buf-move-right)

;;;; display time
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

;;;; tab to spaces
(setq c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list nil)

(setq make-backup-files nil)

;; remove tool bar conflict with maxize
;;(tool-bar-mode 0)
;;(scroll-bar-mode nil)

(require 'mwheel)

(mouse-avoidance-mode 'animate)
(setq mouse-avoidance-mode 'animate)

(global-set-key [(f3)] 'dired)

;;;; speed bar
;;(global-set-key [(f5)] 'speedbar)
;;
(global-set-key (kbd "M-s") 'speedbar-get-focus)

;;;; compiler
;;(setq added-path "D:\\ProgramFiles\\Qt\\2009.05\\mingw\\bin\\;")
;;(setq original-path (getenv "PATH"))
;;(setenv "PATH" (message "%s%s" added-path original-path))

;;;;bash
(setq added-path "/opt/local/bin:/opt/local/sbin:")
(setq original-path (getenv "PATH"))
(setenv "PATH" (message "%s%s" added-path original-path))

;;;; make res scroll
(setq compilation-scroll-output t)

;;;; open shell for running app
(global-set-key (kbd "M-1") 'shell-command)

;; store the emacs state
(desktop-save-mode 1)

(setq auto-save-timeout 900)

;;;; maximum when start
(defun emacs-maximize ()
  "Maximize emacs window in windows os"
  (interactive)
  (w32-send-sys-command 61488))        ; WM_SYSCOMMAND #xf030 maximize
(defun emacs-minimize ()
  "Minimize emacs window in windows os"
  (interactive)
  (w32-send-sys-command #xf020))    ; #xf020 minimize
(defun emacs-normal ()
  "Normal emacs window in windows os"
  (interactive)
  (w32-send-sys-command #xf120))    ; #xf120 normalimize

;; set window position
(setq default-frame-alist
      '(
        (top . 0)
        (left . 8) ;; dock shown at left (55)
        (height . 80)
        (width . 220)
        ))

;; scoll just 3 lines not all the screen
(setq scroll-margin 3
      scroll-conservatively 10000)

;; high light the match parentheses but not auto move the cursor
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(show-paren-mode 1)

(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-x\C-r" 'revert-buffer) ;; reload buffer
(fset 'yes-or-no-p 'y-or-n-p) ;; Make all yes-or-no questions as y-or-n

;; Moving lines up & down with <M-up> & <M-down>
(defun move-line (&optional n)
  "Move current line N (1) lines up/down leaving point in place."
  (interactive "p")
  (when (null n)
    (setq n 1))
  (let ((col (current-column)))
    (beginning-of-line)
    (forward-line)
    (transpose-lines n)
    (forward-line -1)
    (forward-char col))
  (indent-according-to-mode))

(defun move-line-up (n)
  "Moves current line N (1) lines up leaving point in place."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Moves current line N (1) lines down leaving point in place."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key [(meta up)]   'move-line-up)
(global-set-key [(meta down)] 'move-line-down)

;; duplicate current line insert to next line
(defun dup-line-down() 
  (interactive)

  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  ) 

(global-set-key (kbd "<C-M-down>")  'dup-line-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C/C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'c-mode-hook 'linux-c-mode)
(defun linux-c-mode()
  (define-key c-mode-map [return] 'newline-and-indent)
  ;; ctrl + c and c is compile
  (define-key c-mode-map [(control c) (c)] 'compile)
  (interactive)
  ;; algn {} as c classic style
  (c-set-style "K&R")
  ;; auto align the {} of your style ( notice: but this will auto start a new line, it's not good.)
  ;;(c-toggle-auto-state)
  ;; 4 spaces (should set this coz default is 5)
  (setq c-basic-offset 4)
  ;; delete more spaces when press backspace
  (c-toggle-hungry-state)
  ;; display function in menu bar
  (imenu-add-menubar-index)
  ;; display of which function now
  (which-function-mode)
  )

(add-hook 'c++-mode-hook 'linux-cpp-mode)
(defun linux-cpp-mode()
  (define-key c++-mode-map [return] 'newline-and-indent)
  ;; ctrl + c and c is compile
  (define-key c++-mode-map [(control c) (c)] 'compile)
  (interactive)
  ;; algn {} as c classic style
  (c-set-style "K&R")
  ;; auto align the {} of your style ( notice: but this will auto start a new line, it's not good.)
  ;;(c-toggle-auto-state)
  ;; 4 spaces (should set this coz default is 5)
  (setq c-basic-offset 4)
  ;; delete more spaces when press backspace
  (c-toggle-hungry-state)
  ;; display function in menu bar
  (imenu-add-menubar-index)
  ;; display of which function now
  (which-function-mode)
  )

;;(emacs-maximize)

(setq user-init-file (expand-file-name "~/emacs.d/init.el"))
