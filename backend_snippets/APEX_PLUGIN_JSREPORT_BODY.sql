create or replace PACKAGE BODY apex_plugin_jsreport
IS
  G_REPORT_SERVER_URL VARCHAR2(32767);
  G_REP_BLOB BLOB;
  G_REQUEST_BODY CLOB;
  G_REP_TYPE             VARCHAR2(32767);
  G_REP_FORMAT           VARCHAR2(32767);
  G_REP_ORIENTATION      VARCHAR2(32767);
  G_REP_URL              VARCHAR2(32767);
  G_REP_VIEW_AS          VARCHAR2(32767);
  G_REP_FILE_NAME        VARCHAR2(32767);
  G_REP_HEADER           VARCHAR2(32767);
  G_REP_FOOTER           VARCHAR2(32767);
  G_REP_PRINT_DELAY      NUMBER;
  G_REP_TEMPLATE_SHORTID VARCHAR2(32767);
  G_REP_DATA             VARCHAR2(32767);
  --
  --
  PROCEDURE get_binary_from_ws
  AS
    l_http_request UTL_HTTP.req;
    l_http_response UTL_HTTP.resp;
    l_raw RAW(32767);
    --
    l_chunkStart  NUMBER := 1;
    l_chunkData   VARCHAR2(200);
    l_chunkLength NUMBER := 200;
  BEGIN
    --
    -- Initialize the BLOB.
    DBMS_LOB.createtemporary(G_REP_BLOB, FALSE);
    -- Make a HTTP request and get the response.
    l_http_request := UTL_HTTP.begin_request(G_REPORT_SERVER_URL, 'POST');
    -- Set header's attributes
    UTL_HTTP.set_header(l_http_request, 'Content-Type', 'application/json');
    UTL_HTTP.set_header(l_http_request, 'Content-Length', dbms_lob.getlength(
    G_REQUEST_BODY));
    -- Write request body
    --UTL_HTTP.WRITE_TEXT (r => l_http_request, data => G_REQUEST_BODY);
    LOOP
      l_chunkData := NULL;
      l_chunkData := SUBSTR(G_REQUEST_BODY, l_chunkStart, l_chunkLength);
      UTL_HTTP.write_text(l_http_request, l_chunkData);
      IF (LENGTH(l_chunkData) < l_chunkLength) THEN
        EXIT;
      END IF;
      l_chunkStart := l_chunkStart + l_chunkLength;
    END LOOP;
    --
    l_http_response := UTL_HTTP.get_response(l_http_request);
    -- Copy the response into the BLOB.
    BEGIN
      LOOP
        UTL_HTTP.read_raw(l_http_response, l_raw, 32766);
        DBMS_LOB.writeappend (G_REP_BLOB, UTL_RAW.length(l_raw), l_raw);
      END LOOP;
    EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(l_http_response);
    END;
  EXCEPTION
  WHEN OTHERS THEN
    UTL_HTTP.end_response(l_http_response);
    DBMS_LOB.freetemporary(G_REP_BLOB);
    RAISE;
  END get_binary_from_ws;
--
  PROCEDURE download_report
  IS
  BEGIN
    --
    -- first clear the header
    htp.flush;
    htp.init;
    owa_util.mime_header('application/pdf', FALSE );
    htp.p( 'Content-length: ' || dbms_lob.getlength(G_REP_BLOB));
    -- The filename will be used by the browser if the users does a "Save as"
    htp.p('Content-Disposition:'|| G_REP_VIEW_AS || '; filename="' ||
    G_REP_FILE_NAME || '"');
    owa_util.http_header_close;
    -- Download the BLOB
    wpg_docload.download_file(G_REP_BLOB);
    -- Stop page rendering
    apex_application.stop_apex_engine;
    -- Relase the resources associated with the temporary LOB.
    DBMS_LOB.freetemporary(G_REP_BLOB);
  END;
--
  PROCEDURE get_url_report
  IS
    l_template JSON;
    l_phantom JSON;
    l_request_body JSON;
  BEGIN
    --
    l_request_body := json(); --an empty structure
    l_template     := json();
    l_phantom      := json();
    --
    l_template.put('content', 'blank');
    --
    l_phantom.put('url', g_rep_url);
    l_phantom.put('header', g_rep_header);
    l_phantom.put('footer', g_rep_footer);
    l_phantom.put('format', g_rep_format);
    l_phantom.put('orientation', g_rep_orientation);
    l_phantom.put('printDelay', g_rep_print_delay);
    l_template.put('phantom', l_phantom);
    l_request_body.put('template', l_template);
    --
    G_REQUEST_BODY := empty_clob();
    dbms_lob.createtemporary(G_REQUEST_BODY, true);
    l_request_body.to_clob(G_REQUEST_BODY, true);
    --
    -- Call the WS
    get_binary_from_ws;
    --
    -- Download the report to the browser
    download_report;
    --
  END;
