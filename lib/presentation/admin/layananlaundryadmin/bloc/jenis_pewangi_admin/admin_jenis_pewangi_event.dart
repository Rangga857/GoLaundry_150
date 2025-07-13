import 'package:laundry_app/data/model/request/jenispewangi/jenis_pewangi_request_model.dart';

abstract class AdminJenisPewangiEvent {}

class GetAdminJenisPewangiAllEvent extends AdminJenisPewangiEvent {}

class GetAdminJenisPewangiByIdEvent extends AdminJenisPewangiEvent {
  final int id;

  GetAdminJenisPewangiByIdEvent(this.id);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetAdminJenisPewangiByIdEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AddJenisPewangiEvent extends AdminJenisPewangiEvent {
  final JenisPewangiRequestModel request;

  AddJenisPewangiEvent({required this.request});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddJenisPewangiEvent && other.request == request;
  }

  @override
  int get hashCode => request.hashCode;
}

class UpdateJenisPewangiEvent extends AdminJenisPewangiEvent {
  final int id;
  final JenisPewangiRequestModel request;

  UpdateJenisPewangiEvent({required this.id, required this.request});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateJenisPewangiEvent &&
        other.id == id &&
        other.request == request;
  }

  @override
  int get hashCode => id.hashCode ^ request.hashCode;
}

class DeleteJenisPewangiEvent extends AdminJenisPewangiEvent {
  final int id;

  DeleteJenisPewangiEvent(this.id);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteJenisPewangiEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}