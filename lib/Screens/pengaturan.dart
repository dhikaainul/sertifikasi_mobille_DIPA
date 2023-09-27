import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi/Commm/TextFormField.dart';
import 'package:flutter_sertifikasi/DatabaseHandler/databaseauth.dart';
import 'package:flutter_sertifikasi/Model/user.dart';
import 'package:flutter_sertifikasi/Screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  late DatabaseHelper dbHelper;
  final _password = TextEditingController();
  final _conUserId = TextEditingController();
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conCurrentPassword = TextEditingController();
  final _conNewPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DatabaseHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conDelUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      // _conNewPassword.text = sp.getString("password")!;
      _password.text = sp.getString("password")!;
    });
  }

  update() async {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conNewPassword.text;
    String password = _password.text;
    String passwdlama = _conCurrentPassword.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final user = await dbHelper.getUser(uid);
      if (user != null && user.password == password) {
        UserAuthModel user = UserAuthModel(uid, uname, email, passwd);
        await dbHelper.updateUser(user).then((value) {
          if (value == 1) {
            // alertDialog(context, "Successfully Updated");

            updateSP(user, true).whenComplete(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                  (Route<dynamic> route) => false);
            });
            Fluttertoast.showToast(
                msg: "Password Sukses Diupdate",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1);
          } else {
            Fluttertoast.showToast(
                msg: "Error Update",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1);
          }
        }).catchError((error) {
          print(error);
          Fluttertoast.showToast(
              msg: "Error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Password saat ini tidak benar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);
      }
    }
  }

  Future updateSP(UserAuthModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user.user_name);
      sp.setString("email", user.email);
      sp.setString("password", user.password);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Update
                  getTextFormField(
                    controller: _conCurrentPassword,
                    icon: Icons.lock,
                    hintName: 'Password Lama',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conNewPassword,
                    icon: Icons.lock,
                    hintName: 'Password Baru',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 5),
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue),
                      // Ketika di klik login maka akan diproses login
                      onPressed: update,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    width: double.infinity,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.green),
                      // Ketika di klik login maka akan diproses login
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Kembali",
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 45,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {
                        //LogOut dengan navigator.push ke LoginForm()
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Login()),
                            (Route<dynamic> route) => false);
                        Fluttertoast.showToast(
                            msg: "Berhasil Log Out",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1);
                      },
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(30),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'About This MyApp',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/foto.png'), // Ganti dengan path ke gambar profil lokal Anda
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Dhika Ainul Luthfi',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '2241727007',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tanggal : 27 September 2023',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
