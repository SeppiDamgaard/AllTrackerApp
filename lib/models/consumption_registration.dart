

class ConsumptionRegistration {
  final String id;
  final String postId;
  double amount;
  final DateTime date;

  ConsumptionRegistration({
    required this.id,
    required this.postId,
    required this.amount,
    required this.date
  });

  List<Object> get props => [
    id,
    postId,
    amount,
    date
  ];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> output = {};

    output["id"]      = id;
    output["postId"]  = postId;
    output["amount"]  = amount;
    output["date"]    = date;

    return output;
  }

  factory ConsumptionRegistration.fromJson(Map<String, dynamic> json) {
    return ConsumptionRegistration(
      id:     json["id"], 
      postId: json["postId"], 
      amount: json["amount"].toDouble(),
      date:   DateTime.parse(json["date"])
    );
  }
}