import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modal/fitness.dart';
import '../provider/provider.dart';

class CloudPage extends StatelessWidget {
  const CloudPage({super.key});

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
            StreamBuilder(
              stream: providerFalse.readDataFromFireStore(),
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

                var data = snapshot.data!.docs;
                List<FitnessModal> fitnessList = [];

                for (var i in data) {
                  fitnessList.add(
                    FitnessModal.fromMap(
                      i.data(),
                    ),
                  );
                  providerTrue.fitnessCloudList.add(
                    FitnessModal.fromMap(
                      i.data(),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(itemCount: fitnessList.length,itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                    title: Text(fitnessList[index].workoutName),
                    subtitle: Text(fitnessList[index].type),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(fitnessList[index].duration),
                        Text(fitnessList[index].date),
                      ],
                    ),
                  ),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
