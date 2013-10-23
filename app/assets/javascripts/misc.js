
function applyBehaviors(elements) {
  elements = $(elements);
//  elements.find('.like').click(callLikeAction);
  elements.find('.dislike').click(removeProduct);
  elements.find('.side-b').click(flipBack);
  elements.find('.side-a').click(flipForward);
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

function displayLikeDislikeOnHover(elements) {
  var elements = $(elements);
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


function initGenderSlider(){
  initGenderChoice('men')
  initGenderChoice('both')
  initGenderChoice('women')
}

function initGenderChoice(elem){
  $elem = $('#' + elem);
  $elem.on('click', function(){
    hideAllToolTips();
    var self = this
    $(this).data('tooltipsy').show();
    if(elem === "both"){
      $.post("/sessions/set_pref_dept",{session_key:($("#sessionkey").html()), preferred_dept: elem});
    }
    else{
    $.post("/sessions/set_pref_dept",{session_key:($("#sessionkey").html()), preferred_dept: elem+"s"});
  }
    setTimeout(function(){
      $(self).data('tooltipsy').hide();
    }, 2000);
  });
}

function hideAllToolTips(){
  $('#men').data('tooltipsy').hide();
  $('#both').data('tooltipsy').hide();
  $('#women').data('tooltipsy').hide();
}

function initToolTips(){
  $('#men').tooltipsy({
    content: "Men's selection loading next",
    offset: [-10, 20]
  });
  $('#both').tooltipsy({
    content: "Men's and women's selection loading next",
    offset: [-10, 20]
  });
  $('#women').tooltipsy({
    content: "Women's selection loading next",
    offset: [-10, 20]
  });
}
