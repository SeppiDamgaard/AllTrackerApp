class User {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username
  });

  List<Object> get props => [
    id,
    username
  ];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> output = {};

    output["id"]        = id;
    output["username"]  = username;

    return output;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json["id"], username: json["username"]);
  }

}