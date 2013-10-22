describe("Sitm", function() {
  var SitmApp;

  beforeEach(function() {
    SitmApp = new Sitm();
  });

  it("applies infinitescroll to products list", function() {
    expect(SitmApp.$container.infinitescroll).toBeDefined();
  });
});