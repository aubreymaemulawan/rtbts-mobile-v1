import 'dart:convert';
import 'package:flutter_login_ui/Services/globals.dart';
import 'package:http/http.dart' as http;

// TODO: Get Data

/// For Login
class LoginServices {
  static Future<http.Response> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Login User: ');
    print(response.body);

    return response;
  }
}

/// For User Information
class UserServices {
  static Future<http.Response> user(String email, String password, int personnel_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/users');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('User List: ');
    print(response.body);
    return response;
  }
}

/// For Assigned Schedule Information
class ScheduleServices {
  static Future<http.Response> schedule(String email, String password, int personnel_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/schedule');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Schedule List: ');
    print(response.body);
    return response;
  }
}

/// For Trip Information
class TripServices {
  static Future<http.Response> trip(String email, String password, int personnel_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/trip');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Trip List:');
    print(response.body);
    return response;
  }
}

/// For Dashboard Information
class DashboardServices {
  static Future<http.Response> dashboard(String email, String password, int personnel_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/dashboard');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Dashboard List:');
    print(response.body);
    return response;
  }
}

/// For Notification Information
class NotificationServices {
  static Future<http.Response> notification(String email, String password, int personnel_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/notification');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Notification List:');
    print(response.body);
    return response;
  }
}

/// For Status Information
class StatusServices {
  static Future<http.Response> status(String email, String password, int personnel_id, int trip_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
      "trip_id": trip_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/status');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Status List:');
    print(response.body);
    return response;
  }
}

/// For Trip Schedule Information
class TripScheduleServices {
  static Future<http.Response> tripSchedule(
      String email,
      String password,
      int personnel_id,
      int personnel_schedule_id,
      int max_trips
    ) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id": personnel_id,
      "personnel_schedule_id": personnel_schedule_id,
      "max_trips": max_trips
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/trip_schedule');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Trip Schedule List:');
    print(response.body);
    return response;
  }
}

/// For Ongoing Status Information
class OngoingStatusServices {
  static Future<http.Response> ongoing(String email, String password, int personnel_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/ongoing');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Ongoing List:');
    print(response.body);
    return response;
  }
}

/// For Position Information
class PositionServices {
  static Future<http.Response> position(String email, String password, int personnel_id, int trip_id) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id":personnel_id,
      "trip_id": trip_id,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/position');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Position List:');
    print(response.body);
    return response;
  }
}

// TODO: Send Data

/// For Updating Profile
class UpdateProfileServices {
  static Future<http.Response> updateProfile(
      String email,
      String password,
      int personnel_id,
      int age,
      int contact_no,
      String address,
      String profile_picture,
  ) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id": personnel_id,
      "age": age,
      "contact_no": contact_no,
      "address": address,
      "profile_picture": profile_picture,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/update_profile');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Profile Update to DB : ');
    print(response.body);
    return response;
  }
}

/// For Updating Password
class UpdatePasswordServices {
  static Future<http.Response> updatePassword(
      String email,
      String password,
      int personnel_id,
      String currentPass,
      String newPass,
      String retypePass,
      ) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id": personnel_id,
      "current_password": currentPass,
      "new_password": newPass,
      "retype_password": retypePass,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/update_password');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Password Update to DB : ');
    print(response.body);
    return response;
  }
}

/// For Updating Status
class UpdateStatusServices {
  static Future<http.Response> updateStatus(
      String email,
      String password,
      int personnel_id,
      int personnel_schedule_id,
      int bus_status,
      int trip_id,
      int max_trips
      ) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id": personnel_id,
      "personnel_schedule_id": personnel_schedule_id,
      "bus_status": bus_status,
      "trip_id": trip_id,
      "max_trips": max_trips,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/update_status');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Status Update to DB : ');
    print(response.body);
    return response;
  }
}

/// For Creating Trip Information
class CreateTripServices {
  static Future<http.Response> createTrip(
      String email,
      String password,
      int personnel_id,
      int personnel_schedule_id,
      int trip_id,
      int trip_cnt,
      int ongoing_cnt,
      int max_trips,
      int inverse,
      ) async {
    Map data = {
      "email": email,
      "password": password,
      "personnel_id": personnel_id,
      "personnel_schedule_id": personnel_schedule_id,
      "trip_id": trip_id,
      "trip_cnt": trip_cnt,
      "ongoing_cnt": ongoing_cnt,
      "max_trips": max_trips,
      "inverse": inverse
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/create_trip');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('Create Trip Schedule:');
    print(response.body);
    return response;
  }
}
