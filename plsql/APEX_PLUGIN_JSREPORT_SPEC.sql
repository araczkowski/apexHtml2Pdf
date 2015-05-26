CREATE OR REPLACE PACKAGE apex_plugin_jsreport
IS
  --
  FUNCTION html2pdf(
      p_process IN apex_plugin.t_process ,
      p_plugin  IN apex_plugin.t_plugin )
    RETURN apex_plugin.t_process_exec_result;
  --
  PROCEDURE get_report(
      p_content IN CLOB DEFAULT NULL,
      p_url     IN VARCHAR2 DEFAULT NULL);
  --
END;
