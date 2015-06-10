BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl(acl         => 'jsreport_base_acl.xml'
                                   ,description => 'An ACL for the jsreportopenshift-hurtemgo.rhcloud.com website'
                                   ,principal   => 'SVIETE'
                                   ,is_grant    => TRUE
                                   ,privilege   => 'connect'
                                   ,start_date  => SYSTIMESTAMP
                                   ,end_date    => NULL);

  DBMS_NETWORK_ACL_ADMIN.assign_acl(acl        => 'jsreport_base_acl.xml'
                                   ,host       => 'jsreportopenshift-hurtemgo.rhcloud.com'
                                   ,lower_port => 80
                                   ,upper_port => 80);

  COMMIT;
END;
