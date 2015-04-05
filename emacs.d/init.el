(package-initialize)

;(require 'org-drill)

;; shortcuts
(global-set-key "\C-cl" 'goto-line)

;; --------------------------------------------------
;; OCaml Configuration
;; --------------------------------------------------

;;  - better error and backtrace matching
(defun set-ocaml-error-regexp ()
  (set
   'compilation-error-regexp-alist
   (list '("[Ff]ile \\(\"\\(.*?\\)\", line \\(-?[0-9]+\\)\\(, characters \\(-?[0-9]+\\)-\\([0-9]+\\)\\)?\\)\\(:\n\\(\\(Warning .*?\\)\\|\\(Error\\)\\):\\)?"
    2 3 (5 . 6) (9 . 11) 1 (8 compilation-message-face)))))

(add-hook 'tuareg-mode-hook 'set-ocaml-error-regexp)
(add-hook 'ocaml-mode-hook 'set-ocaml-error-regexp)

(defun opam-shell-command-to-string (command)
  "Similar to shell-command-to-string, but returns nil unless the process
  returned 0 (shell-command-to-string ignores return value)"
  (let* ((return-value 0)
         (return-string
          (with-output-to-string
            (setq return-value
                  (with-current-buffer standard-output
                    (process-file shell-file-name nil t nil
                                  shell-command-switch command))))))
    (if (= return-value 0) return-string nil)))

(defun opam-update-env ()
  "Update the environment to follow current OPAM switch configuration"
  (interactive)
  (let ((env (opam-shell-command-to-string "opam config env --sexp")))
    (when env
      (dolist (var (car (read-from-string env)))
        (setenv (car var) (cadr var))
        (when (string= (car var) "PATH")
          (setq exec-path (split-string (cadr var) path-separator)))))))

(opam-update-env)

(setq opam-share
  (let ((reply (opam-shell-command-to-string "opam config var share")))
    (when reply (substring reply 0 -1))))

;; Make sure we load from opam
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

;; OPAM-installed tools automated detection and initialisation
(defun opam-setup-tuareg ()
  (add-to-list 'load-path (concat opam-share "/tuareg") t)
  (load "tuareg-site-file"))

(defun opam-setup-ocp-indent ()
  (require 'ocp-indent))

(defun opam-setup-ocp-index ()
  (require 'ocp-index))

(defun opam-setup-merlin ()
  (require 'merlin)
  (add-hook 'tuareg-mode-hook 'merlin-mode t)
  (add-hook 'caml-mode-hook 'merlin-mode t)
  (set-default 'ocp-index-use-auto-complete nil)
  (set-default 'merlin-use-auto-complete-mode 'easy)
  ;; So you can do it on a mac, where `C-<up>` and `C-<down>` are used
  ;; by spaces.
  (define-key merlin-mode-map
    (kbd "C-c <up>") 'merlin-type-enclosing-go-up)
  (define-key merlin-mode-map
    (kbd "C-c <down>") 'merlin-type-enclosing-go-down)
  (set-face-background 'merlin-type-face "skyblue"))

(defun opam-setup-utop ()
  (autoload 'utop "utop" "Toplevel for OCaml" t)
  (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
  (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer))

(setq opam-tools
  '(("tuareg" . opam-setup-tuareg)
    ("ocp-indent" . opam-setup-ocp-indent)
    ("ocp-index" . opam-setup-ocp-index)
    ("merlin" . opam-setup-merlin)
    ("utop" . opam-setup-utop)))

(defun opam-detect-installed-tools ()
  (let*
      ((command "opam list --installed --short --safe --color=never")
       (names (mapcar 'car opam-tools))
       (command-string (mapconcat 'identity (cons command names) " "))
       (reply (opam-shell-command-to-string command-string)))
    (when reply (split-string reply))))

(setq opam-tools-installed (opam-detect-installed-tools))

(defun opam-auto-tools-setup ()
  (interactive)
  (dolist
      (f (mapcar (lambda (x) (cdr (assoc x opam-tools))) opam-tools-installed))
    (funcall (symbol-function f))))

(opam-auto-tools-setup)

;; (defun opam-path (path)
;;   (let ((opam-share-dir
;;          (shell-command-to-string
;;           "echo -n `opam config var share`")))
;;     (concat opam-share-dir "/" path)))

;; (add-to-list 'load-path (opam-path "emacs/site-lisp"))
;; (add-to-list 'load-path (opam-path "tuareg"))

;; (load "tuareg-site-file")

;; (require 'ocp-indent)
;; (require 'merlin)

;; (setq merlin-use-auto-complete-mode 'easy)
;; ;(setq tuareg-font-lock-symbols t)
;; (setq merlin-command 'opam)

;; (defun ocp-indent-buffer ()
;;   (interactive)
;;   (save-excursion
;;     (mark-whole-buffer)
;;     (ocp-indent-region (region-beginning)
;;                        (region-end))))

;; (add-hook 'tuareg-mode-hook
;;           (lambda ()
;;             (merlin-mode)
;;             (auto-complete-mode 1)
;;             (local-set-key (kbd "C-c c") 'recompile)
;;             (local-set-key (kbd "C-c C-c") 'recompile)
;;             (auto-fill-mode)
;;             (add-hook 'before-save-hook 'ocp-indent-buffer nil t)))

;; (provide 'ocaml)

;;  (setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-command-list
   (quote
    (("TeX" "%(PDF)%(tex) %(extraopts) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (plain-tex-mode texinfo-mode ams-tex-mode)
      :help "Run plain TeX")
     ("LaTeX" "%`%l%(mode)%' %t" TeX-run-TeX nil
      (latex-mode doctex-mode)
      :help "Run LaTeX")
     ("Makeinfo" "makeinfo %(extraopts) %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with Info output")
     ("Makeinfo HTML" "makeinfo %(extraopts) --html %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with HTML output")
     ("AmSTeX" "%(PDF)amstex %(extraopts) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (ams-tex-mode)
      :help "Run AMSTeX")
     ("ConTeXt" "texexec --once --texutil %(extraopts) %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt once")
     ("ConTeXt Full" "texexec %(extraopts) %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt until completion")
     ("BibTeX" "bibtex %s" TeX-run-BibTeX nil t :help "Run BibTeX")
     ("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber")
     ("View" "%V" TeX-run-discard-or-function nil t :help "Run Viewer")
     ("Print" "%p" TeX-run-command t t :help "Print the file")
     ("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command)
     ("File" "%(o?)dvips %d -o %f " TeX-run-command t t :help "Generate PostScript file")
     ("Index" "makeindex %s" TeX-run-command nil t :help "Create index file")
     ("Xindy" "texindy %s" TeX-run-command nil t :help "Run xindy to create index file")
     ("Check" "lacheck %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for correctness")
     ("ChkTeX" "chktex -v6 %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for common mistakes")
     ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document")
     ("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files")
     ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files")
     ("Other" "" TeX-run-command t t :help "Run an arbitrary command"))))
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (deeper-blue)))
 '(custom-safe-themes
   (quote
    ("1c50040ec3b3480b1fec3a0e912cac1eb011c27dd16d087d61e72054685de345" "0820d191ae80dcadc1802b3499f84c07a09803f2cb90b343678bdb03d225b26b" "cd03a600a5f470994ba01dd3d1ff52d5809b59b4a37357fa94ca50a6f7f07473" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(explicit-bash-args (quote ("--login" "-i")))
 '(fci-rule-color "#073642")
 '(flyspell-issue-message-flag nil)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-default-init nil)
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(make-backup-files nil)
 '(markdown-command "pandoc --smart -f markdown -t html")
 '(menu-bar-mode nil)
 '(merlin-use-auto-complete-mode (quote easy))
 '(nyan-mode nil)
 '(org-babel-load-languages (quote ((emacs-lisp . t) (python . t) (sh . t))))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m org-drill)))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")
     ("org" . "http://orgmode.org/elpa/"))))
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(tab-width 2)
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c85d17")
     (60 . "#be730b")
     (80 . "#b58900")
     (100 . "#a58e00")
     (120 . "#9d9100")
     (140 . "#959300")
     (160 . "#8d9600")
     (180 . "#859900")
     (200 . "#669b32")
     (220 . "#579d4c")
     (240 . "#489e65")
     (260 . "#399f7e")
     (280 . "#2aa198")
     (300 . "#2898af")
     (320 . "#2793ba")
     (340 . "#268fc6")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "nil" :family "DejaVu Sans Mono")))))


;; Setup environment variables using opam
(dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
  (setenv (car var) (cadr var)))

;; Update the emacs path
(setq exec-path (append (parse-colon-path (getenv "PATH"))
                        (list exec-directory)))

;; Update the emacs load path
(add-to-list 'load-path (expand-file-name "../../share/emacs/site-lisp"
                                          (getenv "OCAML_TOPLEVEL_PATH")))

;; Automatically load utop.el
(autoload 'utop "utop" "Toplevel for OCaml" t)


;; AucTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)
 
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
 
;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))


;; This is a little custom function that can be used to
;; "undo" autofill by refilling everything to one line
(defun refill-paragraphs-to-be-one-line ()
  "fill individual paragraphs with large fill column"
  (interactive)
  (let ((fill-column 100000))
    (fill-individual-paragraphs (point-min) (point-max))))


;; In docview mode, creates key bindings so that M-[ and M-]
;; move forward and backward while keeping your cursor within
;; the buffer. useful for reviewing papers so you can write notes
;; as you read.  Taken from
;; http://www.idryman.org/blog/2013/05/20/emacs-and-pdf/
(fset 'doc-prev "\C-xo\C-x[\C-xo")
(fset 'doc-next "\C-xo\C-x]\C-xo")
(global-set-key (kbd "M-[") 'doc-prev)
(global-set-key (kbd "M-]") 'doc-next)


;(require 'org-beautify-theme)
