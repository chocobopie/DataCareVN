import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/models/providers/authenticate.dart';
import 'package:login_sample/views/wrapper.dart';
import 'package:login_sample/utilities/account_preference.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const DataCareVN());
}

class DataCareVN extends StatelessWidget {
  const DataCareVN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Account> getAccountData() => AccountPreferences().getAccount();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('vi', ''),
        ],
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: getAccountData(),
            builder: (context, snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return const Wrapper();
                  } else {
                    AccountPreferences().removeAccount();
                    return const Wrapper();
                  }
              }
            }
        ),
      ),
    );
  }
}

