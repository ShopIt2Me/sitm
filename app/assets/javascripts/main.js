function bindHandlers() {
  $('.grid').on('ajax:success', '.like', onLikeDone);
  //$('.grid').on('ajax:failure', '.like', FailureHandlers.like);
}

function init() {
  applyInfiniteScroll();
  applyBehaviors('ul.grid li');
  initToolTips();
  initGenderSlider();
  bindHandlers();
}

$(document).ready(function(){
  init();
});
