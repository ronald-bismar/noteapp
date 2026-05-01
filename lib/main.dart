import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'QuickNote App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String title = '';
  String content = '';
  String category = 'All';

  List<Note> notes = [];
  List<Categories> categories = [
    Categories(name: 'All', color: Colors.red, isSelected: true),
    Categories(name: 'Work', color: Colors.blue),
    Categories(name: 'Personal', color: Colors.green),
    Categories(name: 'Education', color: Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Category selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var cat in categories)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cat.isSelected ? Colors.grey : cat.color,
                      foregroundColor:
                          cat.isSelected ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        category = cat.name;
                        for (var c in categories) {
                          c.isSelected = c.name == cat.name;
                        }
                      });
                    },
                    child: Text(cat.name),
                  )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter the title',
                    ),
                    controller: titleController,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter the content',
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    controller: contentController,
                  ),
                ],
              ),
            ),

            // Save button
            ElevatedButton(
              onPressed: () {
                // Save the note
                setState(() {
                  notes.add(Note(
                    title: titleController.text,
                    content: contentController.text,
                    category: category,
                  ));
                });
                titleController.clear();
                contentController.clear();
                // reset of category to 'All'
                setState(() {
                  category = 'All';
                  for (var c in categories) {
                    c.isSelected = c.name == 'All';
                  }
                });
              },
              child: const Text('Save Note'),
            ),

            Expanded(
              child: notes.isEmpty
                  ? Center(child: Text('No notes yet.'))
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.content),
                          trailing: Text(note.category),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Note {
  String title;
  String content;
  String category;

  Note({
    required this.title,
    required this.content,
    required this.category,
  });
}

class Categories {
  String name;
  Color color;
  bool isSelected;

  Categories({
    required this.name,
    required this.color,
    this.isSelected = false,
  });
}
