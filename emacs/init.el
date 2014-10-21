(package-initialize)

     
(global-set-key "\C-cl" 'goto-line)

;; OCaml setup

(defun opam-path (path) 
  (let ((opam-share-dir 
         (shell-command-to-string "echo -n `opam config var share`")))
    (concat opam-share-dir "/" path)))

(add-to-list 'load-path (opam-path "emacs/site-lisp"))
(add-to-list 'load-path (opam-path "tuareg"))
(load "tuareg-site-file")
(require 'merlin)
(require 'ocp-indent)
(require 'ocp-index)

(add-hook 'tuareg-mode-hook
          (lambda ()
            (merlin-mode)
            (local-set-key (kdb "C-c c") 'recompile)
            (local-set-key (kdb "C-c C-c") 'recompile)
            (auto-file-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(flyspell-issue-message-flag nil)
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-default-init nil)
 '(inhibit-startup-screen t)
 '(magit-use-overlays nil)
 '(make-backup-files nil)
 '(markdown-command "pandoc --smart -f markdown -t html")
 '(menu-bar-mode nil)
 '(nyan-mode nil)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "nil" :family "DejaVu Sans Mono")))))
