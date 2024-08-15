
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // 저장소 권한 요청
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    // 권한이 부여되지 않은 경우 요청
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  } else {
    print("Storage permission already granted");
  }
}