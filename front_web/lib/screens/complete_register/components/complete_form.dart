import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:openet/components/back_login_line.dart';
import 'package:openet/components/default_button.dart';
import 'package:http/http.dart' as http;
import 'package:openet/utils/requests.dart';

class CompleteForm extends StatefulWidget {
  CompleteForm({Key key, this.user}) : super(key: key);
  final GoogleSignInAccount user;

  @override
  _CompleteFormState createState() => _CompleteFormState();
}

class _CompleteFormState extends State<CompleteForm> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  Map<String, List<int>> cursos;
  String email = '', curso = 'Administração';
  String f_name = '', l_name = '';
  int periodo = 1;
  DateTime born;

  void selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      // locale: const Locale("pt_br", "PT_BR"),
      errorFormatText: 'Data inválida.',
      errorInvalidText:
          'Informe uma data anterior á 01/01/${DateTime.now().year - 15}',
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year - 15),
      helpText: 'Date de Nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (picked != null) {
      setState(() {
        born = picked;
      });
    }
  }

  String bornDateTextField(DateTime time) {
    if (time == null) {
      return '00/00/0000';
    } else {
      return '${time.day < 10 ? '0' : ''}${time.day}/${time.month < 10 ? '0' : ''}${time.month}/${time.year}';
    }
  }

  Future<void> getCursos() async {
    var uri = Uri.parse('http://127.0.0.1:3333/cursos');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      cursos = new Map();
      var body = json.decode(response.body);
      for (int i = 0; i < body.length; i++) {
        List<int> periods = new List();
        for (int p = 1; p < int.parse(body[i]['max_periodo']) + 1; p++) {
          periods.add(p);
        }
        cursos.putIfAbsent(body[i]['name'], () => periods);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cursos == null) {
      getCursos();
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BackLoginLine(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Cadastre-se',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.user.displayName.split(' ')[0],
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return 'Informe um Nome válido';
                    }
                    setState(() {
                      f_name = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    prefixIcon: Icon(Icons.contact_page_rounded),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: widget.user.displayName
                      .split(' ')
                      .getRange(1, widget.user.displayName.split(' ').length)
                      .toString()
                      .replaceFirst('(', '')
                      .replaceFirst(')', ''),
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return 'Informe um Sobre Nome válido';
                    }
                    setState(() {
                      l_name = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Sobre Nome',
                    prefixIcon: Icon(Icons.contact_page_rounded),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          buildEmailFormFiled(),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                'Curso',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff7E7E7E),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Expanded(
                flex: 2,
                child: cursos != null
                    ? DropdownButtonFormField(
                        value: curso,
                        onChanged: (value) {
                          setState(() {
                            curso = value;
                          });
                        },
                        dropdownColor: Color(0xFFCCCCCC),
                        items: cursos.keys.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                      )
                    : DropdownButtonFormField(items: []),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 120,
                child: Text(
                  'Data De Nascimento',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff7E7E7E),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  selectDate(context);
                },
                child: Container(
                  height: 50,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF7E7E7E),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    bornDateTextField(born),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Periodo',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff7E7E7E),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: cursos != null
                    ? DropdownButtonFormField(
                        value: 1,
                        onChanged: (value) {
                          setState(() {
                            periodo = value;
                          });
                        },
                        dropdownColor: Color(0xFFCCCCCC),
                        items: cursos.entries
                            .firstWhere((element) => element.key == curso)
                            .value
                            .map((value) {
                          return DropdownMenuItem(
                            child: Text('$value'),
                            value: value,
                          );
                        }).toList(),
                      )
                    : DropdownButtonFormField(items: []),
              ),
            ],
          ),
          SizedBox(
            height: 65,
          ),
          DefaultButton(
            text: 'Cadastre-se',
            event: () {
              if (_formKey.currentState.validate()) {
                createUser(
                    context: context,
                    first_name: f_name,
                    last_name: l_name,
                    born: born,
                    curso: curso,
                    email: email,
                    password: '',
                    periodo: periodo,
                    g_id: widget.user.id);
              }
            },
          )
        ],
      ),
    );
  }

  TextFormField buildEmailFormFiled() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        value = value.trim();
        if (value.isEmpty || !emailValidatorRegExp.hasMatch(value)) {
          return 'Informe um Email válido.';
        } else {
          if (kIsWeb) {
            email = value;
          }
          return null;
        }
      },
      enabled: false,
      initialValue: widget.user.email,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(Icons.mail),
      ),
    );
  }
}
