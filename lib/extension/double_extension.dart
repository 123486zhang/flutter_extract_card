
import 'package:graphic_conversion/utils/size_fit_utils.dart';

extension DoubleFit on double {
  double get px {
    return SizeFitUtils.setPx(this);
  }

  double get rpx {
    return SizeFitUtils.setRpx(this);
  }
}
