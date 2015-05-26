set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2226330554702144));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,110);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/process_type/pl_sviete_apex_html2pdf
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'PROCESS TYPE'
 ,p_name => 'PL.SVIETE.APEX.HTML2PDF'
 ,p_display_name => 'html2pdf'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_execution_function => 'apex_plugin_jsreport.html2pdf'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 1
 ,p_prompt => 'Type'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => false
 ,p_default_value => 'JQS'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2359101420291636 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'jQuery selector'
 ,p_return_value => 'JQS'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2359522974296832 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Page Report'
 ,p_return_value => 'REPORT'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2367102017352106 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Page URL'
 ,p_return_value => 'URL'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2362705708320033 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Page Report'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'REPORT'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 3856014801951420 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'jQuery Selector'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_depending_on_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'JQS'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 3861725153001745 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Paperformat'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => false
 ,p_default_value => 'A4'
 ,p_is_translatable => true
 ,p_depending_on_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_EQUALS'
 ,p_depending_on_expression => 'REPORT'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 3862330694003311 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 3861725153001745 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'A2'
 ,p_return_value => 'A2'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 3862734157004271 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 3861725153001745 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'A3'
 ,p_return_value => 'A3'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 3863137620005348 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 3861725153001745 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'A4'
 ,p_return_value => 'A4'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2364714754331072 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Orientation'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'Portrait'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_EQUALS'
 ,p_depending_on_expression => 'REPORT'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2365113244331702 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2364714754331072 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Landscape'
 ,p_return_value => 'Landscape'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2365609794333362 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2364714754331072 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Portrait'
 ,p_return_value => 'Portrait'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2366625093341428 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'File name'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'report.pdf'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2367527823431303 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 3824314946468245 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 100
 ,p_prompt => 'Page URL'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 2358710693287341 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'URL'
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
