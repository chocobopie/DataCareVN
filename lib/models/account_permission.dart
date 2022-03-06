class AccountPermission{
  final int accountPermissionID;
  final int view;
  final int update;
  final int delete;

  AccountPermission(this.accountPermissionID, this.view, this.update, this.delete);
}