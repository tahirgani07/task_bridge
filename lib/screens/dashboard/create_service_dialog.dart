import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/services/service_model.dart';
import 'package:task_bridge/others/loading_dialog/loading_dialog.dart';
import 'package:task_bridge/others/my_colors.dart';

class CreateService extends StatefulWidget {
  final String uid;
  CreateService(this.uid);

  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  TextEditingController _nameCtl = TextEditingController();
  TextEditingController _descCtl = TextEditingController();
  TextEditingController _priceCtl = TextEditingController();
  TextEditingController _linkCtl = TextEditingController();

  FocusNode _nameFc = new FocusNode();
  FocusNode _descFc = new FocusNode();
  FocusNode _priceFc = new FocusNode();
  FocusNode _linkFc = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    _priceCtl.dispose();
    _linkCtl.dispose();
    _nameFc.dispose();
    _descFc.dispose();
    _priceFc.dispose();
    _linkFc.dispose();
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
              _getTextField(
                controller: _priceCtl,
                focusNode: _priceFc,
                nextFocusNode: _linkFc,
                label: "Enter a price",
                validator: (val) {
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
                  return null;
                },
                digitsOnly: true,
              ),
              SizedBox(height: 20),
              Text(
                "Link",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _getTextField(
                controller: _linkCtl,
                focusNode: _linkFc,
                label: "Enter a link to previous works",
                validator: (val) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addService() async {
    LoadingDialog.showLoadingDialog(context);
    String er = await ServiceModel.addService(
      uid: widget.uid,
      name: _nameCtl.text,
      desc: _descCtl.text,
      price: double.parse(_priceCtl.text),
      link: _linkCtl.text.isEmpty ? "" : _linkCtl.text,
    );
    LoadingDialog.dismissLoadingDialog(context);

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
  }) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.red),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: validator,
        maxLength: maxLength,
        onEditingComplete: (nextFocusNode == null)
            ? () => focusNode.unfocus()
            : () => nextFocusNode.requestFocus(),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        textInputAction: (nextFocusNode == null)
            ? TextInputAction.done
            : TextInputAction.next,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: Color(0xffA0A8B6),
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
