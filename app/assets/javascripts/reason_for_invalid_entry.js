$(function(){

  // pop up #example1, #example2, #example3 with same content
  $('[rel=popover]').popover({
    html: true,
    content: function() {
      return $('#popover_content_wrapper').html();
    }
  });

});
