(require 'ox-publish)
(setq org-publish-project-alist
			'(
				("org-notes"
				 :base-directory "~/dhome/R_training/materials/org" ; ALTER THIS LINE TO POINT TO THE BASE DIRECTORY OF THE REPOSITORY
				 :base-extension "org"
				 :publishing-directory "~/dhome/R_training/materials/html"
				 :recursive t
				 :publishing-function org-html-publish-to-html
				 :headline-levels 4
				 :auto-preamble t
				 )
				("org-static"
				 :base-directory "~/dhome/R_training/materials/org"  ; ALTER THIS LINE TO POINT TO THE BASE DIRECTORY OF THE REPOSITORY
				 :base-extension "css\\|png\\|jpg\\|gif\\|pdf\\|csv\\|rds\\|zip\\|R\\|Rmd"
				 :publishing-directory "~/dhome/R_training/materials/html" ; ALTER THIS LINE TO POINT TO WHERE YOU WANT THE HTML FILES
				 :recursive t
				 :publishing-function org-publish-attachment
				 )
				("org" :components ("org-notes" "org-static"))
				))
