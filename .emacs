;;Author: Baris Yuksel (2014)
;;
;;This is the .emacs file for the following video tutorials:
;;
;;Emacs as a C/C++ Editor/IDE (Part I): auto-complete, yasnippet, and auto-complete-c-headers
;;http://youtu.be/HTUE03LnaXA
;;Emacs as a C/C++ Editor/IDE (Part 2): iedit, flymake-google-cpplint, google-c-style
;;http://youtu.be/r_HW0EB67eY
;;Emacs as a C/C++ Editor/IDE (Part 3): cedet mode for true intellisense
;;http://youtu.be/Ib914gNr0ys
;;
;; start package.el with emacs
(require 'package)
;; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;; initialize package.el
(package-initialize)

;; show line number
;; (setq linum-format "%4d ")
(global-linum-mode t)

;; highlight the current line
(global-hl-line-mode 1)
;; choose a color here
(set-face-background 'hl-line "#3e4446")
;; keep current line's syntax highligh
(set-face-foreground 'highlight nil)

;; start auto-complete with emacs
(require 'auto-complete)
;; do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)
;;
;; start yasnippet with emacs
(require 'yasnippet)
(yas-global-mode t)
;; let's define a function which initializes auto-complete-c-headers and gets called for c/c++ hooks
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include/c++/4.2.1")
  )
;;;; now let's call this function from c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;; Fix iedit bug in Mac
(define-key global-map (kbd "C-c ;") 'iedit-mode)

;; start flymake-google-cpplint-load
;; let's define a function for flymake initialization
(defun my:flymake-google-init ()
 (require 'flymake-google-cpplint)
 (custom-set-variables
  '(flymake-google-cpplint-command "/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/cpplint"))
 (flymake-google-cpplint-load)
 )
(add-hook 'c-mode-hook 'my:flymake-google-init)
(add-hook 'c++-mode-hook 'my:flymake-google-init)
;; start google-c-style with emacs
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)


(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
 (define-key irony-mode-map [remap completion-at-point]
   'irony-completion-at-point-async)
 (define-key irony-mode-map [remap complete-symbol]
   'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; company mode
(eval-after-load 'company
 '(add-to-list 'company-backends 'company-irony))

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(add-hook 'irony-mode-hook 'company-mode)

;; company mode: highlight color
(require 'color)
(let ((bg (face-attribute 'default :background)))
  (custom-set-faces
    `(company-tooltip ((t (:inherit default :background "#3e4446" :foreground "#cce6c8"))))
    `(company-scrollbar-bg ((t (:background "#36342d"))))
    `(company-scrollbar-fg ((t (:background "#cce6c8"))))
    `(company-tooltip-selection ((t :background "#36342d")))
    `(company-tooltip-common ((t :background "#3e4446"))))
     )

;; ***************************************************************************
;; Author: Yifan Liu (2015)
;; This is the .emacs filr for Yifan's customization

;; load my favoriate theme
;; (require 'sublime-themes)
;; (load-theme 'brin t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
;; (load-theme 'zenburn t)

;; hide toolbar
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("31a01668c84d03862a970c471edbd377b2430868eccf5e8a9aec6831f1a0908d" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" default)))
 '(send-mail-function (quote mailclient-send-it))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-scrollbar-bg ((t (:background "#36342d"))) t)
 '(company-scrollbar-fg ((t (:background "#cce6c8"))) t)
 '(company-tooltip ((t (:inherit default :background "#3e4446" :foreground "#cce6c8"))) t)
 '(company-tooltip-common ((t :background "#3e4446")) t)
 '(company-tooltip-selection ((t :background "#36342d")) t))

;; set emacs to fullscreen
;; (set-frame-parameter nil 'fullscreen 'fullboth)

;; set emacs to a specified screensize
(when window-system (set-frame-size (selected-frame) 150 100))

;; open file and then focus on emacs window
;; (x-focus-frame nil)

;; disable the welcome screen
(when window-system (setq inhibit-startup-message t))

;; set the emacs PATH exactly same as OS X
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;
;; Globally map C-c t to a light/dark theme switcher
;; Also pull-in graphene for better fonts

(custom-set-variables '(solarized-termcolors 256))

(setq solarized-default-background-mode 'dark)

(load-theme 'solarized t)

(defun set-background-mode (frame mode)
 (set-frame-parameter frame 'background-mode mode)
 (when (not (display-graphic-p frame))
   (set-terminal-parameter (frame-terminal frame) 'background-mode mode))
 (enable-theme 'solarized))

(defun switch-theme ()
 (interactive)
 (let ((mode  (if (eq (frame-parameter nil 'background-mode) 'dark)
                  'light 'dark)))
   (set-background-mode nil mode)))

(add-hook 'after-make-frame-functions
         (lambda (frame) (set-background-mode frame solarized-default-background-mode)))

(set-background-mode nil solarized-default-background-mode)

(global-set-key (kbd "C-c t") 'switch-theme)

;; (require 'graphene)
