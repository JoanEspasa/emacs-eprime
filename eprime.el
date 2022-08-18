;;; eprime.el --- Support for the Essence Prime modelling language  -*- lexical-binding: t; -*-
;;
;; Author: Joan Espasa Arxer
;; Created: 17 Aug 2022
;;
;; Keywords: languages
;; URL: https://github.com/JoanEspasa/emacs-eprime
;; This file is not part of GNU Emacs.
;;
;; Commentary: For now it only adds a simple syntax highlighting to eprime and param files.
;; but much more could be done: keybindings to run savile row automatically, indentation, etc ...
;; based on the tutorial https://www.emacswiki.org/emacs/ModeTutorial
;;
;; Code:
;; ‘eprime-mode-hook’ allows the user to run their own code when your mode is run.
(defvar eprime-mode-hook nil)

;; Custom keymap for the mode. For now its "empty", as "C-j" is already the default for newline
;; and indent. In case of very few entries, it might be beneficial to use "make-sparse-keymap"
;; instead of "make-keymap"
(defvar eprime-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for eprime major mode")

;; autoload this when opening eprime or param files
(add-to-list 'auto-mode-alist '("\\.eprime\\'" . eprime-mode))
(add-to-list 'auto-mode-alist '("\\.param\\'" . eprime-mode))

;; specify all essence prime keywords
(defvar eprime-font-lock-keywords
      (let* (
             ;; define several category of keywords
             (x-keywords '("such" "that" "letting" "given" "in" "where" "find" "language" "LANGUAGE" "domain" "indexed" "by"))
             (x-types '("int" "bool" "matrix"))
             (x-constants '("true" "false"))
             (x-events '("matrix" "union" "intersect"))
             (x-functions '("forall" "forAll" "exists" "sum" "min" "max" "<=lex" "<lex" ">lex" ">=lex" "allDiff" "gcc" "table" "print"))

             ;; generate regex string for each category of keywords
             (x-keywords-regexp (regexp-opt x-keywords 'words))
             (x-types-regexp (regexp-opt x-types 'words))
             (x-constants-regexp (regexp-opt x-constants 'words))
             (x-events-regexp (regexp-opt x-events 'words))
             (x-functions-regexp (regexp-opt x-functions 'words)))

        `(
          (,x-types-regexp . 'font-lock-type-face)
          (,x-constants-regexp . 'font-lock-constant-face)
          (,x-events-regexp . 'font-lock-builtin-face)
          (,x-functions-regexp . 'font-lock-function-name-face)
          (,x-keywords-regexp . 'font-lock-keyword-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;; define the syntax table, telling Emacs how to parse our tokens
(defvar eprime-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st) ; we treat foo_bar as one word instead of two
                                        ; lets configure comments in eprime
                                        ; https://www.gnu.org/software/emacs/manual/html_node/elisp/Syntax-Class-Table.html
    (modify-syntax-entry ?$ "<" st) ; start of comment
    (modify-syntax-entry ?\n ">" st) ; end of comment
    st)
  "Syntax table for eprime-mode")

; we inherit from fundamental mode, so its cleaner
(define-derived-mode eprime-mode fundamental-mode "Essence Prime"
  "Major mode for editing Essence Prime Language files"
  (set (make-local-variable 'font-lock-defaults) '(eprime-font-lock-keywords)))

; add symbol name to features list
(provide 'eprime-mode)

;; eprime.el ends here
