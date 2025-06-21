import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_socket_channel/io.dart';

class FileUploader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: UploadPage());
  }
}

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final String esp32IP = '192.168.218.116'; // ← replace with ESP32 IP
  IOWebSocketChannel? channel;
  bool uploading = false;

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    File file = File(result.files.single.path!);
    String fileName = result.files.single.name;
    Uint8List fileBytes = await file.readAsBytes();

    channel = IOWebSocketChannel.connect('ws://$esp32IP/ws');
    channel!.sink.add('UPLOAD_START:$fileName');

    setState(() => uploading = true);

    const int chunkSize = 1024;
    for (int offset = 0; offset < fileBytes.length; offset += chunkSize) {
      int end = (offset + chunkSize > fileBytes.length)
          ? fileBytes.length
          : offset + chunkSize;
      channel!.sink.add(fileBytes.sublist(offset, end));
      await Future.delayed(Duration(milliseconds: 10)); // prevent overloading

      log('Uploading chunk ${offset ~/ chunkSize + 1} of ${fileBytes.length ~/ chunkSize + 1}');
    }

    channel!.sink.add('UPLOAD_END');
    channel!.sink.close();
    setState(() => uploading = false);
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ESP32 WebSocket Upload')),
      body: Center(
        child: uploading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: uploadFile,
                child: Text('Pick and Upload File'),
              ),
      ),
    );
  }
}
