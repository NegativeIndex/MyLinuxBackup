;; .emacs

;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; ;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
   (global-font-lock-mode t))

;; enable visual feedback on selections
   (setq transient-mark-mode t)

;; default to better frame titles
   (setq frame-title-format
         (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
   (setq diff-switches "-u")

;; set text mode as the default mode
   (setq default-major-mode 'text-mode)

;; always end a file with a newline
;; (setq require-final-newline 'query)

;; close welcome windows
(setq inhibit-startup-message t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search nil)
 '(cua-mode t nil (cua-base))
 '(current-language-environment "UTF-8")
 ;; '(custom-enabled-themes (quote (sanityinc-tomorrow-blue)))
 '(custom-safe-themes (quote ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" default)))
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(transient-mark-mode t))

(put 'set-goal-column 'disabled nil)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed t) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

; add C-x, C-c, C-v as cut copy paste
;; (require 'cua)
;; (CUA-mode t)

;;  add a new load-path
(setq load-path (append load-path (list "~/emacs_program" nil)))

;; change highlight color  
(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")

;; By default, tex-mode changes font for super- and sub- script. I don't like it.
(eval-after-load "tex-mode" '(fset 'tex-font-lock-suscript 'ignore))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Matlab-mode setup:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up matlab-mode to load on .m files
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)

;; Customization:
(setq matlab-indent-function t) ; if you want function bodies indented
(setq matlab-verify-on-save-flag nil) ; turn off auto-verify on save
(defun my-matlab-mode-hook ()
  (setq fill-column 76))                ; where auto-fill should wrap
(add-hook 'matlab-mode-hook 'my-matlab-mode-hook)
(defun my-matlab-shell-mode-hook ()
  '())
(add-hook 'matlab-shell-mode-hook 'my-matlab-shell-mode-hook)

;; Turn off Matlab desktop
(setq matlab-shell-command-switches '("-nojvm"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Matlab-mode end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;
;; Update file when it was modified elsewhere by F5
;; (global-auto-revert-mode 1)
 (global-set-key
  (kbd "<f5>")
  (lambda (&optional force-reverting)
    "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
    (interactive "P")
    ;;(message "force-reverting value is %s" force-reverting)
    (if (or force-reverting (not (buffer-modified-p)))
        (revert-buffer :ignore-auto )
      (error "The buffer has been modified"))))


;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
         (package-refresh-contents))


;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    rainbow-delimiters
    material-theme                  ;; Theme
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


;; rainbow-delimiters setting

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-unmatched-face ((t (:background "snow" :foreground "red"))))
 '(rainbow-delimiters-mismatched-face ((t (:background "snow" :foreground "red2"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1")))))

(add-hook 'python-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
;; Enable elpy
;; (elpy-enable)

; ===================================
;; end of MELPA Package Support
;; ===================================


;; load new functions
(load-file "~/emacs_program/my-date.el")
(load-file "~/emacs_program/list-filenames.el")
(load-file "~/emacs_program/delete-to-functions.el")

(global-set-key (kbd "C-<f12>") 'my-date) 
;; add hooks 
;; ;; .job file using sh-mode
;; ;; .ctl file using emacs-lisp-mode
;; ;; .emacs file using emacs-lisp-mode
;; ;; ;; add new surfix

;; (if (assoc "\\.job" auto-mode-alist)
;;      nil
;;         (nconc auto-mode-alist '(("\\.job" . sh-mode))))


(setq auto-mode-alist (cons '("\\.emacs\\'" . emacs-lisp-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.tex\\'" . latex-mode) auto-mode-alist))

;; ;; load new package
;; ;;
(defface hi-red-comm
   '((((min-colors 88)) (:weight bold :foreground "red1"))
     (t (:weight bold :foreground "red1")))
     "Face for hi-lock mode."
  :group 'hi-lock-faces)
(defface hi-red2-comm
  '((((min-colors 88)) (:weight bold :foreground "light coral"))
    (t (:weight bold :foreground "light coral")))
  "Face for hi-lock mode."
  :group 'hi-lock-faces)

(require 'hl-sections)
;; (add-hook 'python-mode-hook 'hl-sections-mode)
(add-hook 'python-mode-hook '(lambda () (highlight-lines-matching-regexp "^[ \t]*####" 'hi-red2-comm)))
(add-hook 'python-mode-hook '(lambda () (highlight-lines-matching-regexp "^[ \t]*######" 'hi-red-comm)))

;; ;; (add-hook 'matlab-mode-hook 'hl-sections-mode)
;; (add-hook 'matlab-mode-hook '(lambda () (highlight-lines-matching-regexp "^[ \t]*%%%%%" 'hi-red-my)))

;; activate org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(require 'org-bullets)
(add-hook 'org-mode-hook '(lambda () (org-bullets-mode 1)))

(setq org-directory "~/org")
 (setq org-default-notes-file "~/.notes")	
 (setq remember-annotation-functions '(org-remember-annotation))
 (setq remember-handler-functions '(org-remember-handler))
 (add-hook 'remember-mode-hook 'org-remember-apply-template)
 (define-key global-map "\C-cr" 'org-remember)
;; remember templats 
;; item type, shortcut(?t), content (%i is substitute), target file, headline 
(setq org-remember-templates
   '( ("Todo" ?t "* TODO %? %i %T\n " "~/org/todo.org" "Office note: ")   ))

(setq org-todo-keywords '((sequence "TODO" "STARTED" "WAITING" "|" "DONE" "CANCELLED")))




;; add themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)
;; (load-theme 'solarized-dark t)
;; (load-theme 'material t)
(tool-bar-mode -1)
;;


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
