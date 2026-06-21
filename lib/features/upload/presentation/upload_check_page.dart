import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:today_poor/core/theme/app_colors.dart';

typedef PickExpenseImages = Future<List<XFile>> Function();

class ExpenseCategory {
  const ExpenseCategory(this.name, this.assetPath);

  final String name;
  final String assetPath;
}

const expenseCategories = [
  ExpenseCategory('금융', 'assets/images/category_money.png'),
  ExpenseCategory('쇼핑', 'assets/images/category_shopping.png'),
  ExpenseCategory('저축', 'assets/images/category_saving.png'),
  ExpenseCategory('문화', 'assets/images/category_culture.png'),
  ExpenseCategory('교통', 'assets/images/category_transport.png'),
  ExpenseCategory('뷰티', 'assets/images/category_beauty.png'),
  ExpenseCategory('교육', 'assets/images/category_education.png'),
  ExpenseCategory('선물', 'assets/images/category_gift.png'),
  ExpenseCategory('건강', 'assets/images/category_health.png'),
  ExpenseCategory('식비', 'assets/images/category_food.png'),
  ExpenseCategory('배달', 'assets/images/category_delivery.png'),
];

class ExpenseDraft {
  const ExpenseDraft({
    required this.storeName,
    required this.amount,
    required this.category,
  });

  final String storeName;
  final int amount;
  final ExpenseCategory category;

  ExpenseDraft copyWith({
    String? storeName,
    int? amount,
    ExpenseCategory? category,
  }) {
    return ExpenseDraft(
      storeName: storeName ?? this.storeName,
      amount: amount ?? this.amount,
      category: category ?? this.category,
    );
  }
}

class UploadCheckPage extends StatefulWidget {
  const UploadCheckPage({
    super.key,
    required this.date,
    required this.initialExpenses,
    required this.pickImages,
  });

  final DateTime date;
  final List<ExpenseDraft> initialExpenses;
  final PickExpenseImages pickImages;

  @override
  State<UploadCheckPage> createState() => _UploadCheckPageState();
}

class _UploadCheckPageState extends State<UploadCheckPage> {
  late final List<ExpenseDraft> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = [...widget.initialExpenses];
  }

  Future<void> _addUpload() async {
    final images = await widget.pickImages();
    if (images.isEmpty || !mounted) return;

    setState(() {
      for (var index = 0; index < images.length; index++) {
        _expenses.add(mockExpense(_expenses.length));
      }
    });
  }

  Future<void> _editExpense(int index) async {
    final updated = await showDialog<ExpenseDraft>(
      context: context,
      builder: (_) => _EditExpenseDialog(expense: _expenses[index]),
    );
    if (updated == null || !mounted) return;
    setState(() => _expenses[index] = updated);
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 402),
              child: Column(
                children: [
                  const _CheckHeader(),
                  const SizedBox(height: 18),
                  const Text('오늘의 소비내역', style: _titleStyle),
                  const SizedBox(height: 8),
                  Text(formatKoreanDate(widget.date), style: _titleStyle),
                  const SizedBox(height: 42),
                  Expanded(
                    child: ListView.separated(
                      key: const ValueKey('expense-draft-list'),
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        return _ExpenseDraftCard(
                          expense: _expenses[index],
                          onEdit: () => _editExpense(index),
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(64, 20, 64, 64),
                    child: Row(
                      children: [
                        Expanded(
                          child: _BottomButton(
                            label: '추가 업로드',
                            backgroundColor: const Color(0xFFF4D7D7),
                            onPressed: _addUpload,
                          ),
                        ),
                        const SizedBox(width: 17),
                        Expanded(
                          child: _BottomButton(
                            label: '업로드 완료',
                            backgroundColor: AppColors.cardBackground,
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _titleStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

class _CheckHeader extends StatelessWidget {
  const _CheckHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 22, 0),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Image.asset(
                'assets/images/today_poor_logo_horizontal.png',
                width: 125,
                height: 32,
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/main_profile.png',
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseDraftCard extends StatelessWidget {
  const _ExpenseDraftCard({required this.expense, required this.onEdit});

  final ExpenseDraft expense;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.fromLTRB(13, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(expense.category.assetPath, width: 42, height: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              expense.storeName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                key: const ValueKey('edit-expense-button'),
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(Icons.edit_outlined, size: 17),
                ),
              ),
              Text(
                '${formatAmount(expense.amount)}원',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditExpenseDialog extends StatefulWidget {
  const _EditExpenseDialog({required this.expense});

  final ExpenseDraft expense;

  @override
  State<_EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<_EditExpenseDialog> {
  late final TextEditingController _storeController;
  late final TextEditingController _amountController;
  late ExpenseCategory _category;

  @override
  void initState() {
    super.initState();
    _storeController = TextEditingController(text: widget.expense.storeName);
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _category = widget.expense.category;
  }

  @override
  void dispose() {
    _storeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('소비내역 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const ValueKey('edit-store-field'),
            controller: _storeController,
            decoration: const InputDecoration(labelText: '상호명'),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('edit-amount-field'),
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: '금액'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ExpenseCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: '카테고리'),
            items: [
              for (final category in expenseCategories)
                DropdownMenuItem(value: category, child: Text(category.name)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final amount = int.tryParse(_amountController.text);
            if (_storeController.text.trim().isEmpty || amount == null) return;
            Navigator.of(context).pop(
              widget.expense.copyWith(
                storeName: _storeController.text.trim(),
                amount: amount,
                category: _category,
              ),
            );
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: const Color(0xFF666666),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

ExpenseDraft mockExpense(int index) {
  const samples = [
    ('이디야커피', 34000, 9),
    ('온라인 쇼핑', 28900, 1),
    ('버스 교통비', 1450, 4),
  ];
  final sample = samples[index % samples.length];
  return ExpenseDraft(
    storeName: sample.$1,
    amount: sample.$2,
    category: expenseCategories[sample.$3],
  );
}

String formatAmount(int amount) {
  final text = amount.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index++) {
    if (index > 0 && (text.length - index) % 3 == 0) buffer.write(',');
    buffer.write(text[index]);
  }
  return buffer.toString();
}

String formatKoreanDate(DateTime date) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return '${date.year}년 ${date.month}월 ${date.day}일 '
      '${weekdays[date.weekday - 1]}요일';
}
