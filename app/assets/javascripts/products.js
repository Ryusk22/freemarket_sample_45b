$(document).ready(function(){
  $('.photo-sub__item--img:first').addClass('active');
  $('.photo-sub__item--img').mouseover(function() {
    $('.photo-sub__item--img').removeClass('active');
    $(this).addClass('active');
  });
});
