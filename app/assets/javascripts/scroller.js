var scroller = function(sourceElement, destinationElement) {
  $(sourceElement).on('click', function(e){
      e.preventDefault();
      var target = $(destinationElement);
      $('html, body').stop().animate({
         scrollTop: target.offset().top
      }, 1000);
  });
};
