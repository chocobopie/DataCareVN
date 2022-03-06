
class ExcuseLate{
  final int excuseLateId;
  final int attendanceId;
  final DateTime dateRequest;
  final String description;
  final DateTime expectedWorkingTime;
  final int excuseLateStatusId;

  ExcuseLate(this.excuseLateId, this.attendanceId, this.dateRequest, this.description, this.expectedWorkingTime, this.excuseLateStatusId);
}