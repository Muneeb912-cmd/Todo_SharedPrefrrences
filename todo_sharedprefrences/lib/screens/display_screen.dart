import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_sharedprefrences/APIs/shared_prefremces_api.dart';
import 'package:todo_sharedprefrences/models/todomodel.dart';

class display_screen extends StatefulWidget {
  const display_screen({super.key});

  @override
  State<display_screen> createState() => _display_screenState();
}

class _display_screenState extends State<display_screen> {
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController description = TextEditingController();
  List<todomodel> task = [];
  bool loaded = false;
  bool editpressed = false;
  int this_id = 0;

  @override
  void initState() {
    populateList();
  }

  populateList() async {
    task = await shared_pref_api().getList();
    if (task != null) {
      setState(() {
        loaded = true;
      });
    }
  }

  getid() {
    int max = 0;
    List<int> ids = [];
    if (task != null) {
      for (var i in task) {
        ids.add(i.id.toInt());
      }
      for (int i in ids) {
        if (i > max) {
          max = i;
        }
      }
      return max + 1;
    } else {
      return 0;
    }
  }

  deleteTaks(int id) {
    for (var i in task) {
      if (i.id == id) {
        task.remove(i);
        break;
      }
    }
    shared_pref_api().saveList(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Todo List',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25, top: 5),
                  child: Text(
                    "Add Todo",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ), //for adding specific space between widgets
            Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: title, //this has been initialized
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 50),
                          hintText: 'Enter Title',
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: date, //this has been initialized
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 50),
                          hintText: 'Enter Date',
                          labelText: 'Date',
                          prefixIcon: const Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1));
                        if (pickedDate != null) {
                          String formatedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            date.text = formatedDate;
                          });
                        } else {
                          if (mounted) {}
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Date not selected!')));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: description, //this has been initialized
                      maxLines: 3,
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 150),
                          hintText: 'Enter Description',
                          labelText: 'Description',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue)),
                              onPressed: () {
                                if (editpressed == false) {
                                  if (title.text != '') {
                                    if (date.text != '') {
                                      if (description.text != '') {
                                        task.add(todomodel(
                                            id: getid(),
                                            title: title.text,
                                            date: date.text,
                                            description: description.text));
                                        shared_pref_api().saveList(task);
                                        populateList();
                                      } else {
                                        print('description missing');
                                      }
                                    } else {
                                      print('date missing');
                                    }
                                  } else {
                                    print('title missing');
                                  }
                                } else {
                                  if (title.text != '') {
                                    if (date.text != '') {
                                      if (description.text != '') {
                                        shared_pref_api().updateList(
                                            task,
                                            this_id,
                                            title.text,
                                            date.text,
                                            description.text);
                                        setState(() {
                                          this_id = 0;
                                          editpressed = false;
                                          populateList();
                                        });
                                      } else {
                                        print('description missing');
                                      }
                                    } else {
                                      print('date missing');
                                    }
                                  } else {
                                    print('title missing');
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue)),
                              onPressed: () {
                                //we will write code here
                                title.clear();
                                date.clear();
                                description.clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    )
                  ],
                )),
            Divider(
              color: Colors.black,
              indent: 15,
              endIndent: 15,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Your Todo List',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: loaded,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: task.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: Key(task[index].id.toString()),
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                  key: Key(task[index].id.toString()),
                                  onDismissed: () {
                                    deleteTaks(task[index].id);
                                  }),
                              children: [
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                )
                              ]),
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    title.text = task[index].title;
                                    date.text = task[index].date;
                                    description.text = task[index].description;
                                    setState(() {
                                      editpressed = true;
                                      this_id = task[index].id;
                                    });
                                  },
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                )
                              ]),
                          child: Card(
                            elevation: 10,
                            color: Colors.blue,
                            margin: EdgeInsets.all(5),
                            child: Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Title : ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        task[index].title,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Deadline : ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        task[index].date,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