--
  PROCEDURE get_content_report
  IS
    l_template JSON;
    l_phantom JSON;
    l_request_body JSON;
    l_html CLOB;
    l_content_clob CLOB;
    l_request CLOB;
    l_content json_value;
  BEGIN
    -- get the html from the collection
    SELECT
      CLOB001
    INTO
      l_html
    FROM
      apex_collections
    WHERE
      collection_name = 'CLOB_CONTENT';
    --
    --
    --l_content_clob := '{#child apex_css} <img src=''https://raw.githubusercontent.com/araczkowski/apexHtml2Pdf/master/frontend_snippets/logo.png'' style="display: none;">';
    l_content_clob := '{#child apex_css}';
    dbms_lob.append(l_content_clob, l_html);
    l_request_body := JSON(); --an empty structure
    l_template     := JSON();
    l_phantom      := JSON();
    l_content      := json_value(l_content_clob);

    l_template.put('content', L_CONTENT);
    l_phantom.put('header', g_rep_header);
    l_phantom.put('footer', g_rep_footer);
    l_phantom.put('format', g_rep_format);
    l_phantom.put('orientation', g_rep_orientation);
    l_phantom.put('printDelay', g_rep_print_delay);
    l_template.put('phantom', l_phantom);
    l_request_body.put('template', l_template);
    --
    G_REQUEST_BODY := empty_clob();
    dbms_lob.createtemporary(G_REQUEST_BODY,true);
    l_request_body.to_clob(G_REQUEST_BODY);
    --
    -- Call the WS
    get_binary_from_ws;
    --
    dbms_lob.freetemporary(G_REQUEST_BODY);
    -- Download the report to the browser
    download_report;
    --
  END;
--
--
  PROCEDURE get_template_report
  IS
    l_template JSON;
    l_phantom JSON;
    l_request_body JSON;
    l_data JSON;
  BEGIN
    --
    l_request_body := json(); --an empty structure
    l_template     := json();
    l_phantom      := json();
    l_data         := json();
    --
    l_data := JSON(G_REP_DATA);
    --
    l_template.put('shortid', g_rep_template_shortid);
    l_phantom.put('header', g_rep_header);
    l_phantom.put('footer', g_rep_footer);
    l_phantom.put('format', g_rep_format);
    l_phantom.put('orientation', g_rep_orientation);
    l_phantom.put('printDelay', g_rep_print_delay);
    l_template.put('phantom', l_phantom);
    --
    l_request_body.put('template', l_template);
    l_request_body.put('data', l_data);
    --
    G_REQUEST_BODY := empty_clob();
    dbms_lob.createtemporary(G_REQUEST_BODY, true);
    l_request_body.to_clob(G_REQUEST_BODY, true);
    --
    -- Call the WS
    get_binary_from_ws;
    --
    -- Download the report to the browser
    download_report;
    --
  END;
--
/*
--
--
*/
--
--
  FUNCTION html2pdf(
      p_process IN apex_plugin.t_process ,
      p_plugin  IN apex_plugin.t_plugin )
    RETURN apex_plugin.t_process_exec_result
  IS
    l_result apex_plugin.t_process_exec_result;
  BEGIN
    G_REP_TYPE             := p_process.attribute_01;
    G_REP_FORMAT           := p_process.attribute_07;
    G_REP_ORIENTATION      := p_process.attribute_08;
    G_REP_FILE_NAME        := p_process.attribute_09;
    G_REP_URL              := p_process.attribute_10;
    G_REP_VIEW_AS          := p_process.attribute_11;
    G_REP_PRINT_DELAY      := p_process.attribute_12;
    G_REP_HEADER           := p_process.attribute_13;
    G_REP_FOOTER           := p_process.attribute_14;
    G_REPORT_SERVER_URL    := p_process.attribute_02;
    G_REP_TEMPLATE_SHORTID := p_process.attribute_03;
    G_REP_DATA             := p_process.attribute_04;
    --
    IF G_REP_TYPE = 'URL' THEN
      --
      get_url_report;
      --
    ELSIF G_REP_TYPE = 'CLOB_CONTENT' THEN
      --
      get_content_report;
      --
    ELSIF G_REP_TYPE = 'template' THEN
      --
      get_template_report;
      --
    ELSE
      raise_application_error(-20001, G_REP_type || ' not supported!');
    END IF;
    --
    --
    l_result.success_message := p_process.success_message;
    RETURN l_result;
  END;
--
END;
/
