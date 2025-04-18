;;; open-web.el --- Open URLs more intuitively -*- lexical-binding: t -*-

;; Copyright (C) 2025 Free Software Foundation, Inc.

;; Author: Lars Magne Ingebrigtsen <larsi@gnus.org>

;; open-web is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; open-web is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.

;;; Commentary:

;;; Code:

(require 'cl-lib)

(defvar open-web-methods
  '(eww-browse-url
    open-web-new-window
    open-web-same-window)
  "A list of functions to be used for different numbers of `C-u' prefixes.")

(defvar open-web-reverse-method-regexps nil
  "A list of regexps (to match URLs) to reverse actions.
That is, if an URL matches any of the regexps in this list, `C-u'
 will use the first action in `open-web-methods' and no `C-u'
 will use the second.")

(defvar open-web-browser #'browse-url-firefox)

(defun open-web (url &optional _)
  "Open a web page using `open-web-methods'.
Different methods will be selected based on how many `C-u's the
user has tapped."
  (let ((methods open-web-methods))
    (when (seq-filter (lambda (elem)
			(string-match-p elem url))
		      open-web-reverse-method-regexps)
      (setq methods (list (nth 1 methods)
			  (nth 0 methods)
			  (nth 2 methods))))
    (let* ((prefix (if (consp current-prefix-arg)
		       (truncate (log (car current-prefix-arg) 4))
		     0))
	   (method (elt methods prefix)))
      (unless method
	(user-error "No method for selection number %d" (1+ prefix)))
      (funcall method url))))

(defun open-webs (urls)
  "Open multiple URLs in the same window."
  (when urls
    (open-web-new-window (pop urls))
    (sleep-for 2)
    (dolist (url urls)
      (open-web-same-window url)
      (sleep-for 0.2))))

(defun open-web-new-window (url)
  (let ((browse-url-new-window-flag t))
    (funcall open-web-browser url t)))

(defun open-web-same-window (url)
  (let ((browse-url-new-window-flag nil))
    (funcall open-web-browser url)))

(provide 'open-web)

;;; open-web.el ends here
