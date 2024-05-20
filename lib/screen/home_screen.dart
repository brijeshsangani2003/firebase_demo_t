import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dataOfBirth = TextEditingController();

  DateFormat dateFormat = DateFormat("dd-MM-YYYY");

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot? lastDocument;
  List<Map<String, dynamic>> list = [];
  bool isMoreData = true;

  bool isLoadingData = false;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    paginatedData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        paginatedData();
      }
    });
  }

  void paginatedData() async {
    if (isMoreData) {
      setState(() {
        isLoadingData = true;
      });
      final collectionReference = _fireStore.collection('user');

      late QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (lastDocument == null) {
        querySnapshot = await collectionReference.limit(10).get();
      } else {
        querySnapshot = await collectionReference
            .limit(10)
            .startAfterDocument(lastDocument!)
            .get();
      }
      lastDocument = querySnapshot.docs.last;

      list.addAll(querySnapshot.docs.map((e) => e.data()));
      print('All Data length ===> ${list.length}');

      isLoadingData = false;
      setState(() {});

      if (querySnapshot.docs.length < 10) {
        isMoreData = false;
      }
    } else {
      print('No More Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              print("object");
              return Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Users Data',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      // itemCount: snapshot.data?.docs.length,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Name:-',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                        // snapshot.data?.docs[index].get('name'),
                                        list[index]['name']),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Email:-',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      // snapshot.data?.docs[index].get('email'),
                                      list[index]['email'],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Date of birth:-',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      // snapshot.data?.docs[index]
                                      //     .get('date of birth'),
                                      list[index]['date of birth'],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          name.text = list[index]['name'];
                                          email.text = list[index]['email'];
                                          dataOfBirth.text =
                                              list[index]['date of birth'];
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 30),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      'Update Users',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    TextFormField(
                                                      controller: name,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText: 'Name'),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    TextFormField(
                                                      controller: email,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Email'),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    TextFormField(
                                                      onTap: () async {
                                                        var pickedDate =
                                                            await DatePicker
                                                                .showSimpleDatePicker(
                                                          context,
                                                          initialDate:
                                                              DateTime(1994),
                                                          firstDate:
                                                              DateTime(1960),
                                                          lastDate:
                                                              DateTime(2012),
                                                          dateFormat:
                                                              "dd-MMMM-yyyy",
                                                          locale:
                                                              DateTimePickerLocale
                                                                  .en_us,
                                                          looping: true,
                                                        );
                                                        if (pickedDate !=
                                                            null) {
                                                          dataOfBirth
                                                              .text = DateFormat(
                                                                  'dd/MMMM/yyyy')
                                                              .format(
                                                                  pickedDate);
                                                        }
                                                      },
                                                      controller: dataOfBirth,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Date of birth'),
                                                    ),
                                                    const SizedBox(height: 35),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'user')
                                                                .doc(snapshot
                                                                    .data
                                                                    ?.docs[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'name': name.text,
                                                              'email':
                                                                  email.text,
                                                              'date of birth':
                                                                  dataOfBirth
                                                                      .text,
                                                            });
                                                            setState(() {});

                                                            Navigator.pop(
                                                                context);
                                                            //QuerySnapshot ફાયરસ્ટોર ડેટાબેઝ પર ક્વેરીનાં પરિણામનો સ્નેપશોટ રજૂ કરે છે.
                                                            QuerySnapshot
                                                                querySnapshot =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .get();
                                                            list = querySnapshot
                                                                .docs
                                                                .map((e) => e
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>)
                                                                .toList();
                                                            print(list.length);

                                                            name.clear();
                                                            email.clear();
                                                            dataOfBirth.clear();
                                                          },
                                                          child: const Text(
                                                            'Update',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 17),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text("Are you sure?"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user')
                                                              .doc(snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                                  .id)
                                                              .delete();
                                                          setState(() {});

                                                          Navigator.pop(
                                                              context);
                                                          QuerySnapshot
                                                              querySnapshot =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .get();
                                                          list = querySnapshot
                                                              .docs
                                                              .map((e) => e
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)
                                                              .toList();
                                                          print(list.length);
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  isLoadingData
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Users',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: name,
                      decoration: const InputDecoration(hintText: 'Name'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onTap: () async {
                        var pickedDate = await DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime(1994),
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2012),
                          dateFormat: "dd-MMMM-yyyy",
                          locale: DateTimePickerLocale.en_us,
                          looping: true,
                        );
                        if (pickedDate != null) {
                          dataOfBirth.text =
                              DateFormat('dd/MMMM/yyyy').format(pickedDate);
                        }
                      },
                      controller: dataOfBirth,
                      decoration:
                          const InputDecoration(hintText: 'Date of birth'),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('user')
                                .add({
                              'name': name.text,
                              'email': email.text,
                              'date of birth': dataOfBirth.text,
                            });
                            Navigator.pop(context);
                            name.clear();
                            email.clear();
                            dataOfBirth.clear();
                            QuerySnapshot querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('user')
                                    .get();
                            list = querySnapshot.docs
                                .map((e) => e.data() as Map<String, dynamic>)
                                .toList();
                            print(list.length);
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
