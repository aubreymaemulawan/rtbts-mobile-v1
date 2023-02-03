class Schedule {
  final id;
  final date;
  final first_trip;
  final last_trip;
  final route;
  final status;
  final operator;
  final conductor;
  final dispatcher;
  final bus_no;
  final bus_type;
  final max_trips;
  final interval;

  Schedule.fromJson(Map<String,dynamic> json):
        id = json['id'] ?? 0,
        date = json['date'] ?? '',
        first_trip = json['schedule_id'] ?? '',
        last_trip = json['schedule_id'] ?? '',
        route = json['schedule_id'] ?? '',
        status = json['status'] ?? '',
        operator = json['operator_id'] ?? '',
        conductor = json['conductor_id'] ?? '',
        dispatcher = json['dispatcher_id'] ?? '',
        bus_no = json['bus_id'] ?? '',
        bus_type = json['bus_id'] ?? '',
        max_trips = json['max_trips'] ?? '',
        interval = json['schedule_id'] ?? '';
}