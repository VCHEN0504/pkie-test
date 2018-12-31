# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

include:
    - base.httpd.pki.install_mod_nss # install mod_nss and configs
    - base.httpd.pki.nssdbsetup      # install nssdb and create a self signed cert for cseweb.
