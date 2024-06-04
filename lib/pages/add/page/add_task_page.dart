import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/providers/categories_provider.dart';
import 'package:task_planner/providers/date_provider.dart';
import 'package:task_planner/providers/priority_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  String _enteredTitle = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ref.read(dateProvider.notifier).toggleIsDateSelected();
    super.initState();
  }

  void selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
    );

    if (date == null) {
      return;
    }
    ref.read(dateProvider.notifier).selectDate(date);
  }

  @override
  Widget build(BuildContext context) {
    Categories enteredCategory = ref.watch(categorySelectProvider);
    Priorities enteredPriority = ref.watch(prioritySelectProvider);
    DateTime enteredDate = ref.watch(dateProvider);
    bool isDateSelected = ref.watch(dateProvider.notifier).isDateSelected;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create new task',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  sizedBoxHeight(20),
                  Text(
                    'Task Title',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      hintText: 'Enter a title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredTitle = newValue!;
                    },
                  ),
                  sizedBoxHeight(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              value: enteredCategory,
                              items: [
                                for (var i in Categories.values)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: categoryTextColors[
                                                i.name.toUpperCase()],
                                          ),
                                        ),
                                        sizedBoxWidth(8),
                                        Text(
                                          i.name.toUpperCase(),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                              onChanged: (value) {
                                ref
                                    .read(categorySelectProvider.notifier)
                                    .selectCategory(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton(
                              value: enteredPriority,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              items: [
                                for (var i in Priorities.values)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: priorityColors[i],
                                          ),
                                        ),
                                        sizedBoxWidth(8),
                                        Text(
                                          i.name.toUpperCase(),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                              onChanged: (value) {
                                ref
                                    .read(prioritySelectProvider.notifier)
                                    .selectPriority(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  sizedBoxHeight(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          !isDateSelected
                              ? ElevatedButton(
                                  onPressed: selectDate,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.calendar_month),
                                      Text('Select date'),
                                    ],
                                  ),
                                )
                              : Text(
                                  '${enteredDate.month} / ${enteredDate.day} / ${enteredDate.year}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                        ],
                      ),
                    ],
                  ),
                  sizedBoxHeight(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.cancel),
                            Text('Cancel'),
                          ],
                        ),
                      ),
                      sizedBoxWidth(10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final DocumentReference docRef =
                                await collectionReference.add({
                              'title': _enteredTitle,
                              'priority': enteredPriority.name.toUpperCase(),
                              'category': enteredCategory.name.toUpperCase(),
                              'status': false,
                              'date': Timestamp.fromDate(enteredDate),
                            });
                            await docRef.update({'id': docRef.id});
                          } else if (!isDateSelected) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a date'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a title'),
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check,
                            ),
                            Text('Create'),
                          ],
                        ),
                      ),
                    ],
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
