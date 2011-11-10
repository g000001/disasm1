;;;; disasm1.asd

(cl:in-package :asdf)

(defsystem :disasm1
  :serial t
  :depends-on (:cl-ppcre :swank :fiveam)
  :components ((:file "package")
               #+sbcl (:file "disasm1")
               (:file "slime-disasm")))

(defmethod perform ((o test-op) (c (eql (find-system :disasm1))))
  (load-system :disasm1)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :disasm1-internal :disasm1))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

