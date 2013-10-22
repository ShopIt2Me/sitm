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
//= require tooltipsy
//= require_tree .

$(document).ready(function(){
  applyInfiniteScroll();
  displayInformationOnHover('ul.grid li');
  displayLikeDislikeOnHover('ul.grid li');
  initGenderChoice();
  initToolTips();
  bindListener(getChild('ul.grid li', '.like'), 'click', callLikeAction)
  bindListener(getChild('ul.grid li', '.dislike'), 'click', removeProduct)
});

function getChild(parentSelector, childSelector) {
  parentEl = $(parentSelector)
  return $(parentEl).find(childSelector)
}

function bindListener(targetEl, action, callback) {
  targetEl.on(action, callback);
}

function callLikeAction(e) {
  e.preventDefault();
  $.post('products/like', {session_key:($("#sessionkey").html()) , product_id: this.dataset.productid})
  .done(function(response){
    $("li").find("[data-productid='" + response + "']").addClass('liked');
    $("li").find("[data-productid='" + response + "']").find('a.heart').addClass('liked');
    $("li").find("[data-productid='" + response + "']").find('a.fire').html('');
  })
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
      speed: 0
    },
  },
    // trigger Masonry as a callback
    function( newElements ) {
      // hide new items while they are loading
      var $newElems = $( newElements ).css({ opacity: 1 });
      // ensure that images load before adding to masonry layout
      $newElems.imagesLoaded(function(){
        // show elems now they're ready
        $newElems.animate({ opacity: 1 });
        $container.masonry( 'appended', $newElems, true );
      });
    }
    );
}

function displayLikeDislikeOnHover(elements) {
  var elements = $(elements);
  $(elements).hover(likeAppear, likeDisappear);
  elements.find('.like').on('click', callLikeAction);
  elements.find('.dislike').on('click', removeProduct);
}

function initGenderChoice(){
  $('#men').on('click', function(){
    hideAllToolTips();
    $(this).data('tooltipsy').show();
    $.post("/sessions/set_pref_dept",{session_key:($("#sessionkey").html()), preferred_dept: "mens"});
    setTimeout(function(){
      $('#men').data('tooltipsy').hide();
    }, 2000);
  });
  $('#both').on('click', function(){
    hideAllToolTips();
    $(this).data('tooltipsy').show();
    $.post("/sessions/set_pref_dept",{session_key:($("#sessionkey").html()), preferred_dept: "both"});
    setTimeout(function(){
      $('#both').data('tooltipsy').hide();
    }, 2000);
  });
  $('#women').on('click', function(){
    hideAllToolTips();
    $(this).data('tooltipsy').show();
    $.post("/sessions/set_pref_dept",{session_key:($("#sessionkey").html()), preferred_dept: "womens"});
    setTimeout(function(){
      $('#women').data('tooltipsy').hide();
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
    content: "Men's selection loading next...",
    offset: [-10, 20]
  });
  $('#both').tooltipsy({
    content: "Men's and women's selection loading next...",
    offset: [-10, 20]
  });
  $('#women').tooltipsy({
    content: "Women's selection loading next...",
    offset: [-10, 20]
  });
}

