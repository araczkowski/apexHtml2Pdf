CREATE OR REPLACE PACKAGE apex_plugin_jsreport
IS
  --
  FUNCTION html2pdf(
      p_process IN apex_plugin.t_process ,
      p_plugin  IN apex_plugin.t_plugin )
    RETURN apex_plugin.t_process_exec_result;
  --
END;
