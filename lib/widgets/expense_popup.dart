import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';
import '../providers/currency_provider.dart';

class ExpensePopup extends StatefulWidget {
  final List<String> categories;
  final Function(String, double, String, DateTime) onAdd;
  final Function() onCancel;
  final Function(Transaction) onSubmit;
  final Transaction? initialTransaction;

  const ExpensePopup({
    super.key,
    required this.categories,
    required this.onAdd,
    required this.onCancel,
    required this.onSubmit,
    this.initialTransaction,
  });

  @override
  State<ExpensePopup> createState() => _ExpensePopupState();
}

class _ExpensePopupState extends State<ExpensePopup> {
  late String _selectedCategory;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialTransaction?.category ?? widget.categories.first;
    _amountController = TextEditingController(
      text: widget.initialTransaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialTransaction?.description ?? '',
    );
    _selectedDate = widget.initialTransaction?.dateTime ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.expense,
                  onPrimary: Colors.white,
                  onSurface: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                ),
            dialogBackgroundColor: Theme.of(context).cardColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
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

  void _handleSubmit() {
    if (_amountController.text.isEmpty) {
      _showSnackBar('Lütfen bir tutar girin');
      return;
    }

    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null) {
      _showSnackBar('Geçerli bir tutar girin');
      return;
    }

    if (amount <= 0) {
      _showSnackBar('Tutar 0\'dan büyük olmalıdır');
      return;
    }

    if (widget.initialTransaction != null) {
      final updatedTransaction = Transaction(
        type: 'expense',
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
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.remove_circle_outline, color: AppColors.expense),
                          const SizedBox(width: 8),
                          Text(
                            widget.initialTransaction != null ? 'Gider Düzenle' : 'Gider Ekle',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: AppColors.expense,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: widget.onCancel,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Kategori
                      _buildLabel('Kategori'),
                      _buildDropdown(),

                      const SizedBox(height: 16),

                      // Tutar
                      _buildLabel('Tutar'),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          suffixText: currencyProvider.currencySymbol,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Açıklama
                      _buildLabel('Açıklama'),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(hintText: 'Açıklama girin'),
                      ),

                      const SizedBox(height: 16),

                      // Tarih
                      _buildLabel('Tarih'),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} "
                                "- ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}",
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Butonlar
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).disabledColor,
                                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('İptal'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.expense,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Ekle'),
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

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildDropdown() {
    return Container(
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
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
      ),
    );
  }
}
