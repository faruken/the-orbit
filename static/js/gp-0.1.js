$(document).ready(function() {
  
  // When New Game is clicked, `ng` is fired up to reload the window. This
  // returns player to level 1.
  $('#ng').click(function() {
    location.reload();
    return false;
  });
  
  $( "#from" ).datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 3,
    onClose: function( selectedDate ) {
        $( "#to" ).datepicker( "option", "minDate", selectedDate );
    }
  });
    $( "#to" ).datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 3,
    onClose: function( selectedDate ) {
      $( "#from" ).datepicker( "option", "maxDate", selectedDate );
    }
  });
  
  // Fill auto-suggestion list.
  $('.search-query').typeahead({source: get_usernames()});
  
  // Fancy loading window appear if an AJAX request happens. We bind this
  // window here.
  $('#loading').bind('ajaxSend', function() {
    $(this).show();
  });
  $('#loading').bind('ajaxError', function(x) {
    $(this).hide();
    $('#ajaxerr').html('<div class="alert alert-block">Sorry, an error occured!!1</div>').show();
  });
  $('#loading').bind('ajaxSuccess', function() {
    $(this).hide();
  });

});

/*
  Get all the usernames of players from database. This is used for username
  auto-suggestion.
*/
function get_usernames() {
  var url = 'http://127.0.0.1:5984/gwyneth/_design/scores/_view/high_scores_alltime?group=true';
  var l = [];
  $.getJSON(url, function(data) {
    for(var j in data.rows) {
      l[j] = data.rows[j].key[0];
    }
  });
  return l;
}