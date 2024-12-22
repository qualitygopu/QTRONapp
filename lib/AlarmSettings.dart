import 'dart:convert';
import 'dart:io';
import 'package:qtronapp/AudioConfig.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

AudioConfig audioConfig = AudioConfig();

// List<List<FileData>> selectedAudio = List.generate(24, (_) => []);
List<FileData>? _filedata;

int timeSelIndex = 5;

List<String> _time = [
  '12 AM',
  '1 AM',
  '2 AM',
  '3 AM',
  '4 AM',
  '5 AM',
  '6 AM',
  '7 AM',
  '8 AM',
  '9 AM',
  '10 AM',
  '11 AM',
  '12 PM',
  '1 PM',
  '2 PM',
  '3 PM',
  '4 PM',
  '5 PM',
  '6 PM',
  '7 PM',
  '8 PM',
  '9 PM',
  '10 PM',
  '11 PM'
];

class AlarmSetting extends StatefulWidget {
  const AlarmSetting({super.key});

  @override
  State<AlarmSetting> createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  bool loadingData = false;
  Future<void> loaddata() async {
    final response = await http.get(Uri.parse(
        // 'http://192.168.4.1/alarmconf'));
        // 'http://fileserver.local/alarmconf'));
        'https://raw.githubusercontent.com/qualitygopu/files/main/files.json'));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> set = json.decode(response.body);
      audioConfig = AudioConfig.fromJson(set);
      // fi = List.generate(24, (_) => fetchString(set['AudioMaster']));
      _filedata = fetchString(set["AudioMaster"]);
    }
  }

  Future<void> uploadConfig() async {
    // String url = 'https://qtr.requestcatcher.com/test';
    String url = 'http://192.168.4.1/updateconfig';
    Map<dynamic, dynamic> jsonList = audioConfig.toJson();
    var jsonString = json.encode(jsonList);

    await http
        .post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: jsonString)
        .then((response) {
      print("${response.statusCode}");
      print("${response.body}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 210);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alarm Setting"),
          actions: [
            IconButton(
                onPressed: () async {
                  setState(() {
                    uploadConfig();
                  });
                },
                icon: Icon(Icons.upload)),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.download),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Download Settings"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.upload),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Upload Settings"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Audio Settings"),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (val) {
                if (val == 0) {
                } else if (val == 1) {
                } else if (val == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AudioSetting()),
                  );
                }
              },
            )
          ],
        ),
        body: audioConfig.audioMaster == null
            ? Container(
                child: Center(
                  child: loadingData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : TextButton.icon(
                          onPressed: () async {
                            loadingData = true;
                            setState(() {});
                            await loaddata();
                            setState(() {});
                            loadingData = false;
                          },
                          icon: Icon(Icons.refresh),
                          label: Text("Sync Settings"),
                        ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: _time.length,
                        itemBuilder: (context, int) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  boxShadow: timeSelIndex == int ?
                                  [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                    ),
                                  ] : [],
                                  shape: BoxShape.circle,
                                  color:
                                      audioConfig.playList![int].isPlay == true
                                          ? Colors.orange
                                          : Colors.grey),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                title: Text(
                                  _time[int].split(" ")[0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  _time[int].split(" ")[1],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    timeSelIndex = int;
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  hour(timeSelIndex),
                ],
              )
        // ListView(
        //   children: [
        //     for(int t=0; t<24; t++)
        //     hour(t),]
        // ),
        );
  }

  Widget hour(int time) {
    bool sw = audioConfig.playList![time].isPlay == true ? true : false;
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ToggleSwitch(
                  minWidth: 50.0,
                  minHeight: 40,
                  initialLabelIndex:
                      audioConfig.playList![time].isPlay == true ? 1 : 0,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: ['OFF', 'ON'],
                  activeBgColors: [
                    [Colors.pink],
                    [Colors.green]
                  ],
                  onToggle: (index) {
                    print("index $index");
                    sw = index == 1 ? true : false;
                    audioConfig.playList![time].isPlay = sw;
                  },
                ),
                Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final FileData result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog(
                            tim: time,
                          ); // Custom dialog with ListView
                        },
                      );
                      setState(() {
                        audioConfig.playList![time].fileData!.add(result);
                        // selectedAudio[time].add(result);
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent),
                    ),
                    label: Text(
                      "Add Audio ",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            )),
        Container(
          height: 500,
          child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onReorder: (oldIndex, newIndex) => {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final FileData item = audioConfig
                          .playList![time].fileData!
                          .removeAt(oldIndex);
                      audioConfig.playList![time].fileData!
                          .insert(newIndex, item);
                    })
                  },
              itemCount: audioConfig.playList![time].fileData!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  key: ValueKey('$index'),
                  onTap: () => {setState(() {})},
                  leading: Icon(Icons.audio_file, color: Colors.blueAccent),
                  title: Text(
                    audioConfig.playList![time].fileData![index].data[0]
                        .toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text("Folder : "),
                      ),
                      SizedBox(
                          width: 40,
                          child: Text(audioConfig
                              .playList![time].fileData![index].types)),
                      Text("Files : "),
                      Text(audioConfig.playList![time].fileData![index].data[1]
                          .toString()),
                    ],
                  ),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
