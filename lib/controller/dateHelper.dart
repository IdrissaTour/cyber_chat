

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHelper{
  String? convert(String teamstemp){
    initializeDateFormatting();
    int? timeint = int.tryParse(teamstemp);
    DateTime now = DateTime.now();
    DateTime datepost = DateTime.fromMillisecondsSinceEpoch(timeint!);
    DateFormat format;

    if(now.difference(datepost).inDays > 0){
      format = DateFormat.yMMMd("fr_FR");
    }else{
      format = DateFormat.Hm('fr_FR');
    }

    return format.format(datepost).toString();

  }
}