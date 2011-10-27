(defun slime-disasm-symbol (symbol-name)
  "Display the disassembly for SYMBOL-NAME."
  (interactive (list (slime-read-symbol-name "Disassemble: ")))
  (slime-eval-asm-describe `(swank:disasm-form ,(concat "'" symbol-name))))

(defun slime-show-asm-description (string package)
  (let ((bufname (slime-buffer-name :description)))
    (slime-with-popup-buffer (bufname :package package
                                      :connection t
                                      :select slime-description-autofocus
                                      :mode 'asm-mode)
      (princ string)
      (goto-char (point-min)))))

(defun slime-eval-asm-describe (form)
  "Evaluate FORM in Lisp and display the result in a new buffer."
  (slime-eval-async form (slime-rcurry #'slime-show-asm-description
                                       (slime-current-package))))