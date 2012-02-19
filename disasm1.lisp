;;;; disasm1.lisp

(cl:in-package :disasm1-internal)

(def-suite disasm1)

(in-suite disasm1)

#+sbcl
(defun disasm (object &key
                (stream *standard-output*)
                (use-labels t) )
  (declare (type (or function symbol cons) object)
           (type (or (member t) stream) stream)
           (type (member t nil) use-labels) )
  (flet ((disassemble1 (fun)
           (format stream "~&; disassembly for ~S" (sb-kernel:%fun-name fun))
           (disasm-fun fun
                       :stream stream
                       :use-labels use-labels)))
    (let ((funs (sb-disassem::compiled-funs-or-lose object)))
      (if (listp funs)
          (dolist (fun funs) (disassemble1 fun))
          (disassemble1 funs) )))
  nil )

#-sbcl
(defun disasm (obj)
  (cl:disassemble obj))

(defun count-byte (string)
  (nth-value 0
    (floor (count-if (lambda (x) (digit-char-p x 16))
                     string)
           2)))
#+sbcl
(defun disasm-fun (fun &key stream (use-labels T))
  (let ((str (with-output-to-string (out)
               (sb-disassem:disassemble-fun fun
                                            :stream out
                                            :use-labels use-labels) ))
        (bytes 0)
        (sout (make-string-output-stream)))
    (fresh-line sout)
    (ppcre:do-register-groups
         (addr label insthex inst)
         (";\\s+([\\dA-F]+:)\\s(L\\d+:|\\s+)\\s+([\\dA-F]+)\\s+(.*)" str)
                (declare (ignore addr))
                (incf bytes (count-byte insthex))
                (unless (zerop (length (string-trim '(#\Space) label)))
                  (princ label sout))
                (format sout "~8T~A~%" inst))
    (format stream
            " (assembled ~D byte~:*~P)~%~A"
            bytes
            (get-output-stream-string sout))))

;;; eof
