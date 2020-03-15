import 'package:intl/intl.dart';

String simpleFormatDate(String date) {
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  int myValue = int.parse(date);
  return df.format(new DateTime.fromMillisecondsSinceEpoch(myValue * 1000));
}