import 'package:flutter/material.dart';
import 'package:flutter_app/provider/FirebaseProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CommonAppBar.dart';

LoginPageState pageState;

class LoginPage extends StatefulWidget {

  @override
  LoginPageState createState() {
    pageState = LoginPageState();
    return pageState;
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<
      ScaffoldMessengerState>();
  FirebaseProvider fp;


  @override
  void initState() {
    super.initState();
    getRememberInfo();
  }


  @override
  void dispose() {
    super.dispose();
    setRememberInfo();
    _mailCon.dispose();
    _pwCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar('LOGIN PAGE', 'login'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _mailCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'e-mail',
                  hintText: '이메일을 입력하세요',
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _pwCon,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력하세요',
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Checkbox(value: doRemember, onChanged: (newValue) {
                    setState(() {
                      doRemember = newValue;
                    });
                  },),
                  Text("Remember Me"),
                ],
              ),
            ),
            // Alert box
            //(fp.getUser() != null && fp.getUser().i),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("LOGIN"),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.cyan,
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(
                        new FocusNode()); // 키보드감춤
                    _signIn();
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("CREATE NEW ACCOUNT"),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/join');
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  void _signIn() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: [
            CircularProgressIndicator(),
            Text("로그인 중입니다.."),
          ],
        ),
      ));
    Future<bool> result = fp.signInWidthEmail(_mailCon.text, _pwCon.text);
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  getRememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("doRemember") ?? false);
    });
    if (doRemember) {
      setState(() {
        _mailCon.text = (prefs.getString("userEmail") ?? "");
        _pwCon.text = (prefs.getString("userPassword") ?? "");
      });
    }
  }

  setRememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPassword", _pwCon.text);
    }
  }

  showLastFBMessage() {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content: Text(fp.getLastFBMessage()),
        action: SnackBarAction(
          label: "Done",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),

      );
  }
}