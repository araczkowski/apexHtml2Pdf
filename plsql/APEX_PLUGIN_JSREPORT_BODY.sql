CREATE OR REPLACE PACKAGE BODY apex_plugin_jsreport
IS
  G_REPORT_URL VARCHAR2(32767) :=
  'http://jsreportopenshift-cwms.rhcloud.com/api/report';
  --
  --
  FUNCTION html2pdf(
      p_process IN apex_plugin.t_process ,
      p_plugin  IN apex_plugin.t_plugin )
    RETURN apex_plugin.t_process_exec_result
  IS
  BEGIN
    get_report;
  END;
  --
  --
  PROCEDURE get_binary_from_ws(
      p_report IN OUT BLOB)
  AS
    l_http_request UTL_HTTP.req;
    l_http_response UTL_HTTP.resp;
    l_raw RAW(32767);
    l_http_request_body VARCHAR2(32767);
  BEGIN
    --
    l_http_request_body :=
    '{"template": {                       
"content": "blank",                       
"phantom": {                                  
"url": "http://google.pl",                                  
"header": "HEADER TODO",                                  
"footer": "{#pageNum}/{#numPages}",                                  
"format": "A4",                                  
"orientation": "landscape",                                  
"printDelay": 0                                
}                              
}                          
}'
    ;
    --
    -- Make a HTTP request and get the response.
    l_http_request := UTL_HTTP.begin_request(G_REPORT_URL, 'POST');
    -- Set header's attributes
    UTL_HTTP.set_header(l_http_request, 'Content-Type', 'application/json');
    UTL_HTTP.set_header(l_http_request, 'Content-Length', LENGTH(
    l_http_request_body));
    -- Write request body
    UTL_HTTP.WRITE_TEXT (r => l_http_request, data => l_http_request_body);
    --
    l_http_response := UTL_HTTP.get_response(l_http_request);
    -- Copy the response into the BLOB.
    BEGIN
      LOOP
        UTL_HTTP.read_raw(l_http_response, l_raw, 32766);
        DBMS_LOB.writeappend (p_report, UTL_RAW.length(l_raw), l_raw);
      END LOOP;
    EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(l_http_response);
    END;
  EXCEPTION
  WHEN OTHERS THEN
    UTL_HTTP.end_response(l_http_response);
    DBMS_LOB.freetemporary(p_report);
    RAISE;
  END get_binary_from_ws;
/*
--
--
*/
  PROCEDURE get_report
  IS
    l_blob BLOB;
  BEGIN
    --
    -- Initialize the BLOB.
    DBMS_LOB.createtemporary(l_blob, FALSE);
    -- Call the WS
    get_binary_from_ws(l_blob);
    -- Download the pdf to the browser
    wpg_docload.download_file(l_blob);
    -- Stop page rendering
    apex_application.stop_apex_engine;
    -- Relase the resources associated with the temporary LOB.
    DBMS_LOB.freetemporary(l_blob);
  END;
--
  PROCEDURE test_report
  IS
    l_blob BLOB;
  BEGIN
    --
    -- Initialize the BLOB.
    DBMS_LOB.createtemporary(l_blob, FALSE);
    -- Call the WS
    get_binary_from_ws(l_blob);
    -- Download the pdf to the browser
    wpg_docload.download_file(l_blob);
    -- Stop page rendering
    apex_application.stop_apex_engine;
    -- Relase the resources associated with the temporary LOB.
    DBMS_LOB.freetemporary(l_blob);
  END;

END;
