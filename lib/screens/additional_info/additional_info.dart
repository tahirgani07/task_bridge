import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/additional_info/otp_dialog.dart';

class AdditionalInfo extends StatefulWidget {
  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  AuthService? _auth;
  User? _user;

  double _spaceBetweenFields = 20;

  int _curState = -1;
  int _curDistrict = -1;
  String _selectedState = "", _selectedDistrict = "";

  final _formKey = GlobalKey<FormState>();

  TextEditingController _phoneCtl = TextEditingController();
  TextEditingController _dobCtl = TextEditingController();
  DateTime _today = DateTime.now();
  DateTime? _selectedDate;

  TextEditingController _maleCtl = TextEditingController(text: "Male");
  TextEditingController _femaleCtl = TextEditingController(text: "Female");
  TextEditingController _othersCtl = TextEditingController(text: "Others");

  String _gender = "";

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);
    _user = Provider.of<User?>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.done, size: 30),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _proceedAndSendOTP();
              }
            },
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Title bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Text(
                        "Additional Info",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: MyColor.headingText,
                        ),
                      ),
                      // This is just to center align the title.
                      TextButton(
                        onPressed: null,
                        child: Text(""),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone No",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Phone Number TextField
                            TextFormField(
                              validator: (val) => _validatePhoneNo(val),
                              controller: _phoneCtl,
                              decoration: _getInputDecoration(
                                  hintText: "Enter your phone number"),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLength: 10,
                            ),
                            Text(
                              "Note: OTP will be sent on this number.",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: _spaceBetweenFields),

                            Text(
                              "State",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // States DropDownField.
                            FutureBuilder(
                              future: _getStatesData(),
                              builder: (context, snapshot) {
                                List states = [
                                  {
                                    "state_id": -1,
                                    "state_name": "Select a state",
                                  }
                                ];
                                if (snapshot.hasData) {
                                  dynamic data = snapshot.data;
                                  states.addAll(data);
                                }

                                return DropdownButtonFormField<int>(
                                  validator: (val) {
                                    if (val! <= 0)
                                      return "Please select your state.";
                                  },
                                  onChanged: (newVal) {
                                    setState(() {
                                      _curState = newVal!;
                                      // We have to reset current district so that there is no value in it after state changes
                                      _curDistrict = -1;
                                    });
                                    if (_curState > 0)
                                      _selectedState =
                                          states[_curState]["state_name"];
                                    else
                                      _selectedState = "";
                                  },
                                  decoration: _getInputDecoration(),
                                  value: _curState,
                                  items: states.map((state) {
                                    return DropdownMenuItem<int>(
                                      child: Text("${state['state_name']}"),
                                      value: state["state_id"],
                                    );
                                  }).toList(),
                                );
                              },
                            ),

                            SizedBox(height: _spaceBetweenFields),

                            Text(
                              "City",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // City DropDownField
                            FutureBuilder(
                              future: _getDistrictsData(_curState),
                              builder: (context, snapshot) {
                                List districts = [
                                  {
                                    "district_id": -1,
                                    "district_name": "Select a city",
                                  }
                                ];
                                if (snapshot.hasData) {
                                  dynamic data = snapshot.data;
                                  districts.addAll(data);
                                }

                                return DropdownButtonFormField<int>(
                                  validator: (val) {
                                    if (val! <= 0)
                                      return "Please select your city.";
                                  },
                                  onChanged: (newVal) {
                                    setState(() {
                                      _curDistrict = newVal!;
                                    });
                                    if (_curDistrict >= 0) {
                                      districts.forEach((district) {
                                        if (district["district_id"] ==
                                            _curDistrict) {
                                          _selectedDistrict =
                                              district["district_name"];
                                          return;
                                        }
                                      });
                                    } else
                                      _selectedDistrict = "";
                                  },
                                  decoration: _getInputDecoration(),
                                  value: _curDistrict,
                                  items: districts.map((district) {
                                    return DropdownMenuItem<int>(
                                      child:
                                          Text("${district['district_name']}"),
                                      value: district["district_id"],
                                    );
                                  }).toList(),
                                );
                              },
                            ),

                            SizedBox(height: _spaceBetweenFields),

                            Text(
                              "DOB",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // DOB Field
                            TextFormField(
                              validator: (val) {
                                if (val!.isEmpty)
                                  return "Please enter your DOB";
                              },
                              controller: _dobCtl,
                              readOnly: true,
                              decoration: _getInputDecoration(
                                hintText: "Enter your DOB",
                                calenderIcon: true,
                              ),
                              onTap: () async {
                                DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate: _today,
                                  firstDate: DateTime(_today.year - 100),
                                  lastDate: _today,
                                );
                                if (date != null) {
                                  _selectedDate = date;
                                  _dobCtl.text =
                                      "${date.day}/${date.month}/${date.year}";
                                }
                              },
                            ),

                            SizedBox(height: _spaceBetweenFields),

                            Text(
                              "Gender",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    validator: (val) {
                                      if (_gender.isEmpty) return "";
                                    },
                                    controller: _maleCtl,
                                    style: TextStyle(
                                      color: _maleCtl.text == _gender
                                          ? Colors.white
                                          : null,
                                    ),
                                    readOnly: true,
                                    decoration: _getInputDecoration(
                                      setBgColor: _maleCtl.text == _gender,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _gender = "Male";
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                                Flexible(
                                  child: TextFormField(
                                    validator: (val) {
                                      if (_gender.isEmpty) return "";
                                    },
                                    controller: _femaleCtl,
                                    style: TextStyle(
                                      color: _femaleCtl.text == _gender
                                          ? Colors.white
                                          : null,
                                    ),
                                    readOnly: true,
                                    decoration: _getInputDecoration(
                                      setBgColor: _femaleCtl.text == _gender,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _gender = "Female";
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (val) {
                                if (_gender.isEmpty)
                                  return "Please select your gender.";
                              },
                              controller: _othersCtl,
                              style: TextStyle(
                                color: _othersCtl.text == _gender
                                    ? Colors.white
                                    : null,
                              ),
                              readOnly: true,
                              decoration: _getInputDecoration(
                                setBgColor: _othersCtl.text == _gender,
                              ),
                              onTap: () {
                                setState(() {
                                  _gender = "Others";
                                });
                              },
                            ),
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _proceedAndSendOTP() async {
    _auth!.firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91${_phoneCtl.text}",
      verificationCompleted: (PhoneAuthCredential credential) {
        print("VERIFICATION COMPLETE");
      },
      verificationFailed: (err) {
        print(err);
      },
      codeSent: (vID, _) async {
        Flushbar(
          message: "OTP sent successfully",
          duration: Duration(seconds: 3),
        ).show(context);
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return OtpDialog(
              verificationId: vID,
              phoneNo: _phoneCtl.text,
              state: _selectedState,
              city: _selectedDistrict,
              dob: _selectedDate!,
              gender: _gender,
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<List> _getStatesData() async {
    final String response =
        await rootBundle.loadString("assets/json/states.json");
    final data = await json.decode(response);
    return data["states"];
  }

  Future _getDistrictsData(int stateId) async {
    if (stateId <= 0) return [];
    final String response =
        await rootBundle.loadString("assets/json/districts.json");
    final data = await json.decode(response);
    return (data["districts"][stateId - 1]["districts"]);
  }

  _getInputDecoration(
      {String hintText: "", bool setBgColor: false, bool calenderIcon: false}) {
    return InputDecoration(
      fillColor: setBgColor ? MyColor.primaryColor : null,
      filled: setBgColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[350]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[350]!),
      ),
      hintText: hintText,
      suffixIcon: !calenderIcon ? null : Icon(Icons.calendar_today),
      counterText: "",
    );
  }

  _validatePhoneNo(String? val) {
    if (val == null || val.isEmpty) return "Please enter your phone number";
    if (val.trim().length < 10) return "Please enter a valid phone number";
  }
}
