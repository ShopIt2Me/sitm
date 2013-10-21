 function removeProduct(e) {
  e.preventDefault();
  $('#grid').masonry('remove', $(this).closest('li'));
}

function addClickA() {
  $('.side-a').click(function () {
    $($(this).parent()).addClass('wrap-flip')
})}

function addClickB() {
  $('.side-b').click(function () {
    $($(this).parent()).removeClass('wrap-flip')
})}

