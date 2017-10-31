(package-initialize)
(require 'package)
(org-babel-load-file "~/.emacs.d/dbrumley.org")
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (exwm vagrant-tramp aggressive-indent bookmark+ git-messenger ob-ipython helm-projectile projectile lispy nlinum undo-tree org-plus-contrib use-package smex rainbow-mode python-mode pydoc magit key-chord jedi-direx ido-ubiquitous hydra ht helm-themes helm-bibtex git-timemachine flx-ido elpy elfeed eimp dired-details+ button-lock auctex ace-isearch))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
