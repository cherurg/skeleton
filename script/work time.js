var s = new Skeleton('plot');

//�������������, ��� �������� ������
function go() {
  var now = new Date();
  for(var i = 0; i < 1000; i++) {
    s.addPoint(i, 0);
  }
  return new Date() - now;
}

//� ���� ��� ��� ������������ ����, ��� �������� ����� jsx. � ������ ���.
//����.
//function g(){var n = new Date();for(var i=0;i<1000;i++){brd.create('point',[i,0]);}return new Date()-n;}g();