
  var connection_count = 0;

  function start_chat() {
    connection_count = connection_count + 1;

    $.ajax({
      url: "/messages",
      //        dataType: 'json',
      cache: false,
      beforeSend: function(request) { 
        $('#debug').prepend('starting ' + connection_count +'<BR>');
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        $('#debug').prepend(textStataus + ': ' + errorThrown + '<BR>');
        start_chat();
      },
      success: function(html){
        $('#messages').prepend(html);
        start_chat();
      }
    });
  }

  $(function(){
    start_chat();
  
    $('form').submit(function(){
      $.post("/messages", $("form").serialize());
      return false;
    });
  });

