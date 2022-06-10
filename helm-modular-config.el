;; helm-modular-config.el --- helm interface for modular-config 
;; Copyright (C) 2022  Commander asdasd

;; Author: Commander Asdasd <e1ectricwiz4rd@gmail.com>
;; Keywords: convenience, helm
;; Created: 29.04.2022
;; Version: 0.1
;; URL: "https://github.com/CommanderAsdasd/emacs-helm-modular-config"
;; Package-Requires: ((emacs "25.1") (helm "3.0") (modular-config "0.5"))

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Helm interface for modular-config.el package.  Contributions welcome.

;;; Code:

(defcustom helm-modular-config/module-prefix "asdasd-" "new module name starts with STRING")

(defun helm-modular-config/module-list-candidates ()
  "return list of strings - module load candidates"
  (mapcar (lambda (x) (intern (file-name-base x)))
          (directory-files modular-config-path nil "^[a-z0-9].*.el$")))

(defun helm-modular-config/helm-marked-modules-list ()
  (mapcar #'intern (helm-marked-candidates)))

(defun helm-modular-config/new-module () ;; [a1]
  "new module in modular-config-path"
  (let* ((file-name (read-string "name: " helm-modular-config/module-prefix))
	 (file-path (expand-file-name (format "%s.el" file-name) modular-config-path)))
    (write-region "" nil file-path)
    (find-file file-path)
    (file-path)))

(defun helm-modular-config/new-module-load-current-file ()
  "create new module and push current file as load"
  (interactive)
    (let* ((file-name (read-string "name: " helm-modular-config/module-prefix))
	 (file-path (expand-file-name (format "%s.el" file-name) modular-config-path)))
      (write-region (format "(load \"%s\")" (buffer-file-name)) nil file-path) ;; [differs from (@ a1) only in this line]
      (find-file file-path)
    (file-path)))



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
                    )
		   ("new module" . (lambda (candidate) (helm-modular-config/new-module))
                    )
		   ("This file to new module" . (lambda (candidate) (helm-modular-config/new-module-load-current-file))
                    )
		   ))))


(defun helm-modular-config-current-modules-store (filename)
  "store list of successfully loaded modules to FILENAME"
  (interactive "FFile:")
  (with-temp-file filename
    (print modular-config-current-modules (current-buffer))))

(defun read-from-file (filename)
		"reads file"
		(read (with-temp-buffer
			(insert-file-contents filename)
			(buffer-string))))

(defun helm-modular-config-file-load (filename)
  "Load list of modules from FILENAME to modular-config-current-modules"
  (interactive "FFile: ")
  (modular-config-load-modules
  (mapcar #'intern (read-from-file filename)))
  )
(defun helm-modular-config ()
  (interactive)
  (helm :sources '(modular-config-helm-source)))

(provide 'helm-modular-config)

;;; helm-modular-config.el ends here
