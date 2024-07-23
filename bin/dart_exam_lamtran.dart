import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:mustache_template/mustache.dart';
import 'package:shelf_router/shelf_router.dart';
import '../class/order.dart';

Future<List<dynamic>> readJsonFile() async {
  final file = File('class/order.json');
  if (await file.exists()) {
    final jsonString = await file.readAsString();
    return jsonDecode(jsonString);
  } else {
    return [];
  }
}

// Ghi dữ liệu vào file JSON
Future<void> writeJsonFile(List<dynamic> data) async {
  final file = File('class/order.json');
  final jsonString = jsonEncode(data);
  await file.writeAsString(jsonString);
}

Future<Response> handleHome(Request request) async {
  final jsonList = await readJsonFile();    
  
  var templateSource = File('templates/index.html').readAsStringSync();
  var template = Template(templateSource, name: 'index.html');
  var output = template.renderString({'orders': jsonList});

  return Response.ok(output, headers: {'Content-Type': 'text/html'});
}

Future<Response> handleAdd(Request request) async {
  var content = await request.readAsString();
  var data = Uri.splitQueryString(content);
  var jsonFileData = await readJsonFile();
  jsonFileData.add(data);
  await writeJsonFile(jsonFileData);

  var templateSource = File('templates/add.html').readAsStringSync();
  var template = Template(templateSource, name: 'add.html');
  var output = template.renderString({});
  return Response.ok(output, headers: {'Content-Type': 'text/html'});
}

Future<Response> handleSearch(Request request) async {
  var content = await request.readAsString();
  var data = Uri.splitQueryString(content);
  var keyword = data['keyword'];
  var jsonFileData = await readJsonFile();
  var result = jsonFileData.where((order) => order['ItemName'].contains(keyword));
  var templateSource = File('templates/search.html').readAsStringSync();
  var template = Template(templateSource, name: 'search.html');
  var output = template.renderString({'result': result});
  return Response.ok(output, headers: {'Content-Type': 'text/html'});
}

Router appRouter() {
  var router = Router();

  router.get('/', handleHome);
  router.post('/add', handleAdd);
  router.post('/search', handleSearch);

  return router;
}

void main(List<String> args) async {
  
  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(appRouter().call);

  var server = await io.serve(handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
