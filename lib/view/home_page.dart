import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modal/fitness.dart';
import '../provider/provider.dart';
import 'fireBasePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<FitnessProvider>(context);
    var providerFalse = Provider.of<FitnessProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fitness Log App',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                providerFalse.readSearch('', '');
                              },
                              child: Container(
                                                        width: 100,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                                                        alignment: Alignment.center,
                                                        child: Text(
                              'All',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                                                        ),
                                                      ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                providerFalse.readSearch('', 'Cardio');
                              },
                              child: Container(
                                                        width: 100,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                                                        alignment: Alignment.center,
                                                        child: Text(
                              'Cardio',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                                                        ),
                                                      ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                providerFalse.readSearch('Strength', '');

                              },
                              child: Container(
                                                        width: 100,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                                                        alignment: Alignment.center,
                                                        child: Text(
                              'Strength',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                                                        ),
                                                      ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CloudPage(),));
                          },
                          child: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            alignment: Alignment.center,
                            child: Text(
                              'Online Backup',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            List<FitnessModal> data = providerTrue.fitnessList
                                .map(
                                  (e) => FitnessModal.fromMap(e),
                                )
                                .toList();
                            for (int i = 0; i < data.length; i++) {
                              providerFalse.addFitnessFireStore(data[i]);
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            alignment: Alignment.center,
                            child: Text(
                              'Sync Workouts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Center(
                child: Text(
              'All Fitness Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            Divider(),
            FutureBuilder(
                future: providerFalse.readDataFromDatabase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  providerTrue.fitnessModal = providerTrue.fitnessList
                      .map(
                        (e) => FitnessModal.fromMap(e),
                      )
                      .toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: providerTrue.fitnessModal.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BottomSheet(onClosing: () {
                              }, builder: (context) => Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(onPressed: () {
                                      providerFalse.deleteFitnessInDatabase(
                                          providerTrue.fitnessModal[index].id);
                                      Navigator.pop(context);
                                    }, child: Text('Delete')),
                                    TextButton(onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        providerTrue.workoutName=TextEditingController(text: providerTrue.fitnessModal[index].workoutName);
                                        providerTrue.workoutType=TextEditingController(text: providerTrue.fitnessModal[index].type);
                                        providerTrue.workoutDuration=TextEditingController(text: providerTrue.fitnessModal[index].duration);
                                        return AlertDialog(
                                          title: const Text('Update Workout'),
                                          content: Column(mainAxisSize: MainAxisSize.min, children: [
                                            TextField(
                                              controller: providerTrue.workoutName,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(20)),
                                                hintText: 'Enter Workout Name',
                                              ),
                                            ),
                                            SizedBox(                                              height: 10,
                                            ),
                                            TextField(
                                              controller: providerTrue.workoutType,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(20)),
                                                hintText: 'Enter Workout Type',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              controller: providerTrue.workoutDuration,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(20)),
                                                hintText: 'Enter Workout Duration',
                                              ),
                                            ),
                                          ]),
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: const Text('Update Workout'),
                                              onPressed: () {
                                                // update code local database
                                                DateTime dateTime = DateTime.now();
                                                providerTrue.date =
                                                '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                                                providerFalse
                                                    .updateFitnessInDatabase(
                                                  providerTrue
                                                      .fitnessModal[index].id,
                                                  providerTrue.workoutName.text,
                                                  providerTrue.workoutDuration.text,
                                                  providerTrue.date,
                                                  providerTrue.workoutType.text,
                                                );
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ), child: Text('Update'))
                                  ],
                                ),
                              ),);
                            },
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                              child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )),
                          title: Text(providerTrue.fitnessModal[index].workoutName
                              .toString()),
                          subtitle: Text(providerTrue.fitnessModal[index].type),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "${providerTrue.fitnessModal[index].duration} Min"),
                              Text(providerTrue.fitnessModal[index].date),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Workout'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    controller: providerTrue.workoutName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Enter Workout Name',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: providerTrue.workoutType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Enter Workout Type',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: providerTrue.workoutDuration,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Enter Workout Duration',
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TextField(
                  //   controller: providerTrue.workoutDate,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(20)),
                  //     hintText: 'Enter Workout Date',
                  //   ),
                  // ),
                ]),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Add Workout'),
                    onPressed: () {
                      providerTrue.id = providerTrue.fitnessList.length;
                      DateTime dateTime = DateTime.now();
                        providerTrue.date =
                            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                      providerFalse.addFitnessDatabase(
                        providerTrue.id,
                        providerTrue.workoutName.text,
                        providerTrue.workoutDuration.text,
                        providerTrue.date,
                        providerTrue.workoutType.text,
                      );
                      providerFalse.clearAllVar();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

