import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/transaction.dart';
import '../providers/currency_provider.dart';
import 'date_picker_dialog.dart';

class IncomePopup extends StatefulWidget {
  final List<String> categories;
  final Function(String, double, String, DateTime) onAdd;
  final Function() onCancel;
  final Function(Transaction) onSubmit;
  final Transaction? initialTransaction;

  const IncomePopup({
    super.key,
    required this.categories,
    required this.onAdd,
    required this.onCancel,
    required this.onSubmit,
    this.initialTransaction,
  });

  @override
  State<IncomePopup> createState() => _IncomePopupState();
}

class _IncomePopupState extends State<IncomePopup> {
  late String _selectedCategory;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialTransaction != null) {
      _selectedCategory = widget.initialTransaction!.category;
      _amountController = TextEditingController(text: widget.initialTransaction!.amount.toString());
      _descriptionController = TextEditingController(text: widget.initialTransaction!.description);
      _selectedDate = widget.initialTransaction!.dateTime;
    } else {
      _selectedCategory = widget.categories.first;
      _amountController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectDate() {
    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month, now.day);

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => AppDatePickerDialog(
        initialDate: _selectedDate,
        maxDate: maxDate,
        showDayAndTime: true,
        onSelect: (date) {
          setState(() {
            _selectedDate = date;
          });
          Navigator.of(ctx).pop();
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth * 0.05;
            final availableHeight = constraints.maxHeight - bottomInset - 24;
            final maxCardHeight = availableHeight > 260 ? availableHeight : constraints.maxHeight * 0.9;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  12 + bottomInset,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxCardHeight),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.add_circle_outline, color: AppColors.income),
                                const SizedBox(width: 8),
                                Text(
                                  widget.initialTransaction != null ? 'Gelir Duzenle' : 'Gelir Ekle',
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.income),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                                  onPressed: widget.onCancel,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown(context),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              label: 'Tutar',
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              suffixText: currencyProvider.currencySymbol,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              label: 'Aciklama',
                              controller: _descriptionController,
                              hintText: 'Aciklama girin',
                            ),
                            const SizedBox(height: 16),
                            Text('Tarih', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: _selectDate,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.income.withOpacity(0.06),
                                  border: Border.all(color: AppColors.income.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month_rounded, color: AppColors.income, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('dd MMM yyyy  •  HH:mm', 'tr_TR').format(_selectedDate),
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const Spacer(),
                                    Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.income),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildButtons(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            underline: const SizedBox(),
            items: widget.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: Theme.of(context).textTheme.bodyLarge),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? hintText,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            suffixText: suffixText,
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).disabledColor,
              foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Iptal'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _onSubmit,
            style: Theme.of(context).elevatedButtonTheme.style,
            child: const Text('Ekle', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lutfen bir tutar girin'), backgroundColor: Colors.red),
      );
      return;
    }

    double amount;
    try {
      amount = double.parse(_amountController.text.replaceAll(',', '.'));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gecerli bir tutar girin'), backgroundColor: Colors.red),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutar 0\'dan buyuk olmalidir'), backgroundColor: Colors.red),
      );
      return;
    }

    if (widget.initialTransaction != null) {
      final updatedTransaction = Transaction(
        type: 'income',
        category: _selectedCategory,
        amount: amount,
        description: _descriptionController.text,
        dateTime: _selectedDate,
      );
      widget.onSubmit(updatedTransaction);
      return;
    }

    widget.onAdd(
      _selectedCategory,
      amount,
      _descriptionController.text,
      _selectedDate,
    );
  }
}
