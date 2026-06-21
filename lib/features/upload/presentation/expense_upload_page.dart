import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:today_poor/core/theme/app_colors.dart';
import 'package:today_poor/features/upload/presentation/upload_check_page.dart';

class ExpenseUploadPage extends StatefulWidget {
  const ExpenseUploadPage({super.key, this.date, this.pickImages});

  final DateTime? date;
  final PickExpenseImages? pickImages;

  @override
  State<ExpenseUploadPage> createState() => _ExpenseUploadPageState();
}

class _ExpenseUploadPageState extends State<ExpenseUploadPage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<XFile>> _pickImages() {
    return widget.pickImages?.call() ??
        _imagePicker.pickMultiImage(imageQuality: 90);
  }

  Future<void> _openImagePicker() async {
    final images = await _pickImages();
    if (images.isEmpty || !mounted) return;

    final uploadDate = widget.date ?? DateTime.now();
    final didComplete = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => UploadCheckPage(
          date: uploadDate,
          initialExpenses: [
            for (var index = 0; index < images.length; index++)
              mockExpense(index),
          ],
          pickImages: _pickImages,
        ),
      ),
    );

    if (didComplete == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadDate = widget.date ?? DateTime.now();

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.background],
            stops: [0.08, 1],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentHeight = constraints.maxHeight.clamp(
                757.0,
                double.infinity,
              );

              return SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: constraints.maxWidth.clamp(0.0, 402.0),
                    height: contentHeight,
                    child: _UploadContent(
                      date: uploadDate,
                      onUpload: _openImagePicker,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UploadContent extends StatelessWidget {
  const _UploadContent({required this.date, required this.onUpload});

  final DateTime date;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _UploadHeader(),
        const SizedBox(height: 138),
        Text(
          formatKoreanDate(date),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 34),
        Semantics(
          button: true,
          label: '소비내역 사진 업로드',
          child: GestureDetector(
            key: const ValueKey('expense-photo-upload-action'),
            onTap: onUpload,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: AppColors.textSecondary,
                radius: 9,
              ),
              child: const SizedBox(
                width: 206,
                height: 193,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _UploadAsset(),
                    SizedBox(height: 10),
                    Text(
                      '소비내역 업로드하기',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 35),
        const Text(
          '오늘의 소비내역을 업로드해주세요!',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 44),
          child: Text(
            '영수증 사진만 올리면 소비 내역을 자동 분석해드려요!\n\n'
            '카드 내역 캡처, 영수증 사진, PDF 업로드를 지원하며,\n'
            '개인정보는 암호화 처리 후 즉시 삭제됩니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _UploadHeader extends StatelessWidget {
  const _UploadHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 22, 0),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Semantics(
              button: true,
              label: '뒤로',
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  'assets/images/today_poor_logo_horizontal.png',
                  width: 125,
                  height: 32,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/main_add.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/images/main_profile.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadAsset extends StatelessWidget {
  const _UploadAsset();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/crew_upload.png',
      width: 67,
      height: 64,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return color != oldDelegate.color || radius != oldDelegate.radius;
  }
}
