// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require modernizr.custom
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require masonry.pkgd.min
//= require imagesloaded
//= require jquery.infinitescroll
//= require_tree .

$(document).ready(function(){
  applyInfiniteScroll();
  applyBehaviors('ul.grid li');
});

function applyBehaviors(elements) {
  elements = $(elements);
  displayInformationOnHover(elements);
  displayLikeDislikeOnHover(elements);
}

function applyInfiniteScroll() {
  var $container = $('#grid');

  $container.imagesLoaded(function(){
    $container.masonry({
      itemSelector: '.item'
    });
  });

  $container.infinitescroll({
    navSelector  : '#page-nav',    // selector for the paged navigation
    nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
    itemSelector : '.item',        // selector for all items you'll retrieve
    loading: {
      img: 'http://i.imgur.com/6RMhx.gif',
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
        $container.masonry( 'appended', $newElems, true );
        applyBehaviors($newElems);
        $newElems.css({opacity: 1})
      });
    }
  );

  applyInfiniteScrollEndBehaviors($container);
}

function reactivateInfiniteScroll() {
  var $container = $('#grid');
  $container.infinitescroll('update', {
    state: {
      isDuringAjax: false,
      isDone: false
    }
  });
  $container.infinitescroll('bind');
}

function displayInformationOnHover(elements) {
  $(elements).hover(function(){
    if ($(this).find('p').is(':animated')) {
      return false;
    }
    $(this).find('p').fadeIn(200);
  }, function() {
    $(this).find('p').fadeOut(200);
  });
}

function displayLikeDislikeOnHover(elements) {
  var elements = $(elements);
  elements.hover(likeAppear, likeDisappear);
  elements.find('.like').on('click', function(e) {
    callLikeAction.call(this, e);
    hideInfiniteScrollEnd();
    reactivateInfiniteScroll();
    return false;
  });
  elements.find('.dislike').on('click', removeProduct);
}

function applyInfiniteScrollEndBehaviors($container) {
  var loadRandomProductsUrl = $('#page-nav a').attr('href') + '&fill_with_random=true';

  $('#infinite-scroll-end .more-random').on('click', function() {
    var isAjaxHappening;

    if (!isAjaxHappening) {
      isAjaxHappening = true;
      $.get(loadRandomProductsUrl, function(data) {

        var filteredData = $(data).filter(function() { return this.nodeType !== 3 });

        $container.append(filteredData);
        $container.imagesLoaded(function(){
          $container.masonry( 'appended', filteredData, true );
          filteredData.css({opacity: 1});
          applyBehaviors(filteredData);
        });
      }).done(function() {
        isAjaxHappening = false;
      })
    }

    return false;
  });
}

function hideInfiniteScrollEnd() {
  $('#infinite-scroll-end').hide();
}
