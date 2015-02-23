setPercentageClass = function(total) {
  $.each($('.percentage-container'), function(){
    if (total < 100){
      this.style.color = '#E6C200';
    }else if (total > 100) {
      this.style.color = 'red';
    }else {
      this.style.color = 'green';
    }
  });
};

calculatePercentage = function() {
  var total = 0;
  $.each($('.criteria'), function(i){
    total += parseInt(this.value) || 0;
  });
  $.each($('.total-percentage'), function(){
    $(this).text(total + '%');
  });
  setPercentageClass(total);
};

addEventHandlers = function(){
  $.each($('.criteria'), function(i){
    $(this).on('input', function() {
      calculatePercentage();
    });
  });
};
