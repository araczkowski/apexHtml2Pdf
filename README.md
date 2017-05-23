# apexHtml2Pdf

a new solution to for the reporting in Oracle APEX

[![jsreport in Oracle APEX ](http://img.youtube.com/vi/BIJZG6dx1z4/0.jpg)](http://www.youtube.com/watch?v=BIJZG6dx1z4)



# HOWTO

**1. this plugin requires the JSON support in DB, so first install the pljson library**

Step by step:

clone pljson repo
```git clone https://github.com/araczkowski/pljson```

in the terminal go to the repo directory
```cd pljson```

connect to Oracle DB as user/schema that you are using in your apex app
```sqlplus user/pass@sid```

run the installation scirpt
```@install.sql```



**2. install the plugin**

replace the package body for JSON_PRINTER, using this version: https://github.com/araczkowski/apexHtml2Pdf/blob/master/backend_snippets/JSON_PRINTER.sql

install the plugin
https://github.com/araczkowski/apexHtml2Pdf/blob/master/backend_snippets/APEX_PLUGIN_JSREPORT_SPEC.sql
https://github.com/araczkowski/apexHtml2Pdf/blob/master/backend_snippets/APEX_PLUGIN_JSREPORT_BODY.sql

configure ACL:
https://github.com/araczkowski/apexHtml2Pdf/blob/master/backend_snippets/acl.sql

add grants:
https://github.com/araczkowski/apexHtml2Pdf/blob/master/backend_snippets/grants.sql

install demo app:
https://github.com/araczkowski/apexHtml2Pdf/blob/master/backend_snippets/f100.sql

