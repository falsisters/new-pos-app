import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_item_dto.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_state.dart';
import 'package:falsisters_pos_android/features/expenses/data/providers/expense_provider.dart';
import 'package:falsisters_pos_android/features/expenses/presentation/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExpensesForSelectedDate();
    });
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
    final name = _expenseNameController.text.trim();
    final amount =
        double.tryParse(_expenseAmountController.text.replaceAll(',', '.'));

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
    setState(() {
      _itemsForSubmission.removeAt(index);
    });
  }

  Future<void> _saveExpenses() async {
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

    // If _loadedExpenseListId is not null, we are editing an existing list.
    // Saving with _itemsForSubmission being empty will effectively clear the items for that day.
    // If _loadedExpenseListId is null and _itemsForSubmission is NOT empty, a new list will be created.

    final notifier = ref.read(expenseProvider.notifier);
    final expenseListData =
        CreateExpenseList(expenseItems: _itemsForSubmission);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving expenses...')),
      );

      if (_loadedExpenseListId != null) {
        debugPrint("Updating expense list: $_loadedExpenseListId");
        await notifier.updateExpense(_loadedExpenseListId!, expenseListData);
      } else {
        debugPrint("Creating new expense list");
        await notifier.createExpense(expenseListData);
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

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
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
                  .map((item) =>
                      ExpenseItemDto(name: item.name, amount: item.amount))
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

    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simple date display
              Row(
                children: [
                  Icon(Icons.calendar_month, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    dateFormatter.format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Change Date',
                        style: TextStyle(color: AppColors.accent)),
                  ),
                ],
              ),
              const Divider(),

              // Simple form for adding expense items
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expense Name Field
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _expenseNameController,
                        decoration: InputDecoration(
                          labelText: 'Expense Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Amount Field
                    Expanded(
                      child: TextField(
                        controller: _expenseAmountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          prefixText: '₱ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Add Button
                    ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Expense list display
              expenseState.when(
                data: (state) {
                  debugPrint(
                      "BUILDING UI WITH ${_itemsForSubmission.length} ITEMS");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status indicator
                      if (_loadedExpenseListId != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Editing expense list: $_loadedExpenseListId',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 13,
                            ),
                          ),
                        ),

                      // Expense list
                      ExpenseListWidget(
                        items: _itemsForSubmission,
                        onItemRemove: _removeItem,
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Save button
              ElevatedButton(
                onPressed: _saveExpenses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'SAVE EXPENSES',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
