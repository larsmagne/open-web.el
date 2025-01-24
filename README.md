This is a tiny Emacs package to control opening URLs depending on how
many C-u's you hit before opening a link.

To use:

	(autoload 'open-web "open-web" nil t)
	(setq browse-url-browser-function #'open-web
          browse-url-secondary-browser-function #'open-web)

This is more a proof of concept thing than generally useful.  You will
have to adjust open-web-methods and open-web-browser to your liking.
