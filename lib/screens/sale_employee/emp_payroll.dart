import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class EmpPayroll extends StatelessWidget {
  const EmpPayroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: const <Widget>[
                  //Lương
                  PayrollExpansionTile(),
                  SizedBox(height: 20.0,),
                  //Thưởng
                  BonusExpansionTile2(),
                ],
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Lương của tôi",
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 20.0,
                  color: Colors.blueGrey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BonusExpansionTile2 extends StatelessWidget {
  const BonusExpansionTile2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          stops: [0.02, 0.01],
          colors: [Colors.green, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Thưởng'),
          trailing: const Text('2.060.500 VNĐ'),
          children: <Widget>[
            const Divider(color: Colors.blueGrey, thickness: 1.0,),
            ListTile(
              title: const Text('Cá nhân', style: TextStyle(fontSize: 12.0,),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Text('Ký mới', style: TextStyle(fontSize: 12.0,),),
                      Text('99.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                    ],
                  ),
                  const SizedBox(width: 20.0,),
                  Column(
                    children: const <Widget>[
                      Text('Tái ký', style: TextStyle(fontSize: 12.0,),),
                      Text('297.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                    ],
                  )
                ],
              ),
            ),
            const ListTile(
              title: Text('Quản lý', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('964.500 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Người hỗ trợ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('CLB 20', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(''
                  '2.060.500 VNĐ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayrollExpansionTile extends StatelessWidget {
  const PayrollExpansionTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          stops: [0.02, 0.01],
          colors: [Colors.red, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: const ExpansionTile(
          title: Text('Lương'),
          trailing: Text('3.000.000 VNĐ'),
          children: <Widget>[
            Divider(color: Colors.blueGrey, thickness: 1.0,),
            ListTile(
              title: Text('Cơ bản', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('3.000.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Gửi xe', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền phạt', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Bảo hiểm cá nhân', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Bảo hiểm công ty đóng', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                '3.000.000 VNĐ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
