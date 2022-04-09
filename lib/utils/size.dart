import 'dart:ui';

class BZSize {
  // 设备物理尺寸
  static final double physicalWidth = window.physicalSize.width;
  static final double physicalHeight = window.physicalSize.height;

  // 设备像素比
  static final double dpr = window.devicePixelRatio;

  // 设备逻辑尺寸
  static final double pageWidth = physicalWidth / dpr;
  static final double pageHeight = physicalHeight / dpr;
  static final double statusBarHeight = window.padding.top / dpr;
  static final double bottomBarHeight = window.padding.bottom / dpr;
}