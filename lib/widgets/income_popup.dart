import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';
import '../providers/currency_provider.dart';

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

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.income,
                  onPrimary: Colors.white,
                  onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
                ),
            dialogBackgroundColor: Theme.of(context).cardTheme.color,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: const EdgeInsets.only(bottom: 16), // Ensure bottom margin for keyboard
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85, // Limit height to 85% of screen
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.income,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.initialTransaction != null ? 'Gelir Düzenle' : 'Gelir Ekle',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: AppColors.income,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                            onPressed: widget.onCancel,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kategori',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).dividerTheme.color!),
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
                      const SizedBox(height: 16),
                      Text(
                        'Tutar',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          border: Theme.of(context).inputDecorationTheme.border,
                          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                          suffixText: currencyProvider.currencySymbol,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Açıklama',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Açıklama girin',
                          border: Theme.of(context).inputDecorationTheme.border,
                          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tarih',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerTheme.color!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} - ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Icon(Icons.calendar_today, color: Theme.of(context).iconTheme.color),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).disabledColor,
                                foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('İptal'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_amountController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Lütfen bir tutar girin'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                double amount;
                                try {
                                  amount = double.parse(_amountController.text.replaceAll(',', '.'));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Geçerli bir tutar girin'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (amount <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Tutar 0\'dan büyük olmalıdır'),
                                      backgroundColor: Colors.red,
                                    ),
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
                                } else {
                                  widget.onAdd(
                                    _selectedCategory,
                                    amount,
                                    _descriptionController.text,
                                    _selectedDate,
                                  );
                                }
                              },
                              style: Theme.of(context).elevatedButtonTheme.style,
                              child: const Text(
                                'Ekle',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}