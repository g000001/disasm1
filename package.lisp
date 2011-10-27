;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :disasm1
  (:use)
  (:export :disasm))

(defpackage :disasm1-internal
  (:use :disasm1 :cl :fiveam))

