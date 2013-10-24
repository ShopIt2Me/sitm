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
  },

  bindLoadMoreProducts: function() {

  },

  selectGender: function() {


  }
}
