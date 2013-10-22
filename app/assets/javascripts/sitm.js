function Sitm() {
  this.init();
}

Sitm.prototype.init = function() {
  this.initAttributes();
  this.applyBehaviors();
}

Sitm.prototype.initAttributes = function() {
  this.$container = $('#grid');
}

Sitm.prototype.applyBehaviors = function() {
  this.bindInfiniteScroll();
}

Sitm.prototype.bindInfiniteScroll = function() {
  this.$container.imagesLoaded(function(){
    this.$container.masonry({
      itemSelector: '.item'
    });
  });

  this.$container.infinitescroll({
    navSelector  : '#page-nav',    // selector for the paged navigation
    nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
    itemSelector : '.item',        // selector for all items you'll retrieve
    loading: {
      // img: 'http://i.imgur.com/6RMhx.gif',
      msgText: '',
      finishedMsg: '',
      speed: 0
    },
    errorCallback: function() {
      $('#infinite-scroll-end').show();
    }
  }, function( newElements ) { // trigger Masonry as a callback
      // hide new items while they are loading
      var $newElems = $( newElements );
      // ensure that images load before adding to masonry layout
      $newElems.imagesLoaded(function(){
        this.$container.masonry( 'appended', $newElems, true );
        applyBehaviors($newElems);
        $newElems.css({opacity: 1})
      });
    }
  );

  applyInfiniteScrollEndBehaviors(this.$container);
}