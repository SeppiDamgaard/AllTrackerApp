import 'package:alltracker_app/components/styled_text_button.dart';
import 'package:alltracker_app/pages/create_consumption_post.dart';
import 'package:alltracker_app/pages/main_page.dart';
import 'package:alltracker_app/utils/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/consumption_post.dart';
import '../models/consumption_registration.dart';

class PostWidget extends StatefulWidget {
  ConsumptionPost post;
  ConsumptionRegistration reg;
  bool isPreview;
  PostWidget({Key? key, required this.post, required this.reg, this.isPreview = false}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  TextEditingController amountController = TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        key: Key(widget.post.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            const SizedBox(width: 8),
            SlidableAction(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              onPressed: (_) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => CreateConsumptionPost(post: widget.post))
                ));
              },
              backgroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Rediger',
            ),
            SlidableAction(
              onPressed: (_) async {
                if(await deletePopUp()) {
                  String result = await ApiRepository().deletePost(widget.post.id);
                  if(result == ""){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => MainPage())
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                    ));
                  }
                }
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Slet',
            ),
          ]
        ),
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
                            controller: amountController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              suffixText: widget.post.unit == "" ? "Enhed" : widget.post.unit
                            ),
                            onChanged: (_) {
                              widget.reg.amount = double.tryParse(amountController.text) ?? 0;
                              if(!widget.isPreview) saveChanges();
                            },
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
      ),
    );
  }
  Widget button(String text, { bool add = true }) {
    amountController.text = widget.reg.amount.toString();
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
            setState(() {
              widget.reg.amount = add 
              ? (widget.reg.amount + double.parse(text))
              : (widget.reg.amount - double.parse(text));
            });
            if(!widget.isPreview) saveChanges();
          }, 
          child: Text(
            text.replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''),
            style: TextStyle(color: add ? Colors.green : Colors.red),
          )
        ),
      );
    }

  Future<void> saveChanges() async {
    ApiRepository().updateRegistrationAmount(widget.reg);
  }

  Future<bool> deletePopUp() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Er du sikker?"),
        content: const Text("Du vil slette posten, og alle tilhørende registreringer"),
        actions: [
          StyledTextButton(text: "Ja", backgroundColor: Colors.red, textColor: Colors.white, callback: () {
            Navigator.of(context).pop(true);
          }),
          StyledTextButton(text: "Nej", backgroundColor: Theme.of(context).primaryColor, textColor: Colors.white,  callback: () {
            Navigator.of(context).pop(false);
          }),
        ],
      )
    );
  }
}