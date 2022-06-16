import 'package:alltracker_app/components/consumption_post_widget.dart';
import 'package:alltracker_app/models/consumption_post.dart';
import 'package:alltracker_app/pages/create_consumption_post.dart';
import 'package:alltracker_app/pages/select_posts.dart';
import 'package:flutter/material.dart';

import '../utils/api_repository.dart';
class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);
  final double padding = 8;
  List<ConsumptionPost> posts = [];

  @override
  Widget build(BuildContext context) {
    Widget test = _postsList();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      height: 100,
                      backgroundColor: const Color(0x0ccccccc),
                      borderColor: Theme.of(context).primaryColor,
                      text: "Opret ny forbrugspost", 
                      callback: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: ((context) => CreateConsumptionPost()))
                      ).then((_) => test = _postsList())
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      height: 100,
                      text: "Oversigt",
                      callback: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => SelectPostsPage(posts: posts))
                        ));
                      },
                    ),
                    // child: StyledTextButton(
                    //   text: "Oversigt", 
                    //   callback: () {}, 
                    //   backgroundColor: Theme.of(context).primaryColor, 
                    //   textColor: Colors.white
                    // ),
                  )
                ],
              ),
              test,
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _postsList() {
    return FutureBuilder(
      future: ApiRepository().makeRegistrations(),
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          posts = snapshot.data;
          var tmp = snapshot.data
            .map<Widget>((cp) => PostWidget(post: cp, reg: cp.registrations[0]))
            .toList();
          // var sutmig = snapshot.
          return Column(
            children: tmp,
          );
        } else if (snapshot.hasError){
          return Align(
            alignment: Alignment.center,
            child: Text(snapshot.error?.toString() ?? "Noget gik galt"),
          );
        } else {
          return Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: const Color(0x0ccccccc),
            ),
          );
        }
      }
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double height;
  final String text;
  final Function() callback;
  
  const CustomButton({
    Key? key, 
    this.backgroundColor,
    this.textColor = Colors.white, 
    this.borderColor,
    required this.height, 
    required this.text, 
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: borderColor ?? Colors.transparent)
      ),
      height: height,
      child: InkWell(
        splashColor: Colors.white,
        onTap: callback,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}