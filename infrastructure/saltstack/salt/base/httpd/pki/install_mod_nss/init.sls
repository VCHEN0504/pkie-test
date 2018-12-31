# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

#install httpd
mod_nss:
  pkg.installed

#apply nss config to apache http to enforce client/server mutual certificate authentication
/etc/httpd/conf.d/nss.conf:
  file.managed:
    - source: salt://base/httpd/pki/config/nss.conf.jinja
    - require:
      - pkg: mod_nss
    - template: jinja

#sets "coding" for httpd to start with FIPS mode and NSSEngine ON
/etc/httpd/conf/code.conf:
  file.managed:
    - source: salt://base/httpd/pki/config/code.conf.jinja


#creating mod_nss logs directory
{% if not salt['file.directory_exists']('/var/log/httpd/mod_nss/logs/')%}
  cmd.run:
    - name: mkdir -p /var/log/httpd/mod_nss/logs/
{% else %}
  cmd.run:
    - name: echo "Directory Exists"
{% endif %}

# creating specific error logs for mod_nss
/var/log/httpd/mod_nss/logs/error_log:
  file.touch

# creating specific access logs for mod_nss
/var/log/httpd/mod_nss/logs/access_log:
  file.touch

#removing detail nssdb installation
/etc/httpd/alias:
  file.absent

# Setting httpd for user attribution logging

/var/log/httpd/client_access_log:
  file.touch
