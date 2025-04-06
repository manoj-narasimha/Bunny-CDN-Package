// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:http/http.dart' as http;

class BunnyCDNClient {
  final String storageZoneRegion; // e.g. "sg" for Singapore or "ny" for New York
  final String storageZone;
  final String accessKey;
  late final String endpoint;

  BunnyCDNClient({required this.storageZone, required this.accessKey, this.storageZoneRegion = ""}) {
    endpoint = storageZoneRegion.isEmpty
        ? "https://storage.bunnycdn.com"
        : "https://$storageZoneRegion.storage.bunnycdn.com";
  }

  // Get the list of files in a storage zone
  Future<List<String>?> listFiles({String path = ""}) async {
    /*
    The directory path to your file. If this is the root of your storage zone, 
    you can ignore this parameter.
    */
    try {
      final url = Uri.parse("$endpoint/$storageZone/$path");
      final response = await http.get(
        url,
        headers: {
          "AccessKey": accessKey,
        },
      );

      if (response.statusCode == 200) {
        return List<String>.from(response.body.split('\n'));
      } else {
        print("Error listing files: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error listing files: $e");
      return null;
    }
  }
  
  // Upload a file to BunnyCDN
  Future<bool> uploadFile(String fileName, List<int> fileBytes, {String path = ""}) async {
    try {
      final url = Uri.parse("$endpoint/$storageZone/$path$fileName");
      final response = await http.put(
        url,
        headers: {
          "AccessKey": accessKey,
          "Content-Type": "application/octet-stream",
          "Accept": "application/json",
        },
        body: fileBytes,
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error uploading file: $e");
      return false;
    }
  }

  // Download a file from BunnyCDN
  Future<bool> downloadFile(String fileName, String savePath, {String path = ""}) async {
    /*
    The directory path to your file. If this is the root of your storage zone, 
    you can ignore this parameter.
    */
    try {
      final url = Uri.parse("$endpoint/$storageZone/$path$fileName");
      final response = await http.get(
        url,
        headers: {
          "AccessKey": accessKey,
        },
      );

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return true;
      } else {
        print("Error downloading file: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error downloading file: $e");
      return false;
    }
  }

  // Delete a file from BunnyCDN
  Future<bool> deleteFile(String fileName, {String path = ""}) async {
    try {
      final url = Uri.parse("$endpoint/$storageZone/$path$fileName");
      final response = await http.delete(
        url,
        headers: {
          "AccessKey": accessKey,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting file: $e");
      return false;
    }
  }
}

