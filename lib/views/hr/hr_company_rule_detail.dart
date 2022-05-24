import 'package:flutter/material.dart';
import 'package:login_sample/models/personal_commission.dart';
import 'package:login_sample/utilities/utils.dart';

class HrCompanyRuleDetail extends StatefulWidget {
  const HrCompanyRuleDetail({Key? key, required this.personalCommission}) : super(key: key);

  final PersonalCommission personalCommission;

  @override
  State<HrCompanyRuleDetail> createState() => _HrCompanyRuleDetailState();
}

class _HrCompanyRuleDetailState extends State<HrCompanyRuleDetail> {

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
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  )
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Phần trăm KPI đạt', style: TextStyle(fontSize: 14.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.percentageOfKpi * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.blueGrey, thickness: 1.0,),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Thưởng kí mới cho NVKD', style: TextStyle(fontSize: 12.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.newSignCommissionForSalesEmloyee * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Thưởng tái kí cho NVKD', style: TextStyle(fontSize: 12.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.renewedSignCommissionForSalesEmployee * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Thưởng kí mới cho TNKD', style: TextStyle(fontSize: 12.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.newSignCommissionForSalesLeader * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Thưởng tái kí cho TNKD', style: TextStyle(fontSize: 12.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.renewedSignCommissionForSalesLeader * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Thưởng kí mới cho TPKD', style: TextStyle(fontSize: 12.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.newSignCommissionForSalesManager * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                const Text('Thưởng tái kí cho TPKD', style: TextStyle(fontSize: 12.0),),
                                const Spacer(),
                                Text('${widget.personalCommission.renewedSignCommissionForSalesManager * 100}%', style: const TextStyle(fontSize: 14.0),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                "Phần trăm KPI đạt ${widget.personalCommission.percentageOfKpi * 100}%",
                style: const TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 18.0,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
