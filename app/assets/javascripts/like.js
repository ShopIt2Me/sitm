 function removeProduct(e) {
  e.preventDefault();
  $('#grid').masonry('remove', $(this).closest('li'));
}

function addClickA() {
  $('.side-a-img').click(function () {
    $($(this).parent().parent()).addClass('wrap-flip')
})}

function addClickB() {
  $('.side-b').click(function () {
    $($(this).parent()).removeClass('wrap-flip')
})}

