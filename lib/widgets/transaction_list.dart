import 'package:flutter/material.dart';
import 'package:my_app/models/transaction.dart';
import 'package:my_app/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function Function(String) onDelete;
  TransactionList(this.transactions, this.onDelete);
  @override
  Widget build(BuildContext context) {
    return this.transactions.isEmpty
        ? Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'No transactions added yet',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                transaction: this.transactions[index],
                onDelete: this.onDelete,
              );
            },
            itemCount: this.transactions.length,
          );
  }
}
