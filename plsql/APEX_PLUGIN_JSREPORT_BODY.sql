CREATE OR REPLACE PACKAGE BODY apex_plugin_jsreport
IS
  G_REPORT_URL VARCHAR2(32767) :=
  'http://jsreportopenshift-cwms.rhcloud.com/api/report';
  --
  G_REQUEST_BODY    VARCHAR2(32767);
  G_REP_type        VARCHAR2(32767);
  G_REP_format      VARCHAR2(32767);
  G_REP_orientation VARCHAR2(32767);
  G_REP_URL         VARCHAR2(32767);
  G_REP_VIEW_AS     VARCHAR2(32767);
  G_REP_FILE_NAME   VARCHAR2(32767);
  --
  PROCEDURE get_binary_from_ws(
      p_report IN OUT BLOB )
  AS
    l_http_request UTL_HTTP.req;
    l_http_response UTL_HTTP.resp;
    l_raw RAW(32767);
  BEGIN
    --
    -- Make a HTTP request and get the response.
    l_http_request := UTL_HTTP.begin_request(G_REPORT_URL, 'POST');
    -- Set header's attributes
    UTL_HTTP.set_header(l_http_request, 'Content-Type', 'application/json');
    UTL_HTTP.set_header(l_http_request, 'Content-Length', LENGTH(
    G_REQUEST_BODY));
    -- Write request body
    UTL_HTTP.WRITE_TEXT (r => l_http_request, data => G_REQUEST_BODY);
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
--
  PROCEDURE get_url_report
  IS
    l_blob BLOB;
    l_template JSON;
    l_phantom JSON;
    l_request_body JSON;
  BEGIN
    --
    -- Initialize the BLOB.
    DBMS_LOB.createtemporary(l_blob, FALSE);
    l_request_body := json(); --an empty structure
    l_template     := json();
    l_phantom      := json();
    --
    l_template.put('content', 'blank');
    --
    l_phantom.put('url', g_rep_url);
    l_phantom.put('header', 'TODO_HEADER');
    l_phantom.put('footer', 'TODO');
    l_phantom.put('format', g_rep_format);
    l_phantom.put('orientation', g_rep_orientation);
    l_phantom.put('printDelay', 0);
    --
    l_template.put('phantom', l_phantom);
    --
    l_request_body.put('template', l_template);
    --
    G_request_body := l_request_body.to_char;
    --
    --
    -- Call the WS
    get_binary_from_ws(l_blob);
    -- Download the pdf to the browser
    -- Set the size so the browser knows how much it will be downloading.
    owa_util.mime_header('application/pdf', FALSE );
    htp.p( 'Content-length: ' || dbms_lob.getlength(l_blob));
    -- The filename will be used by the browser if the users does a "Save as"
    htp.p( 'Content-Disposition: filename="' || G_REP_FILE_NAME || '"' );
    owa_util.http_header_close;
    -- Download the BLOB
    wpg_docload.download_file(l_blob);
    -- Stop page rendering
    apex_application.stop_apex_engine;
    -- Relase the resources associated with the temporary LOB.
    DBMS_LOB.freetemporary(l_blob);
  END;
--
/*
--
--
*/
  PROCEDURE get_report(
      p_content CLOB DEFAULT NULL,
      p_url VARCHAR2 DEFAULT NULL)
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
--
  FUNCTION html2pdf(
      p_process IN apex_plugin.t_process ,
      p_plugin  IN apex_plugin.t_plugin )
    RETURN apex_plugin.t_process_exec_result
  IS
  BEGIN
    G_REP_type        := p_process.attribute_01;
    G_REP_format      := p_process.attribute_07;
    G_REP_orientation := p_process.attribute_08;
    G_REP_URL         := p_process.attribute_10;
    IF G_REP_type      = 'URL' THEN
      --
      get_url_report();
      --
    ELSIF G_REP_type = 'REPORT' THEN
      NULL;
    ELSIF G_REP_type = 'JQS' THEN
      NULL;
    ELSE
      raise_application_error(-20001, G_REP_type || ' not supported!');
    END IF;
  END;
--
END;
