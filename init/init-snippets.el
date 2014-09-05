(provide 'init-snippets)

(use-package yasnippet
    :diminish (yas-minor-mode . " $")
    :mode (("emacs.+/snippets/" . snippet-mode))
    :pre-load (progn
        ;; Fix yasnippet keymaps so they only work in insert mode (why they
        ;; had to make this so complicated I don't know); must be defined
        ;; BEFORE we include yasnippet.
        (defvar yas-minor-mode-map
          (let ((map (make-sparse-keymap)))
            (imap map [(tab)]     'yas-expand)
            (imap map (kbd "TAB") 'yas-expand)
            map)))
    :config
    (progn
      ;; Only load personal snippets
      (setq yas-snippet-dirs `(,*snippets-dir))
      (setq yas-prompt-functions '(yas-ido-prompt yas-no-prompt))

      (define-key yas-keymap (kbd "DEL") 'my/yas-clear-field)

      (yas-reload-all))
    :init
    (progn
      (add-hook 'prog-mode-hook 'yas-minor-mode)
      (add-hook 'snippet-mode-hook 'yas-minor-mode)
      (add-hook 'markdown-mode-hook 'yas-minor-mode)
      (add-hook 'org-mode-hook 'yas-minor-mode)))

(defun my/yas-clear-field (&optional field)
  (interactive)
  (let ((field (or field
                   (and yas--active-field-overlay
                        (overlay-buffer yas--active-field-overlay)
                        (overlay-get yas--active-field-overlay 'yas--field)))))
    (cond ((and field
                (not (yas--field-modified-p field))
                (eq (point) (marker-position (yas--field-start field))))
           (yas--skip-and-clear field))
          (t (delete-char -1)))))
