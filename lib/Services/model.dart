class User {
  int? id;
  int? company_id;
  int? personnel_id;
  String? name;
  String? email;
  String? password;
  int? user_type;
  DateTime? created_at;
  DateTime? updated_at;


  User({
    this.id,
    this.company_id,
    this.personnel_id,
    this.name,
    this.email,
    this.password,
    this.user_type,
    this.created_at,
    this.updated_at,
  });


}