(setq backup-directory-alist `(("." . "~/.saves")))
(setq create-lockfiles nil)
(setq select-enable-clipboard t)

(setq fill-column 80)
(setq line-move-visual t)

;; Fonts
; (set-face-attribute 'default nil
; 		    :family "BerkeleyMono Nerd Font Mono"
; 		    :height 100
; 		    :weight 'normal
; 		    :width 'normal)
; 
; (set-face-attribute 'bold nil
; 		    :family "BerkeleyMono Nerd Font Mono"
; 		    :height 100
; 		    :weight 'bold
; 		    :width 'normal)
; 
; (set-face-attribute 'italic nil
; 		    :family "BerkeleyMono Nerd Font Mono"
; 		    :height 100
; 		    :weight 'normal
;                     :slant 'italic
; 		    :width 'normal)
; 
; (set-face-attribute 'bold-italic nil
; 		    :family "BerkeleyMono Nerd Font Mono"
; 		    :height 100
;                     :slant 'italic
; 		    :weight 'bold
; 		    :width 'normal)

(set-face-attribute 'default nil
 		    :family "TamzenForPowerline"
 		    :height 120
 		    :weight 'normal
 		    :width 'normal)

(set-face-attribute 'bold nil
 		    :family "TamzenForPowerline"
 		    :height 120
 		    :weight 'bold
 		    :width 'normal)

(set-face-attribute 'italic nil
 		    :family "TamzenForPowerline"
 		    :height 120
 		    :weight 'normal
 		    :width 'normal)

(set-face-attribute 'bold-italic nil
 		    :family "TamzenForPowerline"
 		    :height 120
 		    :weight 'bold
 		    :width 'normal)



;; Tramp
(require 'tramp)
(require 'tramp-fuse)
(require 'tramp-rclone)

(setq tramp-default-method "rsync")

(setq tramp-connection-properties
      '(("/sshfs:" "direct-async-process" t)))

(add-to-list 'tramp-remote-path "/usr/bin")
(add-to-list 'tramp-remote-path "/usr/local/bin")
(add-to-list 'tramp-remote-path "/opt/bin")
(add-to-list 'tramp-remote-path "~/.cargo/bin")
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

(setq tramp-copy-size-limit 16384)

;;
;; Straight (package manager)
;;
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;; Fixes
(use-package exec-path-from-shell
  :straight t
  :config
  (exec-path-from-shell-initialize))


;;
;; Evil
;; 
(use-package evil
  :straight t
  :init
  (setq evil-want-keybinding nil)
  :config
  ;; Evil mode
  (evil-mode 1)
  ;; (evil-global-set-key 'normal "L" 'next-buffer)  ;; Next buffer
  ;; (evil-global-set-key 'normal "H" 'previous-buffer)  ;; Previous buffer
  (with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol)
    ;; make evil-search-word look for symbol rather than word boundaries
    (setq-default evil-symbol-word-search t)))

(use-package evil-collection
  :straight t
  :config
  (evil-collection-init))

(use-package evil-leader
  :straight t
  :config
  (evil-leader/set-leader ",")
  (global-evil-leader-mode))

;;
;; Magit
;;

(use-package magit
  :straight t
  :config
  (evil-leader/set-key
    "g" 'magit
    ))

;;
;; Completion: Vertico (UI) + Orderless (matching) + Marginalia (annotations)
;;
(use-package vertico
  :straight t
  :init (vertico-mode 1))

(use-package vertico-posframe
  :straight t
  :init (vertico-posframe-mode 1))

(use-package orderless
  :straight t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :straight t
  :init (marginalia-mode 1))

;;
;; Consult
;;
 
(use-package consult
  :straight t
  :config
  (setq consult-ripgrep-args
        "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip")
 
  (setq consult-preview-key "M-.")
 
  ;; Integrate with projectile for project detection
  (setq consult-project-function
        (lambda (_may-prompt)
          (projectile-project-root)))
 
  (evil-leader/set-key
    "fb" 'consult-buffer
    "fg" 'consult-ripgrep
    "fl" 'consult-line
    "fj" 'consult-goto-line))
 
(use-package consult-projectile
  :straight t
  :after (consult projectile)
  :config
  (evil-leader/set-key
    ;; Project-scoped buffer + file switcher
    "ff" 'consult-projectile))

;;
;; Projectile (project management)
;;

(use-package projectile
  :straight t
  :init
  (setq projectile-mode-line "Projectile")
  (setq projectile-switch-project-action #'projectile-dired)
  :config
  (evil-leader/set-key
    "fo" 'projectile-switch-project
    "fd" 'projectile-find-dir)
  (projectile-mode))

;;
;; Dired Preview
;;

(use-package dired-preview
  :straight t
  :init
  (setq dired-preview-delay 0.7)
  (setq dired-preview-max-size (expt 2 20))
  (setq dired-preview-ignored-extensions-regexp
          (concat "\\."
                  "\\(gz\\|"
                  "zst\\|"
                  "tar\\|"
                  "xz\\|"
                  "rar\\|"
                  "zip\\|"
                  "iso\\|"
                  "epub"
                  "\\)"))
  :config
  (dired-preview-global-mode 1))

;;
;; Org
;;

(use-package org-download
  :straight t
  :after org
  :config
  (setq org-download-method 'directory
	org-download-image-dir (expand-file-name "~/org/attachments/img")
        org-download-heading-lvl nil
        org-download-timestamp "%Y%m%d-%H%M%S-"
	org-download-abbreviate-source-link nil
        org-download-screenshot-method "wl-paste --type image/png > %s")
  (advice-add 'org-download--dir :override
            (lambda () (expand-file-name "~/org/attachments/img")))
  :init
  (evil-leader/set-key
    "ov" #'org-download-clipboard))

;; soft visual wrapping
(use-package visual-fill-column
  :straight t
  :hook (org-mode . visual-fill-column-mode)
  :custom
  (visual-fill-column-width 100)
  (visual-fill-column-center-text t)
  :config
  (add-hook 'visual-fill-column-mode-hook #'visual-line-mode))

(use-package org-appear
  :straight t
  :hook (org-mode . org-appear-mode)
  :config
  ;; 1. Un-render LaTeX equations when the cursor is inside them
  (setq org-appear-inside-latex t) 
  
  ;; 2. Reveal full link structures (URLs) when the cursor enters them
  (setq org-appear-autolinks t)
  
  ;; 3. Explicitly disable it for italics, bold, sub/superscripts, etc.
  (setq org-appear-autoemphasis nil)
  (setq org-appear-autosubmarkers nil)
  (setq org-appear-autoentities nil))

(use-package org-fragtog
  :straight t
  :hook (org-mode . org-fragtog-mode))

(use-package org-roam
  :straight t
  :config
  (setq org-roam-directory (file-truename "~/org/kb"))
  (setq org-roam-completion-everywhere t)
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)
          ("l" "lecture" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: lecture\n\n* Agenda\n%?\n")
           :unnarrowed t)))
  :init
  (org-roam-db-autosync-mode)
  (evil-leader/set-key
    "dd" #'org-roam-node-insert
    "df" #'org-roam-node-find
    "da" #'org-roam-alias-add))

(use-package org
  :straight t
  :config
  ;; Encryption
  (require 'epa-file)
  (epa-file-enable)
  ;; This points org agenda to the right place
  (setq org-agenda-files "~/org/AGENDA")
  ;; This allows us to follow links with the return key
  (setq org-return-follows-link t)
  ;; This logs a timestamp for task completion
  (setq org-log-done 'time)
  ;; Make refile work
  (setq org-refile-targets '((org-agenda-files :maxlevel . 5)))
  (setq org-refile-use-outline-path 'file)
  ;; This auto-associates org files
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (add-hook 'org-mode-hook
            (lambda ()
              ;; Virtual indents
              (org-indent-mode 1)

              ;; 80 column guide (optional)
              (setq-local display-fill-column-indicator-column 100)
              (display-fill-column-indicator-mode 1)))
  (with-eval-after-load 'evil
    (evil-define-key 'normal org-mode-map
      (kbd "j") #'next-line
      (kbd "k") #'previous-line))
  ;; TODO key words
  (setq org-todo-keywords
  	'((sequence "TODO" "|" "DONE")
	  (sequence "TOREAD" "READING" "|" "DIDREAD")
  	  (sequence "ATTEND" "|" "ATTENDED")))
  ;; ;; Tags
  (setq org-tag-alist '(;; Thing is an assignment
			("assignment" . ?a)
			;; Thing is a lecture
			("lecture" . ?l)
			;; Thing was done synchronously
			("sync" . ?s)))
  ;; Keybinds
  ;; Insert LaTeX environment snippet
  (defun my/org-insert-env (env)
    "Insert a \\begin{ENV}...\\end{ENV} block and place cursor inside."
    (insert (format "\\begin{%s}\n\n\\end{%s}" env env))
    (forward-line -1)
    (evil-open-above 0))

  (evil-leader/set-key
    "oep" (lambda () (interactive) (my/org-insert-env "proof"))
    "oet" (lambda () (interactive) (my/org-insert-env "theorem"))
    "oea" (lambda () (interactive) (my/org-insert-env "algorithm"))
    "oel" (lambda () (interactive) (my/org-insert-env "lemma"))
    "oed" (lambda () (interactive) (my/org-insert-env "definition"))
    "oec" (lambda () (interactive) (my/org-insert-env "corollary"))

    "or" 'org-refile
    "od" 'org-dblock-update
    "ott" 'org-set-tags-command
    "oti" 'org-clock-in
    "oto" 'org-clock-out
    "op" 'org-latex-preview
    "oo" 'org-open-at-point
    "ols" 'org-store-link
    "oll" 'org-insert-link
    "oa" 'org-agenda
    "oc" 'org-capture)
  ;; Capture templates
  (setq org-capture-templates
	'())
  ;; Add typst as a preview method
  (add-to-list 'org-preview-latex-process-alist
             '(typst
               :programs ("typst" "python3")
               :description "Typst > SVG"
               :message "Install typst from https://typst.app"
               :image-input-type "typ"
               :image-output-type "svg"
               :latex-compiler
               ("python3 ~/.emacs.d/org-typst-convert.py -v --width 6in %f %o%b.typ")
               :image-converter
               ("cp %f ~/typst/tmp/$(basename %f) && \
                 typst compile --root ~/typst --format svg ~/typst/tmp/$(basename %f) ~/typst/tmp/$(basename %O) && \
                 cp ~/typst/tmp/$(basename %O) %O")))
  ;; Set typst as default
  (setq org-preview-latex-default-process 'typst)
  (setq org-latex-create-formula-image-program 'typst)
  ;; render caching
  (setq org-preview-latex-image-directory
    (expand-file-name "org-latex-preview/" (or (getenv "XDG_CACHE_HOME")
                                               (expand-file-name "~/.cache/"))))

  ;; Rescale headings and LaTeX previews when zooming with text-scale
  (defvar-local my/org-heading-remap-cookies nil
    "Cookies from face-remap-add-relative for org heading faces.")

  (defun my/org-rescale-on-zoom ()
    "Rescale org heading faces and LaTeX SVG overlays with text-scale."
    (when (derived-mode-p 'org-mode)
      (let ((scale (expt text-scale-mode-step text-scale-mode-amount)))
        ;; Headings: remove old remaps, apply new ones
        (dolist (cookie my/org-heading-remap-cookies)
          (face-remap-remove-relative cookie))
        (setq my/org-heading-remap-cookies nil)
        (dolist (face '(org-level-1 org-level-2 org-level-3 org-level-4
                        org-level-5 org-level-6 org-level-7 org-level-8))
          (push (face-remap-add-relative face :height scale)
                my/org-heading-remap-cookies))
        ;; LaTeX previews: rescale existing SVG overlays
        (dolist (ov (overlays-in (point-min) (point-max)))
          (let ((disp (overlay-get ov 'display)))
            (when (and (consp disp) (eq (car disp) 'image))
              (plist-put (cdr disp) :scale scale)))))))
  (add-hook 'text-scale-mode-hook #'my/org-rescale-on-zoom)

  ;; Apply current zoom to newly created preview overlays (e.g. from fragtog)
  (advice-add 'org--make-preview-overlay :filter-return
              (lambda (ov)
                (when (and (bound-and-true-p text-scale-mode)
                           (derived-mode-p 'org-mode))
                  (let ((scale (expt text-scale-mode-step text-scale-mode-amount))
                        (disp (overlay-get ov 'display)))
                    (when (and (consp disp) (eq (car disp) 'image))
                      (plist-put (cdr disp) :scale scale))))
                ov)))
;;
;; VTerm
;;

(defun my-vterm-find-file (&rest args)
  "From vterm, open FILE in the same frame, preferably reusing the vterm window.

ARGS is (DIR FILE) as passed by `vterm_cmd`."
  (let* ((dir  (nth 0 args))
         (file (nth 1 args)))
    (unless (and file (stringp file) (not (string-empty-p file)))
      (error "my-vterm-find-file: FILE argument is missing or empty. ARGS=%S" args))
    ;; Make relative FILE relative to DIR
    (let* ((default-directory (or dir default-directory))
           (full (expand-file-name file default-directory))
           (buf   (current-buffer))
           (frame (window-frame (get-buffer-window buf t)))
           (win   (get-buffer-window buf t)))
      (if (and win (frame-live-p frame))
          (with-selected-frame frame
            (with-selected-window win
              (find-file full)))
        (find-file full)))))


(use-package vterm
  :straight t
  :init
  (setq vterm-shell (if (eq system-type 'darwin) "/bin/zsh" "/bin/bash"))
  :config
  (setq vterm-tramp-shells '(("docker" "/bin/sh") ("rsync" "/bin/bash") ("ssh" "/bin/bash")))
  ;; HJKL Nav
  (define-key vterm-mode-map (kbd "C-h") #'evil-window-left)
  (define-key vterm-mode-map (kbd "C-j") #'evil-window-down)
  (define-key vterm-mode-map (kbd "C-k") #'evil-window-up)
  (define-key vterm-mode-map (kbd "C-l") #'evil-window-right)
  (define-key vterm-mode-map (kbd "C-c c") #'vterm-send-C-c)

  (evil-define-key 'insert vterm-mode-map (kbd "C-c") nil)
  (evil-define-key 'normal vterm-mode-map (kbd "C-c") nil)
  (evil-define-key 'insert vterm-mode-map (kbd "C-c") #'vterm-send-C-c)
  (evil-define-key 'normal vterm-mode-map (kbd "C-c") #'vterm-send-C-c)

  (add-to-list 'vterm-eval-cmds
               '("my-vterm-find-file" my-vterm-find-file))

  (add-hook 'vterm-exit-functions
            (lambda (_ _)
              (let* ((buffer (current-buffer))
                     (window (get-buffer-window buffer)))
                (when (not (one-window-p))
                  (delete-window window))
                (kill-buffer buffer))))

  ;; Yank
  :bind (:map vterm-mode-map ("C-y" . vterm-yank)))

;;
;; Citations
;;

(defun my/normalize-doi (doi)
  "Return DOI string without doi.org prefix."
  (when (and doi (stringp doi))
    (let ((d (string-trim doi)))
      (setq d (replace-regexp-in-string "\\`https?://\\(dx\\.\\)?doi\\.org/" "" d))
      (setq d (replace-regexp-in-string "\\`doi:\\s-*" "" d))
      (and (not (string-empty-p d)) d))))

