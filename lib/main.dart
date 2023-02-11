// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables, missing_return, avoid_print, override_on_non_overriding_member, use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uas_pemrog/crud_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'CRUD demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  @override
  void iniState() {
    refreshCatatan();
    super.initState();
  }

  List<Map<String, dynamic>> catatan = [];
  void refreshCatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      catatan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(catatan);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: catatan.length,
          itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(catatan[index]['judul']),
                  subtitle: Text(catatan[index]['deskripsi']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => modalForm(catatan[index]["id"]),
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Void> tambahCatatan() async {
    await SQLHelper.tambahCatatan(
        judulController.text, deskripsiController.text);
    refreshCatatan();
  }

  Future<Void> ubahCatatan(int id) async {
    await SQLHelper.ubahCatatan(
        id, judulController.text, deskripsiController.text);
    refreshCatatan();
  }

  void modalForm(int id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((element) => element['id'] == id);
      judulController.text = dataCatatan['judul'];
      deskripsiController.text = dataCatatan['deskripsi'];
    }

    showBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(hintText: 'Judul'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: deskripsiController,
                      decoration: const InputDecoration(hintText: 'Deskripsi'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await tambahCatatan();
                          } else {
                            await ubahCatatan(id);
                          }
                          judulController.text = "";
                          deskripsiController.text = "";
                          Navigator.pop(context);
                        },
                        child: Text(id == null ? 'tambah' : 'ubah')),
                  ],
                ),
              ),
            ));
  }
}
