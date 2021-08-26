import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/services/service_model.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';
import 'package:task_bridge/others/my_colors.dart';

class CreateService extends StatefulWidget {
  final String creatorUid;
  final String combinedUid;
  final String createdForUid;
  CreateService({
    required this.creatorUid,
    required this.combinedUid,
    required this.createdForUid,
  });

  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  TextEditingController _nameCtl = TextEditingController();
  TextEditingController _descCtl = TextEditingController();
  TextEditingController _priceCtl = TextEditingController();

  FocusNode _nameFc = new FocusNode();
  FocusNode _descFc = new FocusNode();
  FocusNode _priceFc = new FocusNode();

  bool _priceVariable = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    _priceCtl.dispose();
    _nameFc.dispose();
    _descFc.dispose();
    _priceFc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    Size _size = MediaQuery.of(context).size;

    return AlertDialog(
      scrollable: true,
      actions: [
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
            "Close",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _addService();
            }
          },
          color: MyColor.primaryColor,
          textColor: Colors.white,
          child: Text(
            "Add",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text("New Service"),
      content: Container(
        width: _size.width,
        color: Colors.transparent,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name *",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              _getTextField(
                controller: _nameCtl,
                focusNode: _nameFc,
                nextFocusNode: _descFc,
                label: "Enter your service's name",
                validator: (val) => _nullValidator(val ?? "", "Name"),
                maxLength: 40,
              ),
              SizedBox(height: 20),
              Text(
                "Description *",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              _getTextField(
                controller: _descCtl,
                focusNode: _descFc,
                nextFocusNode: _priceFc,
                label: "Enter a description",
                validator: (val) => _nullValidator(val ?? "", "Description"),
              ),
              SizedBox(height: 20),
              Text(
                "Price *",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              _getTextField(
                enabled: !_priceVariable,
                controller: _priceCtl,
                focusNode: _priceFc,
                label: "Enter a price",
                validator: (val) {
                  if (!_priceVariable) {
                    String er = _nullValidator(val ?? "", "Price") ?? "";
                    if (er.isNotEmpty) return er;
                    er = er.trimLeft();
                    er = er.trimRight();
                    er = "Please enter a valid Price";
                    if (val![val.length - 1] == '.') return er;
                    int dotCnt = 0;
                    for (int i = 0; i < val.length; i++)
                      if (val[i] == '.') dotCnt++;
                    if (dotCnt > 1) return er;
                  }
                  return null;
                },
                digitsOnly: true,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _priceVariable,
                    onChanged: (val) {
                      setState(() {
                        _priceVariable = val!;
                      });
                    },
                  ),
                  Flexible(child: Text("Price is not fixed or variable")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addService() async {
    ShowAlert.showLoadingDialog(context);
    String er = await ServiceModel.sendService(
      creatorUid: widget.creatorUid,
      combinedUid: widget.combinedUid,
      name: _nameCtl.text,
      desc: _descCtl.text,
      price: !_priceVariable ? double.parse(_priceCtl.text) : -1,
      createdForUid: widget.createdForUid,
    );
    ShowAlert.dismissLoadingDialog(context);

    if (er.isEmpty) {
      Navigator.of(context).pop();
      Flushbar(
        message: "Service added successfully",
        duration: Duration(seconds: 3),
      ).show(context);
    } else {
      Flushbar(
        title: "Error",
        message: er,
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  _nullValidator(String? val, String fieldName) {
    if (val == null || val.trim().isEmpty) return "Enter a $fieldName";
    return null;
  }

  _getTextField({
    required TextEditingController controller,
    required focusNode,
    required String label,
    FocusNode? nextFocusNode,
    bool obscureText: false,
    required String? validator(String? val),
    bool digitsOnly: false,
    int? maxLength,
    bool enabled: true,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.red),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: validator,
        maxLength: maxLength,
        enabled: enabled,
        onEditingComplete: (nextFocusNode == null)
            ? () => focusNode.unfocus()
            : () => nextFocusNode.requestFocus(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: !enabled ? Colors.grey[400] : Colors.black,
        ),
        textInputAction: (nextFocusNode == null)
            ? TextInputAction.done
            : TextInputAction.next,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.only(bottom: 15, left: 10),
          labelStyle: TextStyle(fontSize: 17.5, color: Color(0xffA0A8B6)),
          alignLabelWithHint: true,
        ),
        keyboardType: digitsOnly ? TextInputType.number : null,
        inputFormatters: digitsOnly
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[\d+.]')),
              ]
            : null,
      ),
    );
  }
}
