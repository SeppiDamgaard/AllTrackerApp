import 'package:alltracker_app/components/styled_text_button.dart';
import 'package:alltracker_app/components/styled_text_field.dart';
import 'package:alltracker_app/models/consumption_post.dart';
import 'package:alltracker_app/models/consumption_registration.dart';
import 'package:alltracker_app/pages/main_page.dart';
import 'package:alltracker_app/utils/api_repository.dart';
import 'package:flutter/material.dart';

import '../components/consumption_post_widget.dart';

class CreateConsumptionPost extends StatefulWidget {
  ConsumptionPost? post;
  CreateConsumptionPost({Key? key, this.post}) : super(key: key);

  @override
  State<CreateConsumptionPost> createState() => _CreateConsumptionPostState();
}

class _CreateConsumptionPostState extends State<CreateConsumptionPost> {
  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController firstIncrementController = TextEditingController(text: "1");
  TextEditingController secondIncrementController = TextEditingController(text: "2");
  TextEditingController thirdIncrementController = TextEditingController(text: "3");
  TextEditingController amountController = TextEditingController(text: "0");
  String id = "id";
  String cronString = "";
  bool editing = false;
  DaysToRemind? chosenDayReminder = DaysToRemind.every;
  // Different days for the cron job
  Map<String, bool> weekdays = {
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
    "Fri": false,
    "Sat": false,
    "Sun": false,
  };
  @override
  void initState() {
    if (widget.post != null){
      editing = true;
      id = widget.post!.id;
      cronString = widget.post!.cronString;
      nameController.text = widget.post!.name;
      unitController.text = widget.post!.unit;
      firstIncrementController.text = widget.post!.firstIncrement.toString();
      secondIncrementController.text = widget.post!.secondIncrement.toString();
      thirdIncrementController.text = widget.post!.thirdIncrement.toString();
      // TODO:  daysController.text = widget.post!.days;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    widget.post = ConsumptionPost(
      id: id, 
      name: nameController.text, 
      unit: unitController.text, 
      cronString: cronString, 
      firstIncrement: double.parse(firstIncrementController.text), 
      secondIncrement: double.parse(secondIncrementController.text), 
      thirdIncrement: double.parse(thirdIncrementController.text),
    );
    
    ConsumptionRegistration reg = ConsumptionRegistration(id: "id", postId: "postId", amount: 3, date: DateTime.now());
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? "Rediger forbrugspost" : "Opret ny forbrugspost"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StyledTextField(
                  title: "Navn på posten", 
                  controller: nameController
                ),
                StyledTextField(
                  title: "Enhed på posten (stk, liter, km...)", 
                  controller: unitController
                ),
                cronDefiner(),
                defineIncrements(),
                // TextButton(onPressed: () => getCronString(), child: const Text("oi")),
                const SizedBox(height: 16,),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forvisning af posten:",
                      style: TextStyle(
                      fontSize: 20
                    ),
                  )
                ),
                PostWidget(post: widget.post!, reg: reg, isPreview: true),
                StyledTextButton(
                  text: editing ? "Opdater post" : "Opret post", 
                  backgroundColor: Theme.of(context).primaryColor, 
                  textColor: Colors.white,
                  callback: () async {
                    if(chosenDayReminder == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Du skal vælge hvor ofte den skal gentage sig"),
                      ));
                    } else {
                      // cronString = getCronString(chosenDayReminder!, daysController.text, weekdays);
                      if(editing){
                        await ApiRepository().updatePost(
                          id: id, 
                          name: nameController.text, 
                          unit: unitController.text, 
                          cronString: cronString, 
                          firstIncrement: double.parse(firstIncrementController.text), 
                          secondIncrement: double.parse(secondIncrementController.text), 
                          thirdIncrement: double.parse(thirdIncrementController.text),
                        );
                      } else {
                        await ApiRepository().createPost(
                          name: nameController.text, 
                          unit: unitController.text, 
                          cronString: getCronString(chosenDayReminder!, daysController.text, weekdays), 
                          firstIncrement: double.parse(firstIncrementController.text),
                          secondIncrement: double.parse(secondIncrementController.text),
                          thirdIncrement: double.parse(thirdIncrementController.text)
                        );
                      } 
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
                    } 
                  }, 
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => FocusScope.of(context).unfocus(),
    );
  }

  Widget cronDefiner() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Hvor ofte skal posten vise sig på forsiden?",
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
        radioButton(DaysToRemind.every, const Text("Hver dag")),
        radioButton(
          DaysToRemind.daysBetween,
          Row(
            children: [
              const Text("Hver"),
              smallTextField(
                daysController,
                enabled: chosenDayReminder == DaysToRemind.daysBetween
              ),
              const Text(". dag")
            ],
          )
        ),
        radioButton(DaysToRemind.weekDays, const Text("Vælg dage på ugen")),
        chosenDayReminder == DaysToRemind.weekDays ? weekDayPicker() : Container(),
      ],
    );
  }

  Widget radioButton(DaysToRemind newValue, Widget text) {
    return GestureDetector(
      child: ListTile(
        title: text,
        leading: Radio(
          value: newValue,
          groupValue: chosenDayReminder,
          onChanged: (DaysToRemind? value) {
            setState(() {
              chosenDayReminder = value;
            });
          },
        ),
      ),
      onTap: () {
        setState(() {
          chosenDayReminder = newValue;
        });
      },
    );
  }
  
  Widget smallTextField(TextEditingController controller, { bool enabled = true }) {
    return SizedBox(
      width: 40,
      child: TextField(
        enabled: enabled,
        textAlign: TextAlign.end,
        controller: controller,
        keyboardType: TextInputType.number,
        // inputFormatters: [FilteringTextInputFormatter.],
      ),
    );
  }

  Widget weekDayPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekdays.entries.map((e) => customCheckBox(e.key)).toList(),
    );
  }

  Widget customCheckBox(String key) {
    return Column(
      children: [
        Text(key),
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: weekdays[key], 
          onChanged: (bool? value) {
            setState(() {
              weekdays[key] = value!;
            });
          }
        ),
      ],
    );
  }

  String getCronString(DaysToRemind chosenDayReminder, String daysBetween, Map<String, bool> weekdays) {
    // <minutes> <hours> <day-of-month> <month> <day-of-week>
    StringBuffer sb = StringBuffer();

    // Every minute, hour and day of month
    sb.write("* * *");


    // Day of month with increment
    if (chosenDayReminder == DaysToRemind.daysBetween) {
      sb.write("/$daysBetween");
    }

    // Every month
    sb.write(" *");

    // Day of week
    if (chosenDayReminder != DaysToRemind.weekDays){
      sb.write(" *");
    } else {
      bool first = true;
      StringBuffer weekdaySb = StringBuffer();
      weekdays.entries.toList().forEach((w) {
        if(!first && w.value) weekdaySb.write(",");
        if(w.value) {
          first = false;
          weekdaySb.write(w.key.toUpperCase());
        }
      });
      sb.write(" ${weekdaySb.toString()}");
    }
    
    String output = sb.toString();
    return output;
  }

  Widget defineIncrements(){
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Definer + og - knapperne",
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
        Row(
          children: [
            const Text("1. Knap: "),
            smallTextField(firstIncrementController)
          ]
        ),
        Row(
          children: [
            const Text("2. Knap: "),
            smallTextField(secondIncrementController)
          ]
        ),
        Row(
          children: [
            const Text("3. Knap: "),
            smallTextField(thirdIncrementController)
          ]
        ),
      ],
    );
  }
}

enum DaysToRemind {
  every,
  daysBetween,
  weekDays
}