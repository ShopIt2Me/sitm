var AppController = {
  init: function() {
    AppController.ensureCorrectAJAXSessionTokens();
    AppController.$container = $('#grid');
    AppController.bindEvents();
  },

  bindEvents: function() {
    AppController.bindMasonry();
    AppController.bindInfiniteScroll();
  },

  ensureCorrectAJAXSessionTokens: function() {
    // ensure all AJAX calls get sent with the right X-CSRF-Token (such
    // that all front-end and back-end sessions will be properly matched)
    $(document).ajaxSend(function(e, xhr, options) {
      var token = $("meta[name='csrf-token']").attr("content");
      xhr.setRequestHeader("X-CSRF-Token", token);
    });
  },

  bindMasonry: function() {
    AppController.$container.imagesLoaded(function(){
      AppController.$container.masonry({
        itemSelector: '.product'
      });
    });
  },

  bindInfiniteScroll: function() {
    AppController.$container.infinitescroll({
      navSelector  : '#page-nav',    // selector for the paged navigation
      nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
      itemSelector : '.product',        // selector for all items you'll retrieve
      loading: {
        msgText: '',
        finishedMsg: ''
      },
      errorCallback: function() {
        $('#infinite-scroll-end').show();
      }
    }, function( newElements ) { // trigger Masonry as a callback
        // hide new items while they are loading
        var $newElems = $( newElements );
        // ensure that images load before adding to masonry layout
        $newElems.imagesLoaded(function(){
          AppController.$container.masonry( 'appended', $newElems, true );
          applyBehaviors($newElems);
        });
      }
    );
  },

  bindLoadMoreProducts: function() {

  },

  selectGender: function() {


  }
}
