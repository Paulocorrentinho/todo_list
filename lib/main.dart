import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _todoList = [];

  final _todoController = TextEditingController();


  void _addTodo() {     //adiciona itens na lista
    setState(() {     //atualiza a tela
      Map<String, dynamic> newTodo = Map();
      newTodo["tilte"] = _todoController.text;
      _todoController.text = "";
      newTodo["ok"] = false;
      _todoList.add(newTodo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.blueAccent),
                  ),
                  child: Text("ADD",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile( //cria uma opcao de marcar ou desmarcar
                    title: Text(_todoList[index]["title"]),
                    value: _todoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(_todoList[index]["ok"] ?
                      Icons.check : Icons.error,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }



  Future<File> _getFile() async {
    //funcao para obter arquivo
    final directory =
    await getApplicationDocumentsDirectory(); //declara um diretorio e pega o diretorio que vai armazenar os arquivos
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    //funcao para salvar o arquivo
    String data = json.encode(_todoList); //importa uma lista em json

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    //funcao para ler os dados do arquivo
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null.toString();
    }
  }
}