// list tile  delete button
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  audioConfig.playList![time].fileData!
                                      .removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete)),
                          const Icon(Icons.reorder_sharp),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class MyDialog extends StatelessWidget {
  final int tim;
  MyDialog({required this.tim});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0.0,
      // backgroundColor: Color.fromARGB(255, 255, 255, 255),
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 580,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  _filedata!.length, // Change this to your desired list size
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: ListTile(
                    enabled: audioConfig.playList![tim].fileData!
                            .any((e) => e.types == _filedata![index].types)
                        ? false
                        : true,
                    onTap: () {
                      Navigator.of(context)
                          .pop(_filedata![index]); // Close the dialog
                    },
                    leading: Icon(
                      Icons.audio_file,
                    ),
                    title: Text(
                      _filedata![index].data[0].toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(100, 40)),
                // backgroundColor:
                //     MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)))),
          )
        ],
      ),
    );
  }
}

class AudioSetting extends StatefulWidget {
  const AudioSetting({super.key});

  @override
  State<AudioSetting> createState() => _AudioSettingState();
}

class _AudioSettingState extends State<AudioSetting> {
  TextEditingController _Song1contr = TextEditingController(text: "0");
  TextEditingController _Song2contr = TextEditingController(text: "0");
  TextEditingController _Song3contr = TextEditingController(text: "0");
  TextEditingController _Song4contr = TextEditingController(text: "0");
  TextEditingController _Song5contr = TextEditingController(text: "0");
  TextEditingController _Song6contr = TextEditingController(text: "0");
  TextEditingController _Song7contr = TextEditingController(text: "0");
  TextEditingController _Dwcontr = TextEditingController(text: "0");

  void initState() {
    _Song1contr.text = audioConfig.folderConfig![0].data[1].toString();
    _Song2contr.text = audioConfig.folderConfig![1].data[1].toString();
    _Song3contr.text = audioConfig.folderConfig![2].data[1].toString();
    _Song4contr.text = audioConfig.folderConfig![3].data[1].toString();
    _Song5contr.text = audioConfig.folderConfig![4].data[1].toString();
    _Song6contr.text = audioConfig.folderConfig![5].data[1].toString();
    _Song7contr.text = audioConfig.folderConfig![6].data[1].toString();
    _Dwcontr.text = audioConfig.folderConfig![7].data[1].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    "Folder",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "Count",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    "File Order",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            songSet(_Song1contr, audioConfig.folderConfig![0].types,
                audioConfig.folderConfig![0].data[1].toString()),
            songSet(_Song2contr, audioConfig.folderConfig![1].types,
                audioConfig.folderConfig![1].data[1].toString()),
            songSet(_Song3contr, audioConfig.folderConfig![2].types,
                audioConfig.folderConfig![2].data[1].toString()),
            songSet(_Song4contr, audioConfig.folderConfig![3].types,
                audioConfig.folderConfig![3].data[1].toString()),
            songSet(_Song5contr, audioConfig.folderConfig![4].types,
                audioConfig.folderConfig![4].data[1].toString()),
            songSet(_Song6contr, audioConfig.folderConfig![5].types,
                audioConfig.folderConfig![5].data[1].toString()),
            songSet(_Song7contr, audioConfig.folderConfig![6].types,
                audioConfig.folderConfig![6].data[1].toString()),
            songSet(_Dwcontr, audioConfig.folderConfig![7].types,
                audioConfig.folderConfig![7].data[1].toString()),
          ],
        ),
      ),
    );
  }

  Widget songSet(TextEditingController _cont, String fold, String count) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 80,
              child: Text(
                fold,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )),
          SizedBox(
              width: 80,
              child: Text(
                count,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )),
          SizedBox(
            width: 150,
            height: 50,
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              controller: _cont,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.content_copy_outlined),
                labelText: 'File Count',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.refresh,
          //       size: 30,
          //     ))
        ],
      ),
    );
  }
}
