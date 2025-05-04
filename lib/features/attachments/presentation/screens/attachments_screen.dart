import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_model.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:falsisters_pos_android/features/attachments/data/providers/attachment_provider.dart';
import 'package:falsisters_pos_android/features/attachments/presentation/screens/create_attachment_screen.dart';
import 'package:falsisters_pos_android/features/attachments/presentation/widgets/attachment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttachmentsScreen extends ConsumerStatefulWidget {
  const AttachmentsScreen({super.key});

  @override
  ConsumerState<AttachmentsScreen> createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends ConsumerState<AttachmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  AttachmentType? _selectedType;
  bool _showSearchBar = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AttachmentModel> _filterAttachments(List<AttachmentModel> attachments) {
    if (_searchQuery.isEmpty && _selectedType == null) {
      return attachments;
    }

    return attachments.where((attachment) {
      bool matchesName = _searchQuery.isEmpty ||
          attachment.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesType =
          _selectedType == null || attachment.type == _selectedType;

      return matchesName && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentState = ref.watch(attachmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Attachments'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          // Search toggle button
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Filter by type button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(attachmentProvider.notifier).getAttachments();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAttachmentScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Attachment'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: Column(
          children: [
            if (_selectedType != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text('Filtered by: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Chip(
                      label: Text(attachmentTypeToString(_selectedType!)),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _selectedType = null;
                        });
                      },
                      backgroundColor:
                          _getColorForType(_selectedType!).withOpacity(0.2),
                      labelStyle:
                          TextStyle(color: _getColorForType(_selectedType!)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: attachmentState.when(
                data: (data) {
                  final filteredAttachments =
                      _filterAttachments(data.attachments);

                  if (filteredAttachments.isEmpty) {
                    if (data.attachments.isEmpty) {
                      // No attachments at all
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No attachments found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add attachments by clicking the button below',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // No search results
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No matching attachments',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try changing your search or filter',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Attachments',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          filteredAttachments.length != data.attachments.length
                              ? 'Showing ${filteredAttachments.length} of ${data.attachments.length} attachments'
                              : 'All your uploaded documents in one place',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: filteredAttachments.length,
                            itemBuilder: (context, index) {
                              final attachment = filteredAttachments[index];
                              return AttachmentTile(
                                attachment: attachment,
                                onDelete: () => _showDeleteConfirmation(
                                    context, ref, attachment.id),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading attachments',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attachment'),
        content: const Text('Are you sure you want to delete this attachment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(attachmentProvider.notifier).deleteAttachment(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Filter Attachments',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select attachment type:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              ...AttachmentType.values.map((type) => _buildFilterOption(type)),
              const Divider(height: 24),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Clear filter'),
                onTap: () {
                  setState(() {
                    _selectedType = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildFilterOption(AttachmentType type) {
    final bool isSelected = _selectedType == type;
    final color = _getColorForType(type);

    return ListTile(
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected ? color : Colors.grey,
      ),
      title: Text(
        attachmentTypeToString(type),
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? color : null,
        ),
      ),
      tileColor: isSelected ? color.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        setState(() {
          _selectedType = type;
        });
        Navigator.pop(context);
      },
    );
  }

  Color _getColorForType(AttachmentType type) {
    switch (type) {
      case AttachmentType.EXPENSE_RECEIPT:
        return Colors.orange.shade700;
      case AttachmentType.CHECKS_AND_BANK_TRANSFER:
        return Colors.blue.shade700;
      case AttachmentType.INVENTORIES:
        return Colors.green.shade700;
      case AttachmentType.SUPPORTING_DOCUMENTS:
        return Colors.purple.shade700;
    }
  }
}
