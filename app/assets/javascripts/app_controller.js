var AppController = {
  init: function() {

    AppController.ensureCorrectAJAXSessionTokens();
    AppController.$container = $('#grid');
    AppController.$infiniteScrollEnd = $('#infinite-scroll-end');
    AppController.loadRandomProductsUrl = $('#page-nav a').attr('href') + '&fill_with_random=true';
    AppController.bindEvents();

  },

  bindEvents: function() {
    AppController.bindMasonry();
    AppController.bindInfiniteScroll();
    AppController.bindLoadMoreProducts();
    AppController.bindTooltips();
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
      itemSelector : '.product',     // selector for all items you'll retrieve
      loading: {
        msgText: '',
        finishedMsg: ''
      },
      errorCallback: function() {
        // infiniteScroll calls this method when it gets an empty response
        // show footer with load more items link
        AppController.showInfiniteScrollEnd();
      }
    }, function(newElements) { // trigger Masonry as a callback
        // hide new items while they are loading
        var $newElems = $(newElements);
        // ensure that images load before adding to masonry layout
        $newElems.imagesLoaded(function(){
          AppController.$container.masonry('appended', $newElems, true);
        });
      }
    );
  },

  showInfiniteScrollEnd: function() {
    AppController.$infiniteScrollEnd.show();
  },

  hideInfiniteScrollEnd: function() {
    AppController.$infiniteScrollEnd.hide();
  },

  bindLoadMoreProducts: function() {
    AppController.$infiniteScrollEnd.find('.more-random').on('click', function() {
      var isAjaxHappening;

      if (!isAjaxHappening) {
        isAjaxHappening = true;
        $.get(AppController.loadRandomProductsUrl, function(response) {

          var filteredResponse = AppController.filterProductsAJAXResponse(response);

          AppController.$container.append(filteredResponse);
          AppController.$container.imagesLoaded(function(){
            AppController.$container.masonry('appended', filteredResponse, true);
            AppController.hideInfiniteScrollEnd();
            AppController.reactivateInfiniteScroll();
          });
        }).done(function() {
          isAjaxHappening = false;
        })
      }

      return false;
    });
  },

  filterProductsAJAXResponse: function(response) {
    // Filter malformed HTML text nodes
    return $(response).filter(function() { return this.nodeType !== 3 });
  },

  reactivateInfiniteScroll: function() {
    // jquery.infinitescroll unbinds itself when a request returns empty
    // this method changes its internal state so it can be binded again
    AppController.$container.infinitescroll('update', {
      state: {
        isDuringAjax: false,
        isDone: false
      }
    });
    AppController.$container.infinitescroll('bind');
  },

  selectGender: function() {

  },

  bindTooltips: function(){
    $('#men').tooltipsy({
    content: "Only men's selection loading next",
    offset: [-10, 20]
    });
    $('#both').tooltipsy({
      content: "Men's and women's selection loading next",
      offset: [-10, 20]
    });
    $('#women').tooltipsy({
      content: "Only women's selection loading next",
      offset: [-10, 20]
    });
  },

  hideAllToolTips: function(){
    $('#men').data('tooltipsy').hide();
    $('#both').data('tooltipsy').hide();
    $('#women').data('tooltipsy').hide();
  }
}
