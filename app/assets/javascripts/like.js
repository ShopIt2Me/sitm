function callLikeAction(e) {
  e.preventDefault();
  $.post('products/like', {session_key:($("#sessionkey").html()) , product_id: this.dataset.productid})
  .done(function(){
    // change the appearance of the heart
  })
}
 
function removeProduct(e) {
  e.preventDefault();
  $('#grid').masonry('remove', $(this).closest('li'));
  $('#grid').masonry('reloadItems');
  $('#grid').masonry('reload');
}

