import "dart:async";
import "dart:convert";
import "dart:io";
import "package:path_provider/path_provider.dart";
import "package:async/async.dart";
import "package:path/path.dart";
import "package:http/http.dart" as http;

import "http_client.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class PictureApiProvider {
  LoginManager loginManager = new LoginManager();

  Future<File> getPicture(String imageUrl) async {
    final jwt = await loginManager.getToken();

    var response = await globalHttpClient.get(
        "$baseUrlPicture/picture/$imageUrl",
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"});

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    return File("$tempPath/$imageUrl").writeAsBytes(response.bodyBytes);
  }

  Future<String> uploadPicture(File picture) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(picture.openRead()));
    var length = await picture.length();

    var token = await loginManager.getToken();

    var uri = Uri.parse("$baseUrlPicture/upload");
    var request = new http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = "Bearer $token";

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(picture.path));
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw response.statusCode;
    }

    Completer<String> completer = new Completer();
    var contents = new StringBuffer();
    response.stream.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}

final pictureApiProvider = PictureApiProvider();
