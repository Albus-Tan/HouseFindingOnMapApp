import 'dart:convert';

import 'package:app/service/backend_service/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constants.dart';
import '../utils/result.dart';
import '../utils/storage.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _username, _password;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  final List _RegisterMethod = [
    {
      "title": "facebook",
      "icon": Icons.facebook,
    },
    {
      "title": "google",
      "icon": Icons.fiber_dvr,
    },
    {
      "title": "twitter",
      "icon": Icons.account_balance,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // 设置globalKey，用于后面获取FormStat
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
            buildTitle(), // Register
            buildTitleLine(), // Register下面的下划线
            const SizedBox(height: 60),
            buildUserNameTextField(), // 输入邮箱
            const SizedBox(height: 30),
            buildPasswordTextField(context), // 输入密码
            // buildForgetPasswordText(context), // 忘记密码
            const SizedBox(height: 60),
            buildRegisterButton(context), // 登录按钮
            const SizedBox(height: 40),
            // buildOtherRegisterText(), // 其他账号登录
            // buildOtherMethod(context), // 其他登录方式
            buildLoginText(context), // 注册
          ],
        ),
      ),
    );
  }

  Widget buildLoginText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('已有账号?'),
            GestureDetector(
              child: const Text('点击登录', style: TextStyle(color: Colors.green)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "login"),
                    builder: (context) => LoginPage(
                      title: "欢迎登录",
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildOtherMethod(context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _RegisterMethod.map((item) => Builder(builder: (context) {
            return IconButton(
                icon: Icon(item['icon'],
                    color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  //TODO: 第三方登录方法
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${item['title']}登录'),
                        action: SnackBarAction(
                          label: '取消',
                          onPressed: () {},
                        )),
                  );
                });
          })).toList(),
    );
  }

  Widget buildOtherRegisterText() {
    return const Center(
      child: Text(
        '其他账号登录',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Future<Result> _register(String name, String password) async {
    var url = Uri.parse('${Constants.backend}/user/register?name='
        '$name&password=$password');
    final response = await http.post(url);
    if (response.statusCode != 200) {
      return Result(code: 404, msg: "Network may error");
    }
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    var res = Result.fromJson(responseJson);
    return res;
  }

  Widget buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              // 设置圆角
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Register',
              style: Theme.of(context).primaryTextTheme.headline5),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              //TODO 执行注册方法

              _register(_username, _password).then((value) => {
                    if (value.code == 200)
                      {
                        Fluttertoast.showToast(msg: value.msg),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "login"),
                            builder: (context) => const LoginPage(
                              title: "欢迎登录",
                            ),
                          ),
                        ),
                      }
                    else
                      {
                        Fluttertoast.showToast(msg: value.msg),
                      }
                  });
            }
          },
        ),
      ),
    );
  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            // Navigator.pop(context);
            print("忘记密码");
          },
          child: const Text("忘记密码？",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscure, // 是否显示文字
        onSaved: (v) => _password = v!,
        validator: (v) {
          if (v!.isEmpty) {
            return '请输入密码';
          }
          if (v.length < 6) {
            return '密码需大于6位';
          }
        },
        decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = (_isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildUserNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Username'),
      validator: (v) {
        // var emailReg = RegExp(
        //     r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        // if (!emailReg.hasMatch(v!)) {
        //   return '请输入正确的邮箱地址';
        if (v!.length < 3) {
          return '用户名至少为3位';
        }
      },
      onSaved: (v) => _username = v!,
    );
  }

  Widget buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black,
            width: 40,
            height: 2,
          ),
        ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 42),
        ));
  }
}
