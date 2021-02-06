import 'package:chs/addDonor.dart';
import 'package:chs/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Donors extends StatefulWidget {
  @override
  _DonorsState createState() => _DonorsState();
}

class _DonorsState extends State<Donors> {
  String name, blood, city, contact, refName;
  var queryResultset = [];
  var tempSearchStore = [];
  bool isSearching = false;

  TextEditingController _searchController = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;

  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
          title: !isSearching
              ? Text("Home")
              : TextFormField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.green.withAlpha(30),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Search Donors',
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toLowerCase();
                    });
                    // print(val);
                  },
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        searchString = '';
                        this.isSearching = !this.isSearching;
                      });
                    })
                : IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        this.isSearching = !this.isSearching;
                      });
                    }),
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  Future<void> _showMyDialog() async {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Do you want to logout'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              },
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.red,
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic)),
                            ),
                            TextButton(
                              child: Text('No'),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.green,
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }

                  _showMyDialog();
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: (searchString == null || searchString.trim() == '')
                ? FirebaseFirestore.instance.collection("Donors").snapshots()
                : FirebaseFirestore.instance
                    .collection("Donors")
                    .where('searchIndex', arrayContains: searchString)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("We got can error${snapshot.error}");
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                case ConnectionState.none:
                  return Text("oop no data presented");

                case ConnectionState.done:
                  return Text("we are done");
                default:
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: Colors.white70,
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                //  color: Colors.white,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 15, 15, 0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      child: Icon(
                                        Icons.person,
                                      ),
                                      width: 40,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Future<void> _showMyDialog() async {
                                            name = snapshot
                                                .data.docs[index]["FullName"]
                                                .toString();
                                            blood = snapshot
                                                .data.docs[index]["BloodGroup"]
                                                .toString();
                                            contact = snapshot.data.docs[index]
                                                ["PhoneNO"];
                                            city = snapshot
                                                .data.docs[index]["City"]
                                                .toString();
                                            refName = snapshot.data
                                                .docs[index]["ReferenceName"]
                                                .toString();
                                            return showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                  title:
                                                      Text(name.toUpperCase()),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            "Reference Name : $refName"),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'Blood Group : $blood'),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text('City : $city'),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text('Cell : $contact'),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 0, 60, 0),
                                                      child: ButtonTheme(
                                                        minWidth: 150.0,
                                                        height: 45.0,
                                                        child: RaisedButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Ok",
                                                            style: TextStyle(
                                                                fontSize: 18.0),
                                                          ),
                                                          color: Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }

                                          _showMyDialog();
                                        },
                                        child: Text(
                                          snapshot.data.docs[index]["FullName"]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: Text(
                                        snapshot.data.docs[index]["BloodGroup"],
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        contact = snapshot.data.docs[index]
                                            ["PhoneNO"];
                                        makingPhoneCall(contact);
                                      },
                                      child: Icon(
                                        Icons.call,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        name = snapshot
                                            .data.docs[index]["FullName"]
                                            .toString();
                                        DocumentReference documentReference =
                                            FirebaseFirestore.instance
                                                .collection('Donors')
                                                .doc(name);

                                        documentReference
                                            .delete()
                                            .whenComplete(() {
                                          print("$name deleted");
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                      //return Text(snapshot.data.docs[index]["FullName"]);
                    },
                  );
              }
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDonor()),
            );
          },
          label: Text('Add Donor'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.red,
        ));
  }
}

makingPhoneCall(String number) async {
  String url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
