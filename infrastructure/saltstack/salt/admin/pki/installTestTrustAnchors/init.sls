install_test_trust_anchors:
  cmd.run:
    - name: bash /srv/salt/admin/pki/installTestTrustAnchors/Install_testCA.sh
restart_httpd_after_install_test_trust_anchors:
  cmd.run:
    - name: service httpd restart
    - watch:
      - cmd: install_test_trust_anchors
