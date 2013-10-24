var AppController = {
  init: function() {
    this.initTooltips();
  },

  bindEvents: function() {

  },

  infiniteScroll: function(){

  },

  selectGender: function(){


  },

  initTooltips: function(){
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
