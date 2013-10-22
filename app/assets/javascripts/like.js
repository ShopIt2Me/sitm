 function removeProduct(e) {
  e.preventDefault();
  $('#grid').masonry('remove', $(this).closest('li'));
  $('#grid').masonry();
}

