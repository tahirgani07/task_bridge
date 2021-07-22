import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedRadio = 0;
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    //selectedRadio=this.selectedRadio;

    List<Services> services = [
      Services(
          "Service  1",
          "This service includes 2 jobs that will be mentioned in detail here , additionally the cost of materials has to be given",
          200,
          true),
      Services("Service  2",
          "this is a description about the service mentioned", 200, true),
      Services("Service  3",
          "this is a description about the service mentioned", 900, true),
      Services("Service  4",
          "this is a description about the service mentioned", 350, false),
      Services("Service  5",
          "this is a description about the service mentioned", 201, true),
    ];

    return Scaffold(
      body: Container(
          height: screensize.height,
          width: screensize.width,
          alignment: Alignment.bottomCenter,
          color: Colors.black,
          padding: EdgeInsets.all(2),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: screensize.height * 0.4,
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(
                  image: AssetImage('assets/images/account-avatar.png'),
                  fit: BoxFit.fitWidth,
                  //scale: 1,
                )),
              ),
              Container(
                  //height: screensize.height *0.9,
                  width: screensize.width,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 100.0,
                          spreadRadius: 30.0,
                          offset: Offset(0, -30.0))
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Worker Name',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                iconSize: 30.0,
                                tooltip: ' Rating',
                                onPressed: () {
                                  print('Rating clicked');
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text('Rating'),
                                            content: Container(
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Text(
                                                    ' 3.4 ',
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  InkWell(
                                                    child: Text(
                                                      'check review',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueAccent,
                                                          fontSize: 18.0,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    onTap: () {
                                                      print('review check');
                                                    },
                                                  )
                                                ]),
                                              ),
                                            ));
                                      });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ))
                          ]),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          //border: Border.all(width: 1.0,color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 7.0,
                              spreadRadius: 0.0,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              iconSize: 30.0,
                              onPressed: () {
                                print('Pressed Location');
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text('Work Location'),
                                          content: Container(
                                            child: SingleChildScrollView(
                                              child: Column(children: [
                                                Text(
                                                  ' Kandivali , Mumbai ',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: InkWell(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontSize: 18.0,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    onTap: () {
                                                      print('Deleted');
                                                    },
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ));
                                    });
                              },
                              icon: Icon(Icons.location_on),
                              color: Colors.white,
                            ),
                            IconButton(
                                iconSize: 30.0,
                                onPressed: () {
                                  print('Pressed History');
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text('Work Location'),
                                            content: Container(
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Text(
                                                    ' long list -- ',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: InkWell(
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      onTap: () {
                                                        print('Deleted');
                                                      },
                                                    ),
                                                  )
                                                ]),
                                              ),
                                            ));
                                      });
                                },
                                icon: Icon(Icons.history),
                                color: Colors.white),
                            IconButton(
                                iconSize: 30.0,
                                onPressed: () {
                                  print('Pressed Count');
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text('Gig count'),
                                            content: Container(
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Text(
                                                    ' 23 plumbing gigs  ',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: InkWell(
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      onTap: () {
                                                        print('Deleted');
                                                      },
                                                    ),
                                                  )
                                                ]),
                                              ),
                                            ));
                                      });
                                },
                                icon: Icon(Icons.check_circle_outlined),
                                color: Colors.white),
                            IconButton(
                              iconSize: 30.0,
                              onPressed: () {
                                print('Pressed tags');
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text('Tags'),
                                          content: Container(
                                            child: SingleChildScrollView(
                                              child: Column(children: [
                                                Text(
                                                  ' #one # two ',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: InkWell(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontSize: 18.0,
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    onTap: () {
                                                      print('Deleted');
                                                    },
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ));
                                    });
                              },
                              icon: Icon(Icons.tag),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        children: List.generate(services.length, (index) {
                          return Card(
                            elevation: 10.0,
                            margin: EdgeInsets.all(10.0),
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(services[index].name,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(services[index].desc,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16.0, fontFamily: 'Poppins')),
                              trailing: Text(services[index].price.toString(),
                                  style: TextStyle(
                                      fontSize: 20.0, fontFamily: 'Poppins')),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              //leading: Text(services[index].active.toString()),
                              onTap: () {
                                print(
                                    'Clicked on ' + services[index].toString());
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('About'),
                                      content: Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    services[index].name,
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  Text(
                                                      services[index]
                                                          .price
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontFamily:
                                                              'Poppins')),
                                                ],
                                              ),
                                              Text(
                                                'Active:  ' +
                                                    services[index]
                                                        .active
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: 'Poppins',
                                                    color: Colors.blue),
                                              ),
                                              Divider(
                                                thickness: 1.0,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                services[index].desc,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily: 'Poppins'),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              InkWell(
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 18.0,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                onTap: () {
                                                  print('Deleted');
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )),
            ]),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('This is to edit');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add a Service'),
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration:
                              InputDecoration(labelText: 'Service name'),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          decoration:
                              InputDecoration(labelText: 'Service Rate'),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          decoration:
                              InputDecoration(labelText: 'Service description'),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        /*  Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.grey,),borderRadius: BorderRadius.circular(10)),
                                //padding: EdgeInsets.all(20),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: selectedRadio,
                                      activeColor: Colors.blue,
                                      onChanged: (val){
                                        setState(() {
                                          selectedRadio= val as int ;
                                        });

                                        print(" $val");
                                      },
                                    ),

                                    Text('Activate ',style: TextStyle(fontFamily:'Poppins',fontSize: 12.0))
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.grey,),borderRadius: BorderRadius.circular(10)),
                                //padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: selectedRadio,
                                      activeColor: Colors.blue,
                                      onChanged: (val){
                                        setState(() {
                                          selectedRadio= val as int ;
                                        });

                                        print(" $val");
                                      },
                                    ),

                                    Text('Deactivate  ',style: TextStyle(fontFamily:'Poppins',fontSize: 12.0))
                                  ],
                                ),
                              ),
                            ],
                          ), */
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18.0,
                                fontFamily: 'Poppins'),
                          ),
                          onTap: () {
                            print('Added to the list');
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
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
