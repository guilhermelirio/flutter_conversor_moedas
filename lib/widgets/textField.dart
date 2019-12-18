import 'package:flutter/material.dart';

Widget buildTextField(String label, String prefixo, TextEditingController controller, Function funcao, Function limpar){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder( 
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10)
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      prefixText: prefixo,
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 26.0
    ),
    onChanged: funcao,
    onTap: limpar,  
    keyboardType: TextInputType.number,
  );
}