(defun my/ebib-zotra-download-current ()
  "Download attachment for current Ebib entry via zotra, preferring DOI."
  (interactive)
  (require 'ebib)
  (require 'zotra)
  (require 'cl-lib)
  (let* ((db ebib--cur-db)
         (key (or (ebib--get-key-at-point) (ebib--db-get-current-entry-key db)))
         (doi (my/normalize-doi
               (ebib-get-field-value "doi" key db 'noerror 'unbraced 'xref)))
         (url (ebib-get-field-value "url" key db 'noerror 'unbraced 'xref))
         (dir (expand-file-name "~/org/papers/")) ; or your zotra default dir
         (target (expand-file-name (concat key ".pdf") dir))
         (downloaded
          (or (and (file-exists-p target) target)
              (cl-loop for id in (delq nil (list doi url))
                       for out = (condition-case nil
                                     (zotra-download-attachment id nil target)
                                   (error nil))
                       when out return out))))
    (unless key (user-error "No Ebib entry selected"))
    (unless downloaded (user-error "Download failed with DOI and URL"))
    (ebib-set-field-value "file" downloaded key db 'overwrite)
    (ebib--set-modified t db)
    (ebib--update-entry-buffer)
    (message "Attachment saved: %s" downloaded)))

(use-package zotra
  :straight t
  :config
  (setq zotra-backend 'zotra-server)
  (setq zotra-local-server-directory "~/tools/zotra-server")
  (setq zotra-default-bibliography "~/org/refs.bib")
  (setq zotra-download-attachment-default-directory "~/docs/papers/zotra")
  (evil-leader/set-key
    "ca" 'zotra-add-entry))

(use-package ebib
  :straight t
  :config
  (setq ebib-preload-bib-files '("~/org/refs.bib"))
  (setq ebib-bibtex-dialect 'biblatex)
  (evil-leader/set-key
    "ce" 'ebib
    "cd" #'my/ebib-zotra-download-current))

;;
;; LLMs
;;

(use-package gptel
  :straight t
  :config
  (setq gptel-default-mode 'org-mode)
  (evil-leader/set-key
    "lr" 'gptel-rewrite
    "ll" 'gptel-send
    "la" 'gptel-add
    "lm" 'gptel-menu
    "lo" 'gptel
    ))

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :config
  (claude-code-ide-emacs-tools-setup)
  (evil-leader/set-key
    "cm" 'claude-code-ide-menu
    "co" 'claude-code-ide
    "ct" 'claude-code-ide-toggle-recent
  )) ; Optionally enable Emacs MCP tools

;;
;; LSP mode
;;

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-auto-configure nil)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq gc-cons-threshold 100000000)
  (setq lsp-idle-delay 0.100)
  (setq lsp-log-io nil)
  (setq lsp-enable-snippet nil)
  (setq lsp-prefer-flymake nil)
  
  :hook ((rust-mode . lsp-deferred)
         (rustic-mode . lsp-deferred))
  :config
  ;; (setq lsp-log-io t) ; enable only when debugging
  (evil-define-key 'normal lsp-mode-map
    (kbd "K") #'lsp-describe-thing-at-point))

(use-package flycheck
  :straight t
  :init
  (global-flycheck-mode -1))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode
  :init
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-delay 0.5)
  (setq lsp-ui-doc-position 'top) ;; or 'at-point
  :hook (lsp-mode . lsp-ui-mode))

;;
;; Individual Languages
;;

;; Rust
(use-package rustic
  :straight t
  :config
  ;; Tell rustic to use lsp-mode as the LSP client
  (setq rustic-lsp-client 'lsp-mode)

  ;; Optional: if you ever change servers, rustic uses `rustic-lsp-server`
  ;; (see lsp-mode docs)
  ;; (setq rustic-lsp-server 'rust-analyzer)

  (evil-leader/set-key-for-mode 'rustic-mode
    "rc" 'rustic-cargo-check
    "rr" 'rustic-cargo-run
    "rf" 'rustic-cargo-fmt))


;; EPUB files
(use-package nov
  :straight t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; Typst
;; (with-eval-after-load 'lsp-mode
;;   (with-eval-after-load 'typst-ts-mode
;;     ;; Define a tinymist client for typst-ts-mode.
;;     (lsp-register-client
;;      (make-lsp-client
;;       :new-connection
;;       (lsp-stdio-connection
;;        (lambda ()
;;          ;; Prefer typst-ts-mode's downloaded tinymist path if available,
;;          ;; otherwise fall back to "tinymist" on PATH.
;;          (cond
;;           ((and (boundp 'typst-ts-lsp-download-path)
;;                 (stringp typst-ts-lsp-download-path)
;;                 (file-executable-p typst-ts-lsp-download-path))
;;            (list typst-ts-lsp-download-path))
;;           (t
;;            (list "tinymist")))))
;;       :major-modes '(typst-ts-mode)
;;       :server-id 'tinymist)))
;; 
;;   ;; Start LSP automatically in typst buffers
;;   (add-hook 'typst-ts-mode-hook #'lsp-deferred))
;; 
(use-package typst-ts-mode
  :straight t
  :mode "\\.typ\\'")

(use-package typst-preview
  :straight t
  :config
  (setq typst-preview-browser "xwidget")
  (setq typst-preview-default-dir "~/typst")
  (setq typst-preview-partial-rendering t)
  (evil-leader/set-key
    "ts" 'typst-preview-start
    "tk" 'typst-preview-stop
    "tt" 'typst-preview-send-position))

;; 
;;
;; STYLING
;;

;; Doom Themes
;; (use-package doom-themes
;;   :straight t
;;   :init
;;   (add-to-list 'default-frame-alist '(font . "Berkeley Mono Nerd Font-10"))
;;   ;; (add-to-list 'default-frame-alist '(alpha-background . 80))
;;   :config
;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled
;; 
;;   ;; Neon. Does it match my system? No. Looks cool thoug :)
;;   ;; (load-theme 'doom-outrun-electric t)
;;   ;; (load-theme 'doom-badger t)
;;   ;; (load-theme 'doom-ir-black t)
;;   ;; (load-theme 'doom-ayu-light t)
;;   (load-theme 'doom-solarized-light t)
;; 
;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; Enable custom neotree theme (nerd-icons must be installed!)
;;   ;; (doom-themes-neotree-config)
;;   ;; or for treemacs users
;;   ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
;;   ;; (doom-themes-treemacs-config)
;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))
;;   ;; (custom-set-faces
;;   ;;  '(line-number ((t (:foreground "#816d81"))))))

;; The One True Theme
(setq modus-themes-mixed-fonts nil
    modus-themes-italic-constructs t
    modus-themes-bold-constructs t
    modus-themes-common-palette-overrides nil)

(defun my/read-theme-mode ()
  "Read theme mode from ~/.config/theme-mode."
  (let ((file (expand-file-name "~/.config/theme-mode")))
    (if (file-exists-p file)
        (string-trim (with-temp-buffer (insert-file-contents file) (buffer-string)))
      "dark")))

(defun my/apply-theme-from-file ()
  "Load the theme matching ~/.config/theme-mode."
  (let ((mode (my/read-theme-mode)))
    (if (string= mode "light")
        (load-theme 'modus-operandi-tinted t)
      (load-theme 'modus-vivendi-tinted t))))

(my/apply-theme-from-file)

(evil-leader/set-key
  "mt" (lambda ()
         (interactive)
         (shell-command "theme-toggle toggle")))

;;
;; HASS
;;
(use-package hass
  :straight t
  :ensure t
  :init
  (setq hass-host "homeassistant.local")
  (setq hass-insecure t)
  (setq hass-apikey
      (lambda ()
        (let* ((entry (car (auth-source-search
                            :host "homeassistant.local" ; or whatever you used
                            :port "8123"                 ; or 8123, etc.
                            :user "apikey"              ; or your chosen user
                            :require '(:secret))))
               (secret (when entry
                         (plist-get entry :secret))))
          (when secret
            (if (functionp secret)
                (funcall secret)
              secret)))))
  :config
  (evil-leader/set-key
    "h" 'hass-dash-open)
  (setq hass-dash-layouts
      '((default
         ;; Top-level group is optional, but nice for labeling
         (hass-dash-group
          :title "Balls"
          :format "%t\n\n%v"
          (hass-dash-toggle :entity-id "light.coffee_ball"
			    :label "Coffee Ball")
          (hass-dash-toggle :entity-id "light.joseph_ball"
			    :label "Joseph's Ball"))))))

;;
;; PDFs
;;

(use-package pdf-tools
  :straight t
  :hook
  ;; Disable line numbers in pdf buffers (required)
  (pdf-view-mode . (lambda ()
                     (display-line-numbers-mode -1)))
  :config
  ;; Install / enable pdf-tools
  (pdf-tools-install t)

  ;; Evil-friendly keybindings
  (with-eval-after-load 'evil
    (evil-define-key 'normal pdf-view-mode-map
      (kbd "+")  #'pdf-view-enlarge
      (kbd "-")  #'pdf-view-shrink
      (kbd "=")  #'pdf-view-fit-page-to-window
      (kbd "j") #'pdf-view-next-line-or-next-page
      (kbd "k") #'pdf-view-previous-line-or-previous-page
      (kbd "gg") #'pdf-view-first-page
      (kbd "G")  #'pdf-view-last-page
      (kbd "h")  #'pdf-view-previous-page
      (kbd "l")  #'pdf-view-next-page
      (kbd "/")  #'pdf-occur
      (kbd "n")  #'pdf-view-next-search-matc
      (kbd "N")  #'pdf-view-previous-search-match)))


;;
;; Breadcrumbs
;;

(use-package breadcrumb
  :straight t)

;; Strip emacs stuff
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
