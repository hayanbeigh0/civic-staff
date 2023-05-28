import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({super.key});

  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;
  @override
  void initState() {
    subscription = VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        this.progress = progress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    return Padding(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Compressing Video...'),
          SizedBox(
            height: 24.h,
          ),
          LinearProgressIndicator(
            value: value,
            minHeight: 12.h,
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }
}
