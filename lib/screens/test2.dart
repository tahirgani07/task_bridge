import 'package:flutter/material.dart';

class Test2 extends StatelessWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Services> st = [
      Services("s1", "d1", 200, true),
      Services("s2", "d2", 200, true),
      Services("s3", "d3", 200, true),
      Services("s4", "d4", 200, false),
      Services("s5", "d5", 200, true),
    ];
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: st.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8,
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(st[index].name),
                  subtitle: Text(st[index].desc),
                  trailing: Text(st[index].price.toString()),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Services {
  String name;
  String desc;
  double price;
  bool active;

  Services(this.name, this.desc, this.price, this.active);
}
