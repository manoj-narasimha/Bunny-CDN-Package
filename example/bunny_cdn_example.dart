import 'package:bunny_cdn/bunny_cdn.dart';
import 'dart:io';

void main() async {
  final bunny = BunnyCDNClient(
    storageZone: "storage-zone",
    accessKey: "access-key",
    storageZoneRegion: "sg",
  );

  final file = File("path/to/example.png");
  print("File size: ${await file.length()} bytes");
  // list files in the root directory
  final myFiles = await bunny.listFiles(); // return a json list of files
  print("Files in storage zone: $myFiles");
  // list files in a specific directory
  final myFilesAt = await bunny.listFiles(path: "path/to/directory/");
  print("Files in storage zone: $myFilesAt"); // return a json list of files
  
  // upload a file to a specific directory
  final uploadedFile = await bunny.uploadFile("example.png", await file.readAsBytes(), path: "path/to/directory/");
  print("File uploaded: $uploadedFile"); // return true if uploaded
  
  // download a file to a specific directory
  final downloadMyFile = await bunny.downloadFile("example.png", "path/to/downloaded_example.png");
  print("File downloaded: $downloadMyFile"); // return true if downloaded
  
  // delete a file from the root directory or a specific directory
  final deleteMyFile = await bunny.deleteFile("example.png");
  print("File deleted: $deleteMyFile"); // return true if deleted

}

