import '/data/models/client_model.dart';
import '/data/repositories/client_repository.dart';
import '/ui/app_controllers/base_controller.dart';

// final class ClientController extends ChangeNotifier {
//   final ClientRepository clientRepository;
//
//   ClientController(this.clientRepository);
//
//   List<ClientModel> fullClients = [];
//   List<ClientModel> clients = [];
//   List<ClientModel> recentClients = [];
//   List recentClientsId = [];
//
//   Future getClients() async {
//     try {
//       var response = await clientRepository.getClients();
//       fullClients = response['data']
//           .map<ClientModel>((c) => ClientModel.fromMap(c))
//           .toList();
//       clients = [...fullClients];
//       getRecentClients();
//       notifyListeners();
//     } catch (e, s) {
//       log("GET CLIENTS CTRL", error: e.toString(), stackTrace: s);
//       rethrow;
//     }
//   }
//
//   void updateClientsBySearch(String text) async {
//     clients = [];
//     if (text.isNotEmpty) {
//       for (var client in fullClients) {
//         if (client.name.toUpperCase().contains(text.toUpperCase())) {
//           clients.add(client);
//         }
//       }
//     }
//     if (text.isEmpty) {
//       clients = [...fullClients];
//     }
//     notifyListeners();
//   }
//
//   Future saveClient(ClientModel client) async {
//     try {
//       return await clientRepository.saveClient(client);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future getClientCode(ClientModel client) async {
//     try {
//       var response = await clientRepository.getClientCode(client);
//       return response['code'];
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> addClientIdToRecent(int id) async {
//     recentClientsId.remove(id);
//     recentClientsId.insert(0, id);
//     if (recentClientsId.length > 5) {
//       recentClientsId = recentClientsId.sublist(0, 5);
//     }
//     await _saveRecentClientsIdOnStorage();
//     await getRecentClients();
//   }
//
//   Future<void> getRecentClients() async {
//     recentClients = [];
//     await _getRecentClientsIdOnStorage();
//     final clientsMap = {for (var client in fullClients) client.id: client};
//     for (var id in recentClientsId) {
//       final client = clientsMap[id];
//       if (client != null) {
//         recentClients.add(client);
//       }
//     }
//     notifyListeners();
//   }
//
//   Future<void> _saveRecentClientsIdOnStorage() async {
//     await clientRepository.saveRecentClientsId(recentClientsId);
//   }
//
//   Future<void> _getRecentClientsIdOnStorage() async {
//     recentClientsId = await clientRepository.getRecentClientsId();
//   }
// }

final class ClientController extends BaseController {
  final ClientRepository clientRepository;

  ClientController(
    this.clientRepository,
    //SessionController sessionController
  );
  //: super(sessionController);

  List<ClientModel> fullClients = [];
  List<ClientModel> clients = [];
  List<ClientModel> recentClients = [];
  List recentClientsId = [];

  Future<void> getClients() async {
    final response = await request(() => clientRepository.getClients());
    fullClients = (response['data'] as List)
        .map((c) => ClientModel.fromMap(c))
        .toList();
    clients = [...fullClients];
    getRecentClients();
    notifyListeners();
  }

  void updateClientsBySearch(String text) async {
    clients = [];
    if (text.isNotEmpty) {
      for (var client in fullClients) {
        if (client.name.toUpperCase().contains(text.toUpperCase())) {
          clients.add(client);
        }
      }
    }
    if (text.isEmpty) {
      clients = [...fullClients];
    }
    notifyListeners();
  }

  Future saveClient(ClientModel client) async {
    return await request(() => clientRepository.saveClient(client));
  }

  Future getClientCode(ClientModel client) async {
    var response = await request(() => clientRepository.getClientCode(client));
    return response['code'];
  }

  Future<void> addClientIdToRecent(int id) async {
    recentClientsId.remove(id);
    recentClientsId.insert(0, id);
    if (recentClientsId.length > 5) {
      recentClientsId = recentClientsId.sublist(0, 5);
    }
    await _saveRecentClientsIdOnStorage();
    await getRecentClients();
  }

  Future<void> getRecentClients() async {
    recentClients = [];
    await _getRecentClientsIdOnStorage();
    final clientsMap = {for (var client in fullClients) client.id: client};
    for (var id in recentClientsId) {
      final client = clientsMap[id];
      if (client != null) {
        recentClients.add(client);
      }
    }
    notifyListeners();
  }

  Future<void> _saveRecentClientsIdOnStorage() async {
    await clientRepository.saveRecentClientsId(recentClientsId);
  }

  Future<void> _getRecentClientsIdOnStorage() async {
    recentClientsId = await clientRepository.getRecentClientsId();
  }
}
