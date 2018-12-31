# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

setup_nssdb:
  cmd.run:
    - name: bash /srv/salt/base/httpd/pki/nssdbsetup/nssdbsetup.sh
