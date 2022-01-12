$(document).ready(function() {
  $('#navbarDropdown').mouseenter(function() {
    $('.dropdown-menu').slideToggle(300, "linear");
  });
  
  $('.dropdown-menu').mouseleave(function() {
    $(this).slideToggle(300, "linear");
  });
});