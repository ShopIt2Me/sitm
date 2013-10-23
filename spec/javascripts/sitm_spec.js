//= require jasmine-jquery

describe("Sitm", function() {
  var SitmApp;

  beforeEach(function() {
    SitmApp = new Sitm();
  });

  afterEach(function() {
    $('div.container').remove();
  });

  it("does container exists", function() {
    expect(SitmApp.$container.length).toBe(1);
  });

  it("applies infinitescroll to products list", function() {
    expect(SitmApp.$container.infinitescroll).toBeDefined();
  });
});

