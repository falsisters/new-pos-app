import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_item_dto.dart';
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
  String? _loadedExpenseListId; // Store ID of loaded list for updates

  @override
  void initState() {
    super.initState();
    // Fetch today's expenses initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExpensesForSelectedDate();
    });
  }

  Future<void> _fetchExpensesForSelectedDate() async {
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
      setState(() {
        _selectedDate = picked;
        // Clear previous items when date changes, new data will populate via listener
        _itemsForSubmission = [];
        _loadedExpenseListId = null;
      });
      _fetchExpensesForSelectedDate();
    }
  }

  void _addItem() {
    final name = _expenseNameController.text;
    final amount = double.tryParse(_expenseAmountController.text);

    if (name.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        _itemsForSubmission.add(ExpenseItemDto(name: name, amount: amount));
      });
      _expenseNameController.clear();
      _expenseAmountController.clear();
      FocusScope.of(context).unfocus(); // Dismiss keyboard
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
    if (_itemsForSubmission.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one expense item.')),
      );
      return;
    }

    final notifier = ref.read(expenseProvider.notifier);
    final expenseListData =
        CreateExpenseList(expenseItems: _itemsForSubmission);

    if (_loadedExpenseListId != null) {
      // Update existing list
      await notifier.updateExpense(_loadedExpenseListId!, expenseListData);
    } else {
      // Create new list
      await notifier.createExpense(expenseListData);
    }
    // After saving, the listener on expenseProvider should update the UI.
    // Optionally, clear itemsForSubmission if create/update was successful and you want a fresh start
    // For now, rely on the listener to repopulate from the new state.
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

    // Listener to update local state when fetched data changes
    ref.listen<AsyncValue<dynamic>>(expenseProvider, (_, next) {
      next.whenData((data) {
        if (mounted) {
          // Ensure widget is still in the tree
          final fetchedList = data.expenseList;
          if (fetchedList != null && fetchedList.expenseItems.isNotEmpty) {
            setState(() {
              _itemsForSubmission = fetchedList.expenseItems
                  .map((item) =>
                      ExpenseItemDto(name: item.name, amount: item.amount))
                  .toList();
              _loadedExpenseListId = fetchedList.id.toString();
            });
          } else if (fetchedList == null || fetchedList.expenseItems.isEmpty) {
            // If the selected date changed and resulted in no list,
            // _itemsForSubmission is already cleared in _selectDate.
            // This handles cases where an initially loaded list becomes empty/null.
            if (_loadedExpenseListId != null) {
              // Was editing, now it's gone
              setState(() {
                _itemsForSubmission = [];
                _loadedExpenseListId = null;
              });
            }
          }
        }
      });
    });

    final dateFormatter = DateFormat('EEE, dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Manage Expenses'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Row(
                children: [
                  Icon(Icons.date_range, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        dateFormatter.format(_selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: Icon(Icons.edit_calendar,
                        size: 18, color: AppColors.accent),
                    label: Text('Change',
                        style: TextStyle(color: AppColors.accent)),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Form to add new expense item
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Expense',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _expenseNameController,
                      decoration: InputDecoration(
                        labelText: 'Expense Name',
                        labelStyle: TextStyle(color: AppColors.primary),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.primaryLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        prefixIcon: Icon(Icons.shopping_cart_outlined,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _expenseAmountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: AppColors.primary),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.primaryLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        prefixIcon:
                            Icon(Icons.attach_money, color: AppColors.primary),
                        prefixText: 'Rp ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _loadedExpenseListId != null
                    ? AppColors.secondary.withOpacity(0.15)
                    : AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _loadedExpenseListId != null
                    ? 'Editing Expense List'
                    : 'Creating New Expense List',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _loadedExpenseListId != null
                      ? AppColors.secondary
                      : AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 12),
            expenseState.when(
              data: (state) {
                return ExpenseListWidget(
                  items: _itemsForSubmission,
                  onItemRemove: _removeItem,
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading expenses',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
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
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('SAVE EXPENSES'),
              onPressed: _saveExpenses,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
