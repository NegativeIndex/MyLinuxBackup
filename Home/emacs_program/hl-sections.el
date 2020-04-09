;; highlight current section defined by a long line of comment delimiters


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'hl-line) ;; global-hl-line-highlight, global-hl-line-mode,
                   ;; global-hl-line-overlay, global-hl-line-unhighlight,
                   ;; hl-line-face, hl-line-highlight, hl-line-mode,
                   ;; hl-line-overlay, hl-line-range-function, 
                   ;; hl-line-sticky-flag,
                   ;; hl-line-unhighlight.

(defvar hl-line-face)                   ; Quiet the byte-compiler.
(defvar global-hl-line-mode)            ; Quiet the byte-compiler.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
;;; old background color is lavender 
(defface hl-sections
  '((t :inherit highlight :background "#101635"))
  "*Face for the sections in Hl-Line-Window mode."
  :group 'hl-line)

(defvar hl-sections-old-state nil
  "Saved Hl-Line mode values, before `hl-sections-mode'.")

;; magic happens here
(defun hl-sections-limits (delimiter-string)
  "Return a cons of the limits to use for `hl-line-range-function'."
  (let ( (start 0) (end 0) )
    (save-excursion 
      (end-of-line)
      (setq end (re-search-forward delimiter-string nil t)))
  (save-excursion 
     (end-of-line)
     (setq start (re-search-backward delimiter-string nil t)))
  (unless start (setq start (point-min)))
  (if end
      (save-excursion
	(goto-char end)
	(setq end (line-beginning-position) ) )
    (setq end (point-max)))
   (cons start end)))

;;;###autoload
 (define-minor-mode hl-sections-mode
  "A minor mode to highlight area between defined "
  :group 'hl-line
  (setq delimiter-string "^[ \t]*")
  (dotimes (i 2) 
    (setq delimiter-string (concat delimiter-string 
				   (substring comment-start 0 1))))
  
  ;; (setq delimiter-string 
  ;; 	;; (concat "^" comment-start comment-start comment-start 
  ;; 	;; 	comment-start comment-start ))

  ;; ;; search forward and backward to find delimiter string
  (cond (hl-sections-mode   ; the mode is on 
  	 (unless hl-sections-old-state
	   (message "hl-sections mode enabled. Delimiter is %s" 
		    delimiter-string)
           (setq hl-sections-old-state  (list hl-line-face
                                               hl-line-overlay
                                               global-hl-line-overlay
                                               hl-line-range-function)))
  	 (hl-line-unhighlight)
         (setq hl-line-overlay         nil
               hl-line-face            'hl-sections
               hl-line-range-function  
	          (lambda () (hl-sections-limits delimiter-string))
               hl-line-sticky-flag     nil)
	 ;; In case `kill-all-local-variables' is called.
         (add-hook 'change-major-mode-hook #'hl-line-unhighlight nil t)   
	 (if hl-line-sticky-flag
             (remove-hook 'pre-command-hook #'hl-line-unhighlight t)
           (add-hook 'pre-command-hook #'hl-line-unhighlight nil t))
         (add-hook 'post-command-hook #'hl-line-highlight nil t))
	(t
	 (setq hl-line-face             (nth 0 hl-sections-old-state)
               hl-line-overlay          (nth 1 hl-sections-old-state)
               global-hl-line-overlay   (nth 2 hl-sections-old-state)
               hl-line-range-function   (nth 3 hl-sections-old-state)
               hl-line-sticky-flag      (nth 4 hl-sections-old-state))
         (when hl-sections-old-state (setq hl-sections-old-state nil))
         (remove-hook 'post-command-hook #'hl-line-highlight t)
         (hl-line-unhighlight)
         (remove-hook 'change-major-mode-hook #'hl-line-unhighlight t)
         (remove-hook 'pre-command-hook #'hl-line-unhighlight t))
	)   
  (hl-line-mode (if hl-sections-mode 1 -1)))


(provide 'hl-sections)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hl-sections.el ends here
