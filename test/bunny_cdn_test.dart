import 'package:test/test.dart';
import 'package:bunny_cdn/bunny_cdn.dart';

void main() {
  test('BunnyCDNClient should initialize', () {
    final client = BunnyCDNClient(storageZone: "storage-zone", accessKey: "access-key", storageZoneRegion: "sg");
    expect(client.storageZone, equals("storage-zone"));
  });
}
