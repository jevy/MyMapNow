describe('A suite with some variables', function () {
  var bar = 0

  it('has a test', function () {
    bar++;
    expect(bar).toEqual(1);
  });

  it('has another test', function () {
    bar++;
    expect(bar).toEqual(2);
  });
});
