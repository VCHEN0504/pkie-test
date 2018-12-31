# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

#install httpd
httpd:
  pkg.installed

# enable httpd service to be up after a reboot
enable_httpd_service:
  service:
    - name: httpd
    - running
    - enable: True

/var/www:
  file.directory:
    - user: apache
    - group: apache
    - mode: 755
    - recurse:
      - mode

/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://base/httpd/conf/httpd.conf.jinja
    - require:
      - pkg: httpd

/etc/httpd/conf.d/cache.conf:
  file.managed:
    - source: salt://base/httpd/conf/cache.conf.jinja
    - require:
      - pkg: httpd

/etc/httpd/conf.d/deflate.conf:
  file.managed:
    - source: salt://base/httpd/conf/deflate.conf.jinja
    - require:
      - pkg: httpd

