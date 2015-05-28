var clobObj = new apex.ajax.clob(  function(p) {    
  if (p.readyState == 4) {
    // upload is done
    apex.submit('HTML');    
  }  
});  
var html = $('#apexir_DATA_PANEL').html();
clobObj._set(html);
