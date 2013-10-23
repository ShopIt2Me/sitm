function removeProduct(e) {
  e.preventDefault();
  $('#grid').masonry('remove', $(this).closest('li'));
  $('#grid').masonry();
}

function flipForward () {
    $(this).parent().addClass('wrap-flip')
    $(this).parent().find('.like').hide()
    $(this).parent().find('.dislike').hide()
}

function flipBack () {
    $(this).parent().removeClass('wrap-flip')
    $(this).parent().one('webkitTransitionEnd', function(){
        $(this).parent().find('.like').show()
        $(this).parent().find('.dislike').show()
    })
}

function onLikeDone(e, response){
  $(this).closest('.product').addClass('liked');

  var $productWrap = $(this).parent();
  var $likeAnchor = $(this).find('a.likeicon');
  var $dislikeAnchor = $productWrap.find('a.dislikeicon');
  $(this).addClass('liked');
  $productWrap.find('.dislike').addClass("liked");
  $(this).append("<span class='likeicon liked'>" + $likeAnchor.text() + "</span>");
  $likeAnchor.remove();
  $dislikeAnchor.remove();
  //$("li").find("[data-productid='" + response + "']").addClass('liked');
  //$("li").find("[data-productid='" + response + "']").find('a.likeicon').addClass('liked');
  //$("li").find("[data-productid='" + response + "']").find('a.dislikeicon').html('');
  //$("li").find("[data-productid='" + response + "']").unbind('click')
}

function callLikeAction(e) {
  e.preventDefault();
  // var req = $.post('products/like', {session_key:($("#sessionkey").html()) , product_id: this.dataset.productid});
  // req.done(onLikeDone);

  hideInfiniteScrollEnd();
  reactivateInfiniteScroll();
}

