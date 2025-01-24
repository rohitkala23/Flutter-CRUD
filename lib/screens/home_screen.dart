import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transaction_management_ui/screens/create_transaction.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('https://transaction-management-system-beta.vercel.app/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _transactions = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch transactions")),
      );
    }
  }

  Future<void> deleteTransaction(String id) async {
    final url =
        Uri.parse('https://transaction-management-system-beta.vercel.app/');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode == 200) {
      fetchTransactions(); // Refresh transactions after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete transaction")),
      );
    }
  }

  void showUpdateOverlay(
      BuildContext context, Map<String, dynamic> transaction) {
    final TextEditingController nameController =
        TextEditingController(text: transaction["name"]);
    final TextEditingController amountController =
        TextEditingController(text: transaction["amount"].toString());
    String selectedType = transaction["transactionType"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Update Transaction",
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.black),
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ["DEBIT", "CREDIT"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color:
                                  type == "CREDIT" ? Colors.blue : Colors.red,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                  }
                },
                decoration:
                    const InputDecoration(labelText: "Transaction Type"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                updateTransaction(
                  transaction["_id"],
                  nameController.text,
                  int.parse(amountController.text),
                  selectedType,
                );
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateTransaction(
      String id, String name, int amount, String transactionType) async {
    final url =
        Uri.parse('https://transaction-management-system-beta.vercel.app/');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        "id": id,
        "name": name,
        "amount": amount,
        "transactionType": transactionType,
      }),
    );

    if (response.statusCode == 200) {
      fetchTransactions();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update transaction")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Transactions",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text(transaction["name"]),
                  subtitle: Text(
                    "${transaction["transactionType"]} - ${transaction["amount"]}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showUpdateOverlay(context, transaction);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteTransaction(transaction["_id"]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to CreateTransactionScreen
          final bool? created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateTransactionScreen(token: widget.token),
            ),
          );
          if (created == true) {
            // Refresh transactions after creating a new one
            fetchTransactions();
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
