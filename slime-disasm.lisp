(in-package :swank)

(defslimefun disasm-form (form)
  (with-buffer-syntax ()
    (with-output-to-string (*standard-output*)
      (let ((*print-readably* nil))
        (disasm1:disasm (eval (read-from-string form)))))))