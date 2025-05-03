enum AttachmentType {
  EXPENSE_RECEIPT,
  CHECKS_AND_BANK_TRANSFER,
  INVENTORIES,
  SUPPORTING_DOCUMENTS
}

String attachmentTypeToString(AttachmentType type) {
  switch (type) {
    case AttachmentType.EXPENSE_RECEIPT:
      return 'Expense Receipt';
    case AttachmentType.CHECKS_AND_BANK_TRANSFER:
      return 'Checks and Bank Transfer';
    case AttachmentType.INVENTORIES:
      return 'Inventories';
    case AttachmentType.SUPPORTING_DOCUMENTS:
      return 'Supporting Documents';
  }
}
