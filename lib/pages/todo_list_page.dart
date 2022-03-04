import 'package:flutter/material.dart';
import 'package:todo_list2/models/todo.dart';
import 'package:todo_list2/repositories/todo_repository.dart';
import 'package:todo_list2/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController =
      TextEditingController(); //cria um controlador
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = []; //cria uma lista
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //impede o app de entrar na area dos icones de horario, etc
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      //widget que define a largura necessaria para o campo de texto
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController
                            .text; //cria uma variavel para armazenamento

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O título não pode ser vazio!';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo); //adiciona os itens na lista
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        //fixedSize: Size(100, 200),     //define o tamanho do botao
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                //da um espasamento de altura entre as rows
                Flexible(
                  child: ListView(
                    //cria uma lista com rolamento dos itens
                    shrinkWrap: true,
                    //define o tamanho de uma lista de acordo com a quantidade de itens
                    children: [
                      for (Todo todo in todos)
                        TodolistItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes', //conta os itens da lista
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        //fixedSize: Size(100, 200),     //define o tamanho do botao
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text('Limpar tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo; //armazena o item da lista
    deletedTodoPos =
        todos.indexOf(todo); //armazena a posicao da lista na variavel
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars(); //deleta a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      //cria uma snackbar
      SnackBar(
        content: Text('Tarefa ${todo.title} foi removida com sucesso!',
            style: TextStyle(
              color: Color(0xff060708),
            )),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          //cria um botao de desfazer no snackbar
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              //atualiza a pagina
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5), //define a duracao da snackbar
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    //cria um alerta
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //cancela o dialogo
            },
            style: TextButton.styleFrom(primary: Color(0xff00d7f3)),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //cancela o dialogo
              deleteAllTodos(); //comando que deleta todos os itens
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    //funcao que deleta os itens
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
