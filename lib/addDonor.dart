import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:chs/ui/widgets/textformfield.dart';

class AddDonor extends StatefulWidget {
  @override
  _AddDonorState createState() => _AddDonorState();
}

class _AddDonorState extends State<AddDonor> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  String a;
  TextEditingController fullName = TextEditingController();
  TextEditingController referenceName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController mobileNO = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.red,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Add New Donor",
              textAlign: TextAlign.center,
            )),
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: _height / 25,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                form(),

                SizedBox(
                  height: _height / 35,
                ),

                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 50.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            bloodGroupTextFormField(),
            SizedBox(height: _height / 20.0),
            addButton()
          ],
        ),
      ),
    );
  }

  final controller = TextEditingController();

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Enter Full Name",
      textEditingController: fullName,
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Enter Reference Name",
      textEditingController: referenceName,
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      icon: Icons.location_city,
      hint: "City",
      textEditingController: city,
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      hint: "Mobile Number",
      textEditingController: mobileNO,
    );
  }

  Widget bloodGroupTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.group_add,
      hint: "Blood group",
      textEditingController: bloodGroup,
    );
  }

  Widget addButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: ButtonTheme(
          minWidth: 250.0,
          height: 150.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () async {
              WidgetsFlutterBinding.ensureInitialized();
              await Firebase.initializeApp();
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('Donors')
                  .doc(fullName.text);
              List<String> splitList = bloodGroup.text.split(" ");

              List<String> indexList = [];
              for (int i = 0; i < splitList.length; i++)
                for (int j = 0; j < splitList[i].length + i; j++) {
                  indexList.add(splitList[i].substring(0, j).toLowerCase());
                }
              indexList.add(bloodGroup.text);
              Map<String, dynamic> students = {
                "FullName": fullName.text,
                "ReferenceName": referenceName.text,
                "City": city.text,
                "PhoneNO": mobileNO.text,
                "BloodGroup": bloodGroup.text.toLowerCase(),
                "searchIndex": indexList,
              };

              documentReference.set(students).whenComplete(() {
                print(" created");
                setState(() {
                  fullName.text = '';
                  referenceName.text = '';
                  city.text = '';
                  mobileNO.text = '';
                  bloodGroup.text = '';
                  indexList.clear();
                });
                _showMyDialog(context);
              });
            },
            child: Text(
              "Add Donor",
              style: TextStyle(fontSize: 18.0),
            ),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Done'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Recored is added'),
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Ok",
              style: TextStyle(fontSize: 18.0),
            ),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ],
      );
    },
  );
}
