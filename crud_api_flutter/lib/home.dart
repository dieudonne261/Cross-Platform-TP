import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> user = {};
  String token = '';
  List contacts = [];
  String searchQuery = '';
  Map<String, dynamic> newContact = {
    'avatar': 'blue',
    'nom': '',
    'telephones': [{'numero': ''}]
  };
  bool editMode = false;
  Map<String, dynamic> currentContact = {};
  bool showNotification = false;
  String notificationMessage = '';
  String notificationType = 'success';

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchContacts();
  }

  Future<void> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    setState(() {
      this.token = token;
    });
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        user = jsonDecode(response.body);
      });
    }
  }

  Future<void> fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/contacts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        contacts = jsonDecode(response.body)['contacts'];
      });
    }
  }

  Future<void> addContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final contactData = {
      'avatar': 'blue',
      'nom': newContact['nom'],
      'telephones': newContact['telephones'].map((phone) => phone['numero']).toList()
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/contacts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(contactData),
    );

    if (response.statusCode == 201) {
      setState(() {
        contacts.add(jsonDecode(response.body));
        showNotificationMessage('Contact ajouté', 'success');
        newContact = {
          'avatar': 'blue',
          'nom': '',
          'telephones': [{'numero': ''}]
        };
      });
    } else {
      showNotificationMessage('Erreur lors de l\'ajout du contact', 'danger');
    }
  }

  Future<void> deleteContact(int contactId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/contacts/$contactId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        contacts.removeWhere((contact) => contact['id'] == contactId);
        showNotificationMessage('Contact supprimé', 'danger');
      });
    } else {
      showNotificationMessage('Erreur lors de la suppression du contact', 'danger');
    }
  }

  void prepareEditContact(Map<String, dynamic> contact) {
    setState(() {
      newContact = Map<String, dynamic>.from(contact);
      newContact['telephones'] = contact['telephones'].map((phone) => {'numero': phone['numero']}).toList();
      editMode = true;
      currentContact = contact;
    });
    showModalBottomSheet(
      context: context,
      builder: (_) => buildNewContactForm(),
    );
  }

  Future<void> updateContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final contactData = {
      'avatar': 'blue',
      'nom': newContact['nom'],
      'telephones': newContact['telephones'].map((phone) => phone['numero']).toList()
    };

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/contacts/${currentContact['id']}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(contactData),
    );

    if (response.statusCode == 200) {
      setState(() {
        final updatedContact = jsonDecode(response.body);
        final index = contacts.indexWhere((contact) => contact['id'] == currentContact['id']);
        if (index != -1) {
          contacts[index] = updatedContact;
        }
        showNotificationMessage('Contact modifié', 'success');
        editMode = false;
        currentContact = {};
        newContact = {
          'avatar': 'blue',
          'nom': '',
          'telephones': [{'numero': ''}]
        };
      });
    } else {
      showNotificationMessage('Erreur lors de la modification du contact', 'danger');
    }
  }

  void addPhoneField() {
    setState(() {
      newContact['telephones'].add({'numero': ''});
    });
  }

  void hideNotification() {
    setState(() {
      showNotification = false;
    });
  }

  void showNotificationMessage(String message, String type) {
    setState(() {
      notificationMessage = message;
      notificationType = type;
      showNotification = true;
    });
    Future.delayed(Duration(seconds: 5), hideNotification);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    await http.post(
      Uri.parse('http://127.0.0.1:8000/api/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Nom: ${user['name'] ?? ''}', style: TextStyle(fontSize: 18)),
              Text('Email: ${user['email'] ?? ''}', style: TextStyle(fontSize: 18)),
              Text('Token: $token', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    newContact = {
                      'avatar': 'blue',
                      'nom': '',
                      'telephones': [{'numero': ''}]
                    };
                    editMode = false;
                    currentContact = {};
                  });
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => buildNewContactForm(),
                  );
                },
                child: Text('Nouveau'),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Rechercher',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    if (searchQuery.isEmpty ||
                        contact['nom'].toLowerCase().contains(searchQuery.toLowerCase())) {
                      return ListTile(
                        title: Text(contact['nom']),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(contact['nom'][0]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => prepareEditContact(contact),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteContact(contact['id']),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              if (showNotification)
                Container(
                  padding: EdgeInsets.all(16),
                  color: notificationType == 'success' ? Colors.green : Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notificationMessage,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: hideNotification,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNewContactForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: TextEditingController(text: newContact['nom']),
            decoration: InputDecoration(
              labelText: 'Nom',
            ),
            onChanged: (value) {
              newContact['nom'] = value;
            },
          ),
          ...newContact['telephones'].map<Widget>((phone) {
            int index = newContact['telephones'].indexOf(phone);
            return TextField(
              controller: TextEditingController(text: phone['numero']),
              decoration: InputDecoration(
                labelText: 'Téléphone ${index + 1}',
              ),
              onChanged: (value) {
                newContact['telephones'][index]['numero'] = value;
              },
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: addPhoneField,
            child: Text('Ajouter un téléphone'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (editMode) {
                updateContact();
              } else {
                addContact();
              }
              Navigator.pop(context);
            },
            child: Text(editMode ? 'Modifier' : 'Ajouter'),
          ),
        ],
      ),
    );
  }
}