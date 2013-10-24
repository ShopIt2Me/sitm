var ProductController = {
  init: function() {
    ProductController.$container = $('#grid');
    ProductController.bindEvents();
  },

  bindEvents: function() {
    ProductController.$container.on('click', '.flipper', ProductController.flip);
    ProductController.$container.on('click', '.dislike', ProductController.dislike);
    ProductController.$container.on('click', '.like', ProductController.preventDuplicateLikes);
    ProductController.$container.on('ajax:success', '.like', ProductController.like);
  },

  like: function(e) {
    $(this).closest('.product').addClass('liked');
  },

  preventDuplicateLikes: function(e) {
    if ($(this).closest('.liked').length) {
      e.preventDefault();
      e.stopPropagation();
    }
  },

  dislike: function(e){
    e.preventDefault();
    ProductController.$container.masonry('remove', $(this).closest('.product'));
    ProductController.$container.masonry();
  },

  flip: function(e){
    if ($(e.target).hasClass('like')) {
      return;
    }

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
