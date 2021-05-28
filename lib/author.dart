import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Author extends StatelessWidget {
  const Author({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Об авторе"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Бекина Мария Павловна"),
          Text("Группа: ИВБО-05-18"),
          Text("2021"),
          InkWell(
            child: Text(
              "+7 (901) 748-18-21",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Clipboard.setData(ClipboardData(text: "+7 (901) 748-18-21"));
              //  SnackBar(content: Text("Номер скопирован")).
            },
          )
        ],
      ),
    );
  }
}
