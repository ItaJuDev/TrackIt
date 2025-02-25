import 'dart:convert';
import 'dart:io';
import 'package:trackit/models/transaction.dart';

Future<void> onWriteJsonFile(Transaction newTransaction) async {
  final file =
      File('/Users/itaju/StudioProjects/TrackIt/assets/transaction.json');
  List<Transaction> transactions = [];

  // Check if file exists
  if (await file.exists()) {
    String jsonString = await file.readAsString();
    if (jsonString.isNotEmpty) {
      List<dynamic> jsonList = json.decode(jsonString);
      transactions =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
    }
  }

  // Add the new transaction to the list
  transactions.add(newTransaction);

  // Write updated list back to JSON file
  await file
      .writeAsString(json.encode(transactions.map((t) => t.toJson()).toList()));
}
