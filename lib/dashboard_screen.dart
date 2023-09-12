import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_todo/constants.dart';
import 'package:manage_todo/main.dart';
import 'package:manage_todo/todos.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardScreenState();
}

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final String toDosString = sharedPreferences.getString(toDosList) ?? '';
    List<ToDos> myTodosList = [];

    if (toDosString.isNotEmpty) {
      myTodosList = ToDos.decode(toDosString);
    }

    return SafeArea(
      child: Scaffold(
        appBar: myTodosList.isEmpty
            ? null
            : AppBar(
                backgroundColor: primaryColor,
                title: const Text("My ToDos"),
              ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: SizedBox(
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Text(
                              "Add your ToDo",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Title", style: Theme.of(context).textTheme.labelLarge),
                                TextFormField(
                                  controller: titleController,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: primaryColor),
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description", style: Theme.of(context).textTheme.labelLarge),
                                TextFormField(
                                  controller: descriptionController,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: primaryColor),
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.pop(context);

                                  String title = titleController.text;
                                  String description = descriptionController.text;

                                  if (title.isNotEmpty && description.isNotEmpty) {
                                    setState(() {
                                      myTodosList.add(ToDos(title: title, description: description));

                                      String encodedData = ToDos.encode(myTodosList);
                                      sharedPreferences.setString(toDosList, encodedData);
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                ),
                                child: Text('Create', style: Theme.of(context).textTheme.bodyMedium!))
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: primaryColor,
            child: const Icon(Icons.add)),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: myTodosList.isEmpty
                  ? const EmptyList()
                  : ListView.builder(
                      itemCount: myTodosList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: UniqueKey(),
                          confirmDismiss: (DismissDirection direction) async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Did u completed the task and move to trash?',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('No, In-Progress'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        myTodosList.removeAt(index);
                                        String encodedData = ToDos.encode(myTodosList);
                                        sharedPreferences.setString(toDosList, encodedData);

                                        Navigator.pop(context, true);
                                        setState(() {});
                                      },
                                      child: const Text('Yes, Completed'),
                                    )
                                  ],
                                );
                              },
                            );

                            return confirmed;
                          },
                          child: Card(
                            color: Colors.blueGrey,
                            child: ListTile(
                                title: Text(
                                  myTodosList[index].title,
                                ),
                                subtitle: Text(
                                  myTodosList[index].description,
                                )),
                          ),
                        );
                      }),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/empty_list.svg'),
        const SizedBox(height: 16),
        Text(
          'What do you want to do today?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          'Tap + to add your tasks',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
