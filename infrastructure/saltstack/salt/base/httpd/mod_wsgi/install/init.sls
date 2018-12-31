# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

#TODO: This file needs to be moved to the CSEWeb app folder.

#include:
#    - base.httpd.install

mod_wsgi:
  pkg.installed

#TODO: move this section to CSEWeb app install section

/var/www/html/cse:
  file.directory:
    - user: apache
    - group: apache
    - mode: 755
    - makedirs: True

/var/www/html/cse/web/:
  file.directory:
    - user: apache
    - group: apache
    - mode: 755
    - makedirs: True

/var/www/html/cse/web/cseweb.wsgi:
  file.managed:
    - source: salt://base/httpd/mod_wsgi/conf/cseweb.wsgi.jinja
#    - require:
#      - pkg: httpd
