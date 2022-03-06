import 'package:flutter/material.dart';
import 'package:login_sample/models/temp/contact_temp.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/screens/sale_leader/team_contact_detail.dart';

class TeamContactList extends StatefulWidget {
  const TeamContactList({Key? key}) : super(key: key);

  @override
  _TeamContactListState createState() => _TeamContactListState();
}

class _TeamContactListState extends State<TeamContactList> {

  bool isSearching = false;

  List<Contact> contacts = [
    Contact(id: '1', name: 'Nguyen Van A', email: 'hello1@gmail.com', phoneNumber: '123456789', createDate: DateTime.now(), contactOwner: 'Sale1', company: ''),
    Contact(id: '2', name: 'Nguyen Van B', email: 'hello2@gmail.com', phoneNumber: '295734821', createDate: DateTime.now(), contactOwner: '', company: ''),
    Contact(id: '3', name: 'Nguyen Van C', email: 'hello3@gmail.com', phoneNumber: '957275849', createDate: DateTime.now(), contactOwner: '', company: ''),
    Contact(id: '4', name: 'Nguyen Van D', email: 'hello4@gmail.com', phoneNumber: '947845638', createDate: DateTime.now(), contactOwner: '', company: ''),
    Contact(id: '5', name: 'Nguyen Van E', email: 'hello5@gmail.com', phoneNumber: '184957483', createDate: DateTime.now(), contactOwner: '', company: ''),
    Contact(id: '6', name: 'Nguyen Van F', email: 'hello6@gmail.com', phoneNumber: '8294057294', createDate: DateTime.now(), contactOwner: '', company: ''),
    Contact(id: '7', name: 'Nguyen Van G', email: 'hello7@gmail.com', phoneNumber: '8574638485', createDate: DateTime.now(), contactOwner: 'Sale7', company: ''),
    Contact(id: '8', name: 'Nguyen Van H', email: 'hello8@gmail.com', phoneNumber: '7645384957', createDate: DateTime.now(), contactOwner: 'Sale8', company: ''),
    Contact(id: '9', name: 'Nguyen Van Y', email: 'hello9@gmail.com', phoneNumber: '6746393746', createDate: DateTime.now(), contactOwner: 'Sale9', company: ''),
    Contact(id: '10', name: 'Nguyen Van K', email: 'hello10@gmail.com', phoneNumber: '1846454839', createDate: DateTime.now(), contactOwner: 'Sale10', company: ''),
  ];

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
            elevation: 20.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        child: TextField(
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Số khách hàng',
                            hintText: '${contacts.length}',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 106, 144),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 100.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.01),
                child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.only(left: leftRight, right: leftRight, bottom: leftRight),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ListTile(
                            title: Text(contacts[index].name),
                            leading: const Icon(Icons.supervised_user_circle),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            dense: true,
                            subtitle: Text(contacts[index].email),
                            onTap: () async {
                              dynamic contact = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => TeamContactDetail(
                                  contact: contacts[index],
                                ),
                              ));
                              setState(() {
                                if(contact!= null){
                                  contacts[index] = contact;
                                  if(contacts[index].id == 'delete'){
                                    contacts.removeAt(index);
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !isSearching
                  ? const Text("Danh sách khách hàng",style: TextStyle(color: Colors.blueGrey),)
                  : const TextField(
                style: TextStyle(color: Colors.blueGrey,),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  icon: Icon(Icons.search,
                    color: Colors.blueGrey,
                  ),
                  hintText: "Search name, email",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              actions: <Widget>[
                isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    setState(() {
                      isSearching = false;
                    });
                  },
                ) : IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: (){
                    setState(() {
                      isSearching = true;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
