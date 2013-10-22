 function removeProduct(e) {
  e.preventDefault();
  $('#grid').masonry('remove', $(this).closest('li'));
}

function addClickA(e) {
  $('.side-a').click(function () {
    $($(this).parent()).addClass('wrap-flip')
    $(this).parent().find('.like').hide()
    $(this).parent().find('.dislike').hide()
})}

function addClickB() {
  $('.side-b').click(function () {
    $($(this).parent()).removeClass('wrap-flip')
    $($(this).parent()).one('webkitTransitionEnd', function(){
        $(this).parent().find('.like').show()
        $(this).parent().find('.dislike').show()
    })
})}

function callLikeAction(e) {
  e.preventDefault();
  $.post('products/like', {session_key:($("#sessionkey").html()) , product_id: this.dataset.productid})
  .done(function(response){
    $("li").find("[data-productid='" + response + "']").addClass('liked');
    $("li").find("[data-productid='" + response + "']").find('a.heart').addClass('liked');
    $("li").find("[data-productid='" + response + "']").find('a.fire').html('');
    $("li").find("[data-productid='" + response + "']").unbind('click')
  })
}
