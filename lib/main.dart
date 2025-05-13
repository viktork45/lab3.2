import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Облік покупок',
      home: PurchaseList(),
    );
  }
}

class PurchaseList extends StatefulWidget {
  @override
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  List<Map<String, dynamic>> purchases = [];

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    final data = await DatabaseHelper.instance.getPurchases();
    setState(() {
      purchases = data;
    });
  }

  Future<void> _addExample() async {
    await DatabaseHelper.instance.addPurchase('Молоко', 2, 25.5);
    _loadPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Список покупок')),
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final item = purchases[index];
          return ListTile(
            title: Text('${item['item']} (x${item['quantity']})'),
            subtitle: Text('₴${item['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deletePurchase(item['id']);
                _loadPurchases();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExample,
        child: Icon(Icons.add),
      ),
    );
  }
}