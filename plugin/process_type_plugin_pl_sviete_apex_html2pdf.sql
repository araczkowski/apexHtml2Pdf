set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.0.00.31'
,p_default_workspace_id=>2226330554702144
,p_default_application_id=>100
,p_default_owner=>'SVIETE'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/process_type/pl_sviete_apex_html2pdf
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(5692521157656991)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'PL.SVIETE.APEX.HTML2PDF'
,p_display_name=>'html2pdf'
,p_supported_ui_types=>'DESKTOP'
,p_execution_function=>'apex_plugin_jsreport.html2pdf'
,p_standard_attributes=>'REGION'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4270108119306580)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>1
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'URL'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4270506609307290)
,p_plugin_attribute_id=>wwv_flow_api.id(4270108119306580)
,p_display_sequence=>10
,p_display_value=>'Web page URL'
,p_return_value=>'URL'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4270923849314496)
,p_plugin_attribute_id=>wwv_flow_api.id(4270108119306580)
,p_display_sequence=>20
,p_display_value=>'HTML from CLOB_CONTENT connection'
,p_return_value=>'CLOB_CONTENT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1905391903494263)
,p_plugin_attribute_id=>wwv_flow_api.id(4270108119306580)
,p_display_sequence=>30
,p_display_value=>'Template'
,p_return_value=>'template'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1903882372439445)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Report Server URL'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'http://jsreportopenshift-hurtemgo.rhcloud.com/api/report'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1906530166580537)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Template Short Id'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(4270108119306580)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'template'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1908460580674874)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Report Data'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(4270108119306580)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'template'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(5729931364190491)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Paperformat'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'A4'
,p_is_translatable=>true
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(5730536905192057)
,p_plugin_attribute_id=>wwv_flow_api.id(5729931364190491)
,p_display_sequence=>10
,p_display_value=>'A2'
,p_return_value=>'A2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(5730940368193017)
,p_plugin_attribute_id=>wwv_flow_api.id(5729931364190491)
,p_display_sequence=>20
,p_display_value=>'A3'
,p_return_value=>'A3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(5731343831194094)
,p_plugin_attribute_id=>wwv_flow_api.id(5729931364190491)
,p_display_sequence=>30
,p_display_value=>'A4'
,p_return_value=>'A4'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4232920965519818)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Orientation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'Portrait'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4233319455520448)
,p_plugin_attribute_id=>wwv_flow_api.id(4232920965519818)
,p_display_sequence=>10
,p_display_value=>'Landscape'
,p_return_value=>'Landscape'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4233816005522108)
,p_plugin_attribute_id=>wwv_flow_api.id(4232920965519818)
,p_display_sequence=>20
,p_display_value=>'Portrait'
,p_return_value=>'Portrait'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4234831304530174)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'File name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'report.pdf'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4235734034620049)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>2
,p_prompt=>'Page URL'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(4270108119306580)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'URL'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4239519090619776)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'View As'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'inline'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4239934605627847)
,p_plugin_attribute_id=>wwv_flow_api.id(4239519090619776)
,p_display_sequence=>10
,p_display_value=>'attachment'
,p_return_value=>'attachment'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(4240323391632987)
,p_plugin_attribute_id=>wwv_flow_api.id(4239519090619776)
,p_display_sequence=>20
,p_display_value=>'inline'
,p_return_value=>'inline'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4241921530800994)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Print Delay'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'0'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4242309668806478)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Header'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4242738554808312)
,p_plugin_id=>wwv_flow_api.id(5692521157656991)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Footer'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
