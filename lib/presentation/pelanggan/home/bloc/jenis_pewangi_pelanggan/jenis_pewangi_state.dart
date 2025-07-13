import 'package:laundry_app/data/model/response/jenispewangi/get_all_jenis_pewangi_response_model.dart';

abstract class JenisPewangiState {}

class JenisPewangiInitial extends JenisPewangiState {}

class JenisPewangiLoading extends JenisPewangiState {}

class JenisPewangiAllLoaded extends JenisPewangiState {
  final GetAllJenisPewangiResponseModel jenisPewangiList;

  JenisPewangiAllLoaded(this.jenisPewangiList); 

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JenisPewangiAllLoaded &&
        other.jenisPewangiList == jenisPewangiList;
  }

  @override
  int get hashCode => jenisPewangiList.hashCode;
}

class JenisPewangiError extends JenisPewangiState {
  final String message;

  JenisPewangiError(this.message); 

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JenisPewangiError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}