;; helm-modular-config.el --- helm interface for modular-config
;; Commander asdasd

(defun helm-modular-config/module-list-candidates ()
  "return list of strings - module load candidates"
  (mapcar (lambda (x) (intern (file-name-base x)))
          (directory-files modular-config-path nil "^[a-z0-9].*.el$")))

(defun helm-modular-config/helm-marked-modules-list ()
  (mapcar #'intern (helm-marked-candidates)))


(setq modular-config-helm-source
      `((name . ,(concat "Modules list in " modular-config-path))
        (candidates . helm-modular-config/module-list-candidates)
        (action . (("Load selected" . (lambda (candidate)
                                        (modular-config-load-modules           
                                         (helm-modular-config/helm-marked-modules-list))))
                   ("find modules" . (lambda (candidate)
                                      (mapcar (lambda (x) (find-file (concat (expand-file-name x modular-config-path) ".el")))
                                              (helm-marked-candidates))
                                      )
                    )))))


(defun helm-modular-config ()
  (interactive)
  (helm :sources '(modular-config-helm-source)))

(provide 'helm-modular-config)

;;; helm-modular-config.el ends here
