;; -*- lexical-binding: t; -*-
;;; init.el --- Configuration for my Emacs
;;; Commentary:
;;;;Copyright (C) 2012  Yuri da Costa Albuquerque
;;;;
;;;;This program is free software: you can redistribute it and/or modify
;;;;it under the terms of the GNU General Public License as published by
;;;;the Free Software Foundation, either version 3 of the License, or
;;;;(at your option) any later version.
;;;;
;;;;This program is distributed in the hope that it will be useful,
;;;;but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;;GNU General Public License for more details.
;;;;
;;;;You should have received a copy of the GNU General Public License
;;;;along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-modules (quote (autojoin button completion fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring scrolltobottom smiley stamp track truncate)))
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/Dropbox/org/metas.org" "~/Dropbox/org/agenda.org" "~/Dropbox/org/lpic.org")))
 '(smtpmail-smtp-server "mail.tap4mobile.com.br")
 '(smtpmail-smtp-service 25)
 '(socks-server (quote ("Default server" "localhost" 9050 5))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-item-highlight ((t (:background "black")))))

;; Misc
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/plugins/erc-sasl")
(setq make-backup-files nil)
(setq gnus-button-url 'browse-url-generic
      browse-url-generic-program (if (eq system-type 'windows-nt)
                                     "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
                                   "google-chrome")
      browse-url-browser-function gnus-button-url)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(global-auto-revert-mode 1)
(add-hook 'find-file-hook #'(lambda ()
                              (setq indicate-buffer-boundaries t)))
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)
(global-set-key [s-left] 'windmove-left)
(global-set-key [s-right] 'windmove-right)
(global-set-key [s-up] 'windmove-up)
(global-set-key [s-down] 'windmove-down)
(put 'dired-find-alternate-file 'disabled nil)
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq-default indent-tabs-mode nil)
(add-to-list 'auto-mode-alist '("PKGBUILD" . pkgbuild-mode))
(put 'upcase-region 'disabled nil)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(show-paren-mode 1)
(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t)

;; Emacs theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'wilson t)

;;Clean up
(defun cleanup-buffer-safe ()
  (interactive)
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8)
  (untabify (point-min) (point-max)))
(defun cleanup-buffer ()
  (interactive)
  (cleanup-buffer-safe)
  (indent-region (point-min) (point-max)))
(global-set-key (kbd "C-c s") 'cleanup-buffer)

;; Ruby
(add-hook 'ruby-mode-hook 'zossima-mode)
(cond ((eq system-type 'windows-nt)
       (setenv "PATH" (concat "C:\\Program Files (x86)\\Git\\bin;" (getenv "PATH")))
       (setq exec-path (cons "C:\\Program Files (x86)\\Git\\bin" exec-path)))
      (t
       (setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
       (setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))))

;; ERC + Tor
(setq socks-override-functions nil)
(setq erc-server "10.40.40.40")
(setq erc-nick "Denommus")
(setq erc-server-connect-function
      #'(lambda (name buffer host service &rest parameters)
          (let ((hosts (list "10.40.40.40" "10.40.40.41")))
            (apply
             (if (member host hosts)
                 'socks-open-network-stream
               'open-network-stream)
             (append (list name buffer host service) parameters)))))
(require 'socks)
(require 'erc)
(require 'erc-sasl)
(add-to-list 'erc-sasl-server-regexp-list "10\\.40\\.40\\.40")
(add-to-list 'erc-sasl-server-regexp-list "10\\.40\\.40\\.41")
(setq ercn-notify-rules
      '((current-nick . all)
        (query-buffer . all)))
(require 'notifications)
(add-hook 'ercn-notify
          #'(lambda (nickname message)
              (unless (eq system-type 'windows-nt)
                (notifications-notify
                 :title "ERC"
                 :body (concatenate 'string nickname ": " message)))))

;; Tetris
(setq tetris-score-file
      "~/.emacs.d/tetris-scores")

;; Packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;;BBDB
(add-to-list 'load-path "~/.emacs.d/plugins/bbdb-2.35/lisp")
(require 'bbdb)
(bbdb-initialize 'gnus 'message)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'mail-setup-hook 'bbdb'insinuate-sendmail)
(setq bbdb-file "~/Dropbox/bbdb")
(setq bbdb-complete-name-full-completion t)
(setq bbdb-completion-type 'primary-or-name)
(setq bbdb-complete-name-allow-cycling t)

;;Org-Mode
(setq org-log-done 'time)
(setq org-agenda-include-diary t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (concat org-directory "/capture.org"))
(setq org-agenda-files
      (list
       (concat org-directory "/agenda.org")
       (concat org-directory "/lpic.org")
       (concat org-directory "/capture.org")))
(setq org-mobile-inbox-for-pull (concat org-directory "/agenda.org"))
(setq org-mobile-directory (concat org-directory "/MobileOrg"))
(load "~/.emacs.d/plugins/brazilian-holidays.el")
(add-hook 'org-mode-hook 'visual-line-mode)
(add-to-list 'load-path "~/.emacs.d/plugins/org-git-link")
(require 'org-git-link)

;;Diary
(setq diary-file "~/Dropbox/diary")
(setq calendar-and-diary-frame-parameters
      '((name . "Calendar") (title . "Calendar")
        (height . 20) (width . 78)
        (minibuffer . t)))
(setq calendar-date-style "european")

;;Jabber
(setq jabber-account-list '(("yuridenommus@gmail.com"
                             (:network-server . "talk.google.com")
                             (:connection-type . ssl))))

;;Twittering Mode
(setq twittering-use-master-password t)
(setq twittering-cert-file "/etc/ssl/certs/ca-certificates.crt")
(setq twittering-icon-mode t)
(setq twittering-initial-timeline-spec-string
      '(":home"
        ":replies"
        ":favorites"
        ":direct_messages"
        ":search/emacs/"))

;; Python
(setq python-command "python2")
(setq pdb-path '/usr/lib/python2.7/pdb.py
      gud-pdb-command-name (symbol-name pdb-path))
(defadvice pdb (before gud-query-cmdline activate)
  "Provide a better default command line when called interactively."
  (interactive
   (list (gud-query-cmdline pdb-path
                            (file-name-nondirectory buffer-file-name)))))

;; HTML
(setq html-mode-hook
      #'(lambda ()
          (local-set-key (kbd "C-c C-r") 'browse-url-of-file)))

;;After Initialize
(add-hook
 'after-init-hook
 #'(lambda ()
     ;; Packages
     (let ((auto-install-packages
            '(bundler
              auto-complete
              auto-complete-clang
              auctex
              clojure-mode
              cider
              ercn
              yasnippet
              magit
              js2-mode
              slime
              quack
              geiser
              paredit
              csharp-mode
              dired+
              org-mime
              git-commit-mode
              gitconfig-mode
              lua-mode
              pkgbuild-mode
              ruby-block
              ruby-compilation
              rinari
              zossima
              yaml-mode
              undo-tree
              jabber
              popup
              escreen
              show-css
              pretty-symbols
              browse-kill-ring
              haskell-mode
              projectile
              twittering-mode)))
       (mapc #'(lambda (pkg)
                 (unless (package-installed-p pkg)
                   (package-install pkg))) auto-install-packages))

     ;; Haskell
     (add-hook 'haskell-mode-hook #'turn-on-haskell-indent)

     ;; SLIME
     (load (expand-file-name "~/quicklisp/slime-helper.el"))
     (setq inferior-lisp-program "sbcl --noinform --no-linedit")
     (defun custom-repl-mode-hook ()
       (define-key slime-repl-mode-map [S-up] #'windmove-up)
       (define-key slime-repl-mode-map [S-down] #'windmove-down))
     (add-hook 'slime-repl-mode-hook #'custom-repl-mode-hook)
     (add-hook 'slime-mode-hook #'(lambda () (slime-setup '(slime-indentation))))

     ;; ParEdit
     (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
     (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
     (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
     (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
     (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
     (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
     (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
     (add-hook 'geiser-repl-mode-hook      #'enable-paredit-mode)
     (add-hook 'clojure-mode-hook          #'enable-paredit-mode)
     (add-hook 'slime-repl-mode-hook #'(lambda () (paredit-mode +1)))
     (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
     (defun override-slime-repl-bindings-with-paredit ()
       (define-key slime-repl-mode-map
         (read-kbd-macro paredit-backward-delete-key) nil))
     (add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

     ;; Ruby
     (global-rinari-mode)

     ;; Magit
     (add-hook 'dired-mode-hook
               #'(lambda ()
                   (local-set-key (kbd "<f5>") 'magit-status)))

     ;; Pretty Symbols
     (add-to-list 'pretty-symbol-categories 'relational)
     (add-to-list 'pretty-symbol-categories 'misc)
     (add-hook 'lisp-mode-hook #'pretty-symbols-mode)
     (add-hook 'emacs-lisp-mode-hook #'pretty-symbols-mode)
     (add-hook 'c-mode-common-hook #'pretty-symbols-mode)

     ;; Twittering mode
     (add-hook 'twittering-mode-hook
               #'(lambda ()
                   (local-set-key (kbd "C-c p") 'twittering-goto-previous-uri)
                   (local-set-key (kbd "C-c n") 'twittering-goto-next-uri)))

     ;; Escreen
     (require 'escreen)
     (escreen-install)
     (setq escreen-prefix-char "\C-z")
     (global-set-key escreen-prefix-char #'escreen-prefix)
     (global-set-key (kbd "<C-tab>") #'escreen-goto-next-screen)
     (global-set-key (kbd "<C-S-iso-lefttab>") #'escreen-goto-prev-screen)
     (global-set-key (kbd "<C-S-tab>") #'escreen-goto-prev-screen)

     ;; YASnippet
     (require 'yasnippet)
     (yas-global-mode 1)
     (yas-load-directory "~/.emacs.d/snippets")

     ;; Auto-complete
     (require 'auto-complete-config)
     (ac-config-default)
     (ac-trigger-key-command "TAB")
     (ac-trigger-key-command "<tab>")

     ;; Auto-complete-clang
     (require 'auto-complete-clang)
     (require 'cl)
     (defun ac-clang-setup ()
       (push 'ac-source-clang ac-sources)
       (local-set-key (kbd "C-c SPC") #'ac-complete-clang))
     (add-hook 'c-mode-common-hook #'ac-clang-setup)

     (c-add-style "qt" '("stroustrup" (indent-tabs-mode . nil) (tab-width . 4)))

     (defun ac-clang-parse-cmake-flags (file)
       (cl-flet
           ((filter-comments-and-blank-lines (line)
                                             (or (string-equal line "")
                                                 (char-equal (string-to-char line)
                                                             (string-to-char "#")))))
         (with-temp-buffer
           (insert-file-contents file)
           (remove-if-not
            (lambda (element)
              (and (not (string-equal element ""))
                   (char-equal (elt element 0)
                               (string-to-char "-"))
                   (char-equal (elt element 1)
                               (string-to-char "I"))))
            (reduce #'append
                    (mapcar (lambda (line)
                              (split-string (elt (split-string line "=") 1) " "))
                            (remove-if #'filter-comments-and-blank-lines
                                       (split-string (buffer-string) "\n" t))))))))

     (defun ac-clang-find-cmake-flags-files (dominating-file)
       (remove-if-not #'file-exists-p
                      (mapcar (lambda (element)
                                (concat element "/flags.make"))
                              (directory-files
                               (concat dominating-file "bin/CMakeFiles/") t "^.*\\.dir$"))))

     (add-hook 'c-mode-common-hook
               (lambda ()
                 (make-local-variable 'ac-clang-flags)
                 (setq ac-clang-flags
                       (append
                        (list
                         "-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.1/../../../../include/c++/4.8.1"
                         "-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.1/../../../../include/c++/4.8.1/x86_64-unknown-linux-gnu"
                         "-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.1/../../../../include/c++/4.8.1/backward"
                         "-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.1/include"
                         "-I/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.1/include-fixed"
                         "-I/usr/include")
                        (let ((dominating-file (locate-dominating-file (buffer-file-name) "CMakeLists.txt")))
                          (when dominating-file
                            (reduce #'append
                                    (mapcar #'ac-clang-parse-cmake-flags
                                            (ac-clang-find-cmake-flags-files dominating-file)))))))))

     ;; C code
     (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
     (add-hook 'c-mode-common-hook
               #'(lambda ()
                   (c-set-style "qt")
                   (subword-mode 1)))

     ;; Undo tree
     (global-undo-tree-mode 1)

     ;; Quack
     (require 'quack)

     ;; Geiser
     (require 'geiser)
     (require 'scheme)
     (define-key scheme-mode-map "\C-c\C-c"
       #'geiser-compile-definition)

     ;; Projectile
     (projectile-global-mode)

     ;; CMake
     (unless (eq system-type 'windows-nt)
       (require 'cmake-mode)
       (add-to-list 'auto-mode-alist '("CMakeLists.txt" . cmake-mode)))))
(provide 'init)
;;; init.el ends here
