import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi/Commm/LoginSignupHeader.dart';
import 'package:flutter_sertifikasi/Commm/TextFormField.dart';
import 'package:flutter_sertifikasi/DatabaseHandler/databaseauth.dart';
import 'package:flutter_sertifikasi/Model/user.dart';
import 'package:flutter_sertifikasi/Screens/signup.dart';
import 'package:flutter_sertifikasi/Screens/beranda.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserName = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  login() async {
    String uname = _conUserName.text;
    String passwd = _conPassword.text;

    if (uname.isEmpty) {
      Fluttertoast.showToast(
          msg: "Tolong masukkan Username",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    } else if (passwd.isEmpty) {
      Fluttertoast.showToast(
          msg: "Tolong masukkan Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    } else {
      await dbHelper.getLoginUser(uname, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Beranda()),
                (Route<dynamic> route) => false);
            Fluttertoast.showToast(
                msg: "Selamat Datang",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1);
          });
        } else {
          Fluttertoast.showToast(
              msg: "Error: Pengguna Tidak Ditemukan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1);
        }
      }).catchError((error) {
        print(error);
        // alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserAuthModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id);
    sp.setString("user_name", user.user_name);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginSignupHeader('MyCashBook'),
                getTextFormField(
                    controller: _conUserName,
                    icon: Icons.person,
                    hintName: 'Username'),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Password',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    // Ketika di klik login maka akan diproses login
                    onPressed: login,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tidak Mempunyai Akun ? '),
                      ElevatedButton(
                        // textColor: Colors.blue,
                        child: Text('Signup'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
