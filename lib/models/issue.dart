class Issue{
  final int issueId;
  final int Owner;
  final int dealId;
  final String title;
  final int taggedAccount;
  final String description;
  final DateTime createdDate;
  final DateTime dealineDate;

  Issue(this.issueId, this.Owner, this.dealId, this.title, this.taggedAccount, this.description, this.createdDate, this.dealineDate);
}