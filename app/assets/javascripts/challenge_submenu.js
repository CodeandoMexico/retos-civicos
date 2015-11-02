$(document).ready(function(){
  $('#challenge__submenu a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
    // remove class from all tabs
    $('#challenge__submenu a').removeClass('active');
    
    // add this element the active class
    $(this).addClass('active');
  });
});
