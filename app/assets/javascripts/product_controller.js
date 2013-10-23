var ProductController = {
  init: function() {
    ProductController.$container = $('#grid');
    ProductController.bindEvents();
  },

  bindEvents: function() {
    ProductController.$container.on('click', '.flipper', ProductController.flip);
    ProductController.$container.on('click', '.dislike', ProductController.dislike);
    ProductController.$container.on('ajax:success', '.like', ProductController.like);
  },

  like: function(e) {
    $(this).closest('.product').addClass('liked');
  },

  dislike: function(e){
    $(this).closest('.product').remove();
    ProductController.$container.masonry();
    e.preventDefault();
  },

  flip: function(e){
    var returnIfClasses = ['like', 'dislike'];
    $.each(returnIfClasses, function(i, klass) {
      if ($(e.target).hasClass(klass)) return;
    });

    // 'this' will be the item on which we are listening for the event, *not* ProductController
    var $productItem = $(this);
    $productItem.toggleClass('flipping')

    $productItem.one('webkitTransitionEnd', function() {
      $productItem.toggleClass('flipped');
      $productItem.removeClass('flipping-forward');
    });

    if ($productItem.hasClass('flipped')) {
      $productItem.addClass('flipping-forward');
    }
  }

};
