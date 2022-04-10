
import 'package:graphic_conversion/utils/size_fit_utils.dart';

extension IntFit on int {
  double get px {
    return SizeFitUtils.setPx(this.toDouble());
  }

  double get rpx {
    return SizeFitUtils.setRpx(this.toDouble());
  }
}