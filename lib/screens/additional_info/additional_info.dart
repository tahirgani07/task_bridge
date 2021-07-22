import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/screens/additional_info/otp_screen.dart';

class AdditionalInfo extends StatefulWidget {
  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  AuthService? _auth;
  User? _user;
  List listItem = ["a", "b", "c", "d"];
  String? valueChoose1;
  String? valueChoose2;
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  int selectedRadio = 0;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);
    _user = Provider.of<User?>(context);
    Size screensize = MediaQuery.of(context).size;

    //valueChoose=listItem.elementAt(0) ;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              height: screensize.height,
              width: screensize.width,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(8),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: screensize.height * 0.9,
                  width: screensize.width,
                  padding: EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center ,
                        children: <Widget>[
                          Text(
                            'Worker\'s Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                fontSize: 26.0),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Phone number',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 20.0)),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),

                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Date of birth:',
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 18.0))),

                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //TextField(decoration: InputDecoration(slabelText: _selectedDate,labelStyle: TextStyle(fontFamily:'Poppins',fontSize: 20.0)),),
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: 25.0,
                                ),
                                InkWell(
                                  child: Text(
                                    "${selectedDate.toLocal()}".split(' ')[0],
                                    style: TextStyle(
                                        backgroundColor: Colors.grey[200],
                                        fontFamily: 'Poppins',
                                        fontSize: 18.0),
                                  ),
                                  onTap: () => _selectDate(context),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Select gender :',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18.0),
                                textAlign: TextAlign.start,
                              )),
                          //TextField(decoration: InputDecoration(prefixIcon:Icon( Icons.tag),labelText: 'Tags',labelStyle: TextStyle(fontFamily:'Poppins',fontSize: 20.0)),),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.blue,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedRadio = val as int;
                                    });

                                    print("male $val");
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Male',
                                    style: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 16.0))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.blue,
                                  onChanged: (val) {
                                    print("female $val");
                                    setState(() {
                                      selectedRadio = val as int;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('female',
                                    style: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 16.0))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Radio(
                                  value: 3,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.blue,
                                  onChanged: (val) {
                                    print("others $val");
                                    setState(() {
                                      selectedRadio = val as int;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Others',
                                    style: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 16.0))
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 25.0,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Select Your Work location :',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18.0),
                                textAlign: TextAlign.start,
                              )),

                          SizedBox(
                            height: 10.0,
                          ),
                          //TextField(decoration: InputDecoration(prefixIcon:Icon( Icons.location_on),labelText: 'location',labelStyle: TextStyle(fontFamily:'Poppins',fontSize: 20.0)),),

                          DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Select State'),
                            value: valueChoose1,
                            onChanged: (newValue) {
                              setState(() {
                                this.valueChoose1 = newValue;
                              });
                              print(newValue);
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 18.0),
                            items: listItem.map((valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Select City '),
                            value: valueChoose2,
                            onChanged: (newValue) {
                              setState(() {
                                this.valueChoose2 = newValue;
                              });
                              print(newValue);
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 18.0),
                            items: listItem.map((valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          TextButton(
                            onPressed: _proceedAndSendOTP,
                            child: Text(
                              "Next >",
                              style: TextStyle(
                                color: Color(0xff0165FF),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }

  _proceedAndSendOTP() async {
    _auth!.firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+918291390570",
      verificationCompleted: (PhoneAuthCredential credential) {
        print("VERIFICATION COMPLETE");
      },
      verificationFailed: (err) {
        print(err);
      },
      codeSent: (vID, _) {
        print("VERIFICATION ID : " + vID);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OtpScreen(vID)));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }
}
