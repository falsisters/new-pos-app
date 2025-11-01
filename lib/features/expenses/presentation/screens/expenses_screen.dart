import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_item_dto.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_state.dart';
import 'package:falsisters_pos_android/features/expenses/data/providers/expense_provider.dart';
import 'package:falsisters_pos_android/features/expenses/presentation/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NumberFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0.##');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Handle multiple decimal points
    List<String> parts = digitsOnly.split('.');
    if (parts.length > 2) {
      digitsOnly = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Format the number
    double? value = double.tryParse(digitsOnly);
    if (value == null) {
      return oldValue;
    }

    String formatted = _formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  DateTime _selectedDate = DateTime.now();
  final _expenseNameController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  List<ExpenseItemDto> _itemsForSubmission = [];
  String? _loadedExpenseListId;
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExpensesForSelectedDate();
      _focusNode.requestFocus();
    });
  }

  bool _isSelectedDateToday() {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  Future<void> _fetchExpensesForSelectedDate() async {
    final formattedDate =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    debugPrint("Fetching expenses for date: $formattedDate");

    final notifier = ref.read(expenseProvider.notifier);
    await notifier.getExpenseListByDate(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      debugPrint("Date selected: $formattedDate");

      setState(() {
        _selectedDate = picked;
        _itemsForSubmission = [];
        _loadedExpenseListId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading expenses for $formattedDate...')),
      );

      await _fetchExpensesForSelectedDate();
    }
  }

  void _addItem() {
    if (!_isSelectedDateToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only add expenses for today.')),
      );
      return;
    }

    final name = _expenseNameController.text.trim();
    final amountText = _expenseAmountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);

    if (name.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        _itemsForSubmission.add(ExpenseItemDto(name: name, amount: amount));
      });
      _expenseNameController.clear();
      _expenseAmountController.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid name and amount.')),
      );
    }
  }

  void _removeItem(int index) {
    if (!_isSelectedDateToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only edit expenses for today.')),
      );
      return;
    }

    setState(() {
      _itemsForSubmission.removeAt(index);
    });
  }

  Future<void> _saveExpenses() async {
    if (!_isSelectedDateToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only save expenses for today.')),
      );
      return;
    }

    // If it's a new expense list (no _loadedExpenseListId) AND there are no items,
    // then prevent saving an empty new list.
    if (_loadedExpenseListId == null && _itemsForSubmission.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please add at least one expense item to create a new list.')),
      );
      return;
    }

    final notifier = ref.read(expenseProvider.notifier);
    final expenseListData =
        CreateExpenseList(expenseItems: _itemsForSubmission);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving expenses...')),
      );

      if (_loadedExpenseListId != null) {
        debugPrint("Updating expense list: $_loadedExpenseListId");
        await notifier.updateExpense(_loadedExpenseListId!, expenseListData,
            targetDate: _selectedDate);
      } else {
        debugPrint("Creating new expense list");
        await notifier.createExpense(expenseListData,
            targetDate: _selectedDate);
      }

      // Instead of trying to update state directly, refresh the data from API
      await _fetchExpensesForSelectedDate();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expenses saved successfully')),
      );
    } catch (e) {
      debugPrint("Exception during save: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving expenses: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteExpenseList() async {
    if (_loadedExpenseListId == null) return;

    if (!_isSelectedDateToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You can only delete expenses for today.')),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Expense List'),
          content: const Text(
              'Are you sure you want to delete this expense list? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deleting expense list...')),
        );

        final notifier = ref.read(expenseProvider.notifier);
        await notifier.deleteExpense(_loadedExpenseListId!);

        setState(() {
          _itemsForSubmission = [];
          _loadedExpenseListId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense list deleted successfully')),
        );
      } catch (e) {
        debugPrint("Exception during delete: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error deleting expense list: ${e.toString()}')),
        );
      }
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _saveExpenses();
    }
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseProvider);

    // Better logging to debug what's happening
    ref.listen<AsyncValue<ExpenseState>>(expenseProvider, (_, next) {
      next.whenData((data) {
        debugPrint("EXPENSE DATA (raw): ${data.toString()}");

        if (data.expenseList != null) {
          debugPrint("EXPENSE LIST ID: ${data.expenseList!.id}");
          debugPrint(
              "EXPENSE ITEMS COUNT: ${data.expenseList!.expenseItems.length}");

          for (var item in data.expenseList!.expenseItems) {
            debugPrint("EXPENSE ITEM: ${item.name} - ${item.amount}");
          }

          if (mounted) {
            setState(() {
              _itemsForSubmission = data.expenseList!.expenseItems
                  .map((item) => ExpenseItemDto(
                      name: item.name, amount: item.amount.toDouble()))
                  .toList();
              _loadedExpenseListId = data.expenseList!.id;
              debugPrint(
                  "UPDATED SUBMISSION ITEMS: ${_itemsForSubmission.length}");
            });
          }
        } else {
          debugPrint("EXPENSE LIST IS NULL");
          if (_loadedExpenseListId != null && mounted) {
            setState(() {
              _itemsForSubmission = [];
              _loadedExpenseListId = null;
            });
          }
        }
      });
    });

    final dateFormatter = DateFormat('EEEE, MMM dd, yyyy');

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.receipt_outlined, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Track daily expenses',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () => _selectDate(context),
            ),
            if (_loadedExpenseListId != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _isSelectedDateToday() ? _deleteExpenseList : null,
                color: _isSelectedDateToday()
                    ? AppColors.white
                    : AppColors.white.withOpacity(0.5),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header section with gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date selector card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Date',
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    dateFormatter.format(_selectedDate),
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Change'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.white,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Add expense form card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.add_circle_outline,
                                      color: AppColors.secondary),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Add New Expense',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Form fields
                              TextFormField(
                                controller: _expenseNameController,
                                enabled: _isSelectedDateToday(),
                                decoration: InputDecoration(
                                  labelText: 'Expense Name',
                                  hintText:
                                      'e.g., Office Supplies, Transportation',
                                  prefixIcon:
                                      const Icon(Icons.receipt_long_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter expense name';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _expenseAmountController,
                                      enabled: _isSelectedDateToday(),
                                      inputFormatters: [NumberFormatter()],
                                      decoration: InputDecoration(
                                        labelText: 'Amount',
                                        hintText: '0.00',
                                        prefixIcon: Container(
                                          width: 48,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '₱',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: AppColors.primary,
                                              width: 2),
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Please enter amount';
                                        }
                                        final amountText =
                                            value.replaceAll(',', '');
                                        final amount =
                                            double.tryParse(amountText);
                                        if (amount == null || amount <= 0) {
                                          return 'Please enter valid amount';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _isSelectedDateToday()
                                          ? _addItem
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        foregroundColor: AppColors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: const Icon(Icons.add, size: 24),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Status indicator
                    if (!_isSelectedDateToday())
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lock_outline,
                                color: Colors.orange.shade700, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Expenses can only be added or edited for today',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_loadedExpenseListId != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.secondary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                color: AppColors.secondary, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Editing existing expense list',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Expense list display
                    expenseState.when(
                      data: (state) {
                        debugPrint(
                            "BUILDING UI WITH ${_itemsForSubmission.length} ITEMS");
                        return ExpenseListWidget(
                          items: _itemsForSubmission,
                          onItemRemove:
                              _isSelectedDateToday() ? _removeItem : null,
                        );
                      },
                      loading: () => Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          height: 200,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Loading expenses...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      error: (error, _) => Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Error loading expenses',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save button with modern design
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isSelectedDateToday() ? _saveExpenses : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.3),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'SAVE EXPENSES',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
