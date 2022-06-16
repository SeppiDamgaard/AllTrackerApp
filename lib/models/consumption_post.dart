import 'package:alltracker_app/models/consumption_registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConsumptionPost {
  final String id;
  String name;
  String unit;
  String cronString;
  double firstIncrement;
  double secondIncrement;
  double thirdIncrement;
  List<ConsumptionRegistration> registrations = [];
  DateTime? lastModified;

  ConsumptionPost({
    required this.id, 
    required this.name, 
    required this.unit, 
    required this.cronString, 
    required this.firstIncrement, 
    required this.secondIncrement, 
    required this.thirdIncrement,
    this.lastModified,
  });

  List<Object> get props => [
    id,
    name,
    unit,
    cronString,
    firstIncrement,
    secondIncrement,
    thirdIncrement,
    lastModified ?? DateTime.now()
  ];

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "id": id,
      "name": name,
      "unit": unit,
      "cronString": cronString,
      "firstIncrement": firstIncrement,
      "secondIncrement": secondIncrement,
      "thirdIncrement": thirdIncrement,
      "lastModified": lastModified
    };
  }

  factory ConsumptionPost.fromJson(Map<String, dynamic> json) {
    return ConsumptionPost(
      id:               json["id"], 
      name:             json["name"], 
      unit:             json["unit"], 
      cronString:       json["cronString"], 
      firstIncrement:   json["firstIncrement"].toDouble(), 
      secondIncrement:  json["secondIncrement"].toDouble(), 
      thirdIncrement:   json["thirdIncrement"].toDouble(),
      lastModified:     DateTime.parse(json["lastModified"]),
    );
  }
}

class _PostWidget extends StatefulWidget {
  ConsumptionPost post;
  ConsumptionRegistration reg;
  _PostWidget({Key? key, required this.post, required this.reg}) : super(key: key);

  @override
  State<_PostWidget> createState() => __PostWidgetState();
}

class __PostWidgetState extends State<_PostWidget> {
  Widget button(String text, { bool add = true }) {
      double dimensions = 40;
      return SizedBox(
        height: dimensions,
        width: dimensions,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: add ? Colors.green : Colors.red,
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: Theme.of(context).primaryColor
            )
          ),
          onPressed: () {
            widget.reg.amount = add 
            ? (widget.reg.amount + double.parse(text))
            : (widget.reg.amount - double.parse(text));
          }, 
          child: Text(
            text.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
            style: TextStyle(color: add ? Colors.green : Colors.red),
          )
        ),
      );
    }
    
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x0ccccccc),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          )
        ),
        child: Card(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [ 
                  Expanded(
                    child: ListTile(
                      title: Text(widget.post.name == "" ? "Navn på posten" : widget.post.name),
                      trailing: SizedBox(
                        width: 150,
                        child: TextField(
                          // controller: amountController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            suffixText: widget.post.unit
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.remove),
                  button("${widget.post.thirdIncrement}", add: false),
                  button("${widget.post.secondIncrement}", add: false),
                  button("${widget.post.firstIncrement}", add: false),
                  
                  button("${widget.post.firstIncrement}"),
                  button("${widget.post.secondIncrement}"),
                  button("${widget.post.thirdIncrement}"),
                  const Icon(Icons.add),
                ],
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}