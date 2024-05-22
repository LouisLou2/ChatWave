import 'dart:ui';

class TestDevice{
  double dp1;
  double dp2;
  TestDevice({required this.dp1, required this.dp2});
  Size get size => Size(dp1, dp2);
}
/*测试机型1: Redmi K60 Ultra
 宽度: 973.38dp，
 高度: 438.02dp
*/
class TestDeviceCollection{
  static final TestDevice mobile = TestDevice(dp1: 937.38, dp2: 438.02);
}