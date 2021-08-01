import 'package:flutter/material.dart';
import 'package:task_bridge/models/services/service_model.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String uid = "B5IsjXLRWkTc8FQjgPp4omTLWb93";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Service>>(
          stream: ServiceModel.getServices(uid),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, ind) {
                  Service curService = snapshot.data![ind];
                  return Material(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("${curService.name}"),
                              Text(
                                "Rs. ${curService.price.toStringAsFixed(2)}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("${curService.desc}"),
                              Text(
                                "Rs. ${curService.active}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container(
              child: Center(
                child: Text(
                  "No Services Added yet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
