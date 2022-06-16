import 'package:alltracker_app/models/consumption_post.dart';
import 'package:alltracker_app/models/consumption_registration.dart';
import 'package:alltracker_app/pages/graphs.dart';
import 'package:flutter/material.dart';

import '../utils/api_repository.dart';

class SelectPostsPage extends StatefulWidget {
  final List<ConsumptionPost> posts;
  const SelectPostsPage({Key? key, required this.posts}) : super(key: key);

  @override
  State<SelectPostsPage> createState() => _SelectPostsPageState();
}

class _SelectPostsPageState extends State<SelectPostsPage> {
  List<ConsumptionPost> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vælg poster"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: widget.posts.map((cp) => listEntry(cp)).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Future<List<ConsumptionRegistration>>> futures = [];
          // List<Future<List<ConsumptionRegistration>>> regFutures = [];
          for (var i = 0; i < selected.length; i++) {
            futures.add(ApiRepository().getRegistrations(selected[i].id));
          }
          var regs = await Future.wait<List<ConsumptionRegistration>>(futures);
          for (var i = 0; i < selected.length; i++) {
            selected[i].registrations = regs[i]..sort((a, b) => a.date.compareTo(b.date));
          }
          Navigator.of(context).push(MaterialPageRoute(
            // builder: (context) => _LineChart(isShowingMainData: true, posts: selected,)
            builder: (context) => GraphsPage(posts: selected)
          ));
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget listEntry(ConsumptionPost post){
    return GestureDetector(
      onTap: () {
          if(!selected.contains(post)) {
            setState(() {
                selected.add(post);
            });
          } else {
            setState(() {
              selected.remove(post);
            });
          }
          // checked = !checked;
      },
      child: ListTile(
        leading: Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: selected.contains(post), 
          onChanged: (bool? value) {
            if(!selected.contains(post)) {
              setState(() {
                  selected.add(post);
              });
            } else {
              setState(() {
                selected.remove(post);
              });
            }
          }
        ),
        title: Text(post.name),
      ),
    );
  }
}


