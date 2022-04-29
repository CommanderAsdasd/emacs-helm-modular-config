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
