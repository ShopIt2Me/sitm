var AppController = {
  init: function() {
    AppController.ensureCorrectAJAXSessionTokens();
    AppController.$mens = $("#mens");
    AppController.$both = $("#both");
    AppController.$womens = $("#womens");
    AppController.$container = $('#grid');
    AppController.$infiniteScrollEnd = $('#infinite-scroll-end');
    AppController.loadRandomProductsUrl = $('#page-nav a').attr('href') + '&fill_with_random=true';
    AppController.bindEvents();

  },

  bindEvents: function() {
    AppController.bindToolTips();
    AppController.bindGenderSlider();
    AppController.bindMasonry();
    AppController.bindInfiniteScroll();
    AppController.bindLoadMoreProducts();
    AppController.$container.on('click', '.like', AppController.reactivateInfiniteScroll);
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
        AppController.$infiniteScrollEnd.show();
      }
    }, function(newElements) { // trigger Masonry as a callback
        // hide new items while they are loading
        var $newElems = $(newElements);
        // ensure that images load before adding to masonry layout
        $newElems.imagesLoaded(function() {
          AppController.$container.masonry('appended', $newElems, true);
        });
      }
    );
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
            AppController.reactivateInfiniteScroll();
          });
        }).done(function() {
          isAjaxHappening = false;
        });
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
    AppController.$infiniteScrollEnd.hide();
  },

  bindGenderSlider: function() {
    AppController.$mens.on("click", AppController.selectGender);
    AppController.$both.on("click", AppController.selectGender);
    AppController.$womens.on("click", AppController.selectGender);
  },

  selectGender: function() {
    AppController.hideAllToolTips();
    $(this).data('tooltipsy').show();
    $.post('sessions/set_pref_dept', {prefererred_dept: $(this).attr("id")});
    setTimeout(AppController.hideAllToolTips, 2000);
  },

  bindToolTips: function() {
    AppController.$mens.tooltipsy({
      content: "Men's selection loading next",
      offset: [-10, 20]
    });
    AppController.$both.tooltipsy({
      content: "Men's and women's selection loading next",
      offset: [-10, 20]
    });
    AppController.$womens.tooltipsy({
      content: "Women's selection loading next",
      offset: [-10, 20]
    });
  },

  hideAllToolTips: function() {
    AppController.$mens.data('tooltipsy').hide();
    AppController.$both.data('tooltipsy').hide();
    AppController.$womens.data('tooltipsy').hide();
  },
};

