import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("О программе"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Железнодорожный сортировочный узел",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
              "На правой стороне собрано некоторое число вагонов двух типов, обоих типов по n штук. Тупик может может вмещать все 2n вагонов. Пользуясь тремя сортировочными операциями: В, ИЗ, МИМОЮ собрать на левой стороне так, чтобы типы чередовались. Для решения задачи необходимо 3n-1 сортировочных операций.")
        ],
      ),
    );
  }
}
