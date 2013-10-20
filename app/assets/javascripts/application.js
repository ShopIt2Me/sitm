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
//= require jquery.infinitescroll
//= require turbolinks
//= require masonry.pkgd.min
//= require imagesloaded

//= require_tree .

$(document).ready(function(){
  // new AnimOnScroll( document.getElementById( 'grid' ), {
  //   minDuration : 0.4,
  //   maxDuration : 0.7,
  //   viewportFactor : 0.2
  // });

  applyInfiniteScroll();
});

function applyInfiniteScroll() {
  var $container = $('#grid');
  
  $container.imagesLoaded(function(){
    $container.masonry({
      itemSelector: '.item',
      transitionDuration : 0
      // columnWidth: 100
    });
  });
  
  $container.infinitescroll({
    navSelector  : '#page-nav',    // selector for the paged navigation 
    nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
    itemSelector : '.item',     // selector for all items you'll retrieve
    loading: {
        img: 'http://i.imgur.com/6RMhx.gif'
      }
    },
    // trigger Masonry as a callback
    function( newElements ) {

      console.log(1234)
      // hide new items while they are loading
      var $newElems = $( newElements ).css({ opacity: 0 });
      // ensure that images load before adding to masonry layout
      $newElems.imagesLoaded(function(){
        // show elems now they're ready
        $newElems.animate({ opacity: 1 });
        $container.masonry( 'appended', $newElems, true );
      });
    }
  );
}
