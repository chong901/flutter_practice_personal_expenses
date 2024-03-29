import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/transaction.dart';
import 'package:my_app/widgets/chart.dart';
import 'package:my_app/widgets/transaction_form.dart';
import 'package:my_app/widgets/transaction_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: 'test1',
    //   amount: 12.2,
    //   date: DateTime.now(),
    //   title: 'first transaction',
    // ),
    // Transaction(
    //   id: 'test2',
    //   amount: 14.2,
    //   date: DateTime.now().subtract(Duration(days: 1)),
    //   title: 'second transaction',
    // ),
  ];
  bool _isSwitchOn = false;

  void _addTransaction(
    String title,
    double amount,
    DateTime date,
  ) {
    print(title);
    this.setState(() {
      this._transactions.add(
            Transaction(
                amount: amount,
                title: title,
                date: date,
                id: 'test${this._transactions.length + 1}'),
          );
    });
  }

  void _showTransactionForm(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return TransactionForm(
          onSubmit: this._addTransaction,
        );
      },
    );
  }

  Function onDelete(String id) {
    return () {
      this.setState(() {
        this._transactions.removeWhere((tx) => tx.id == id);
      });
    };
  }

  List<Transaction> get _recentTransactions {
    final dayAfter = DateTime.now().subtract(Duration(days: 7));
    return this._transactions.where((tx) => tx.date.isAfter(dayAfter)).toList();
  }

  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    final ObstructingPreferredSizeWidget appBar = isIOS
        ? CupertinoNavigationBar(
            middle: Text('new app'),
            trailing: GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => this._showTransactionForm(context),
            ),
          )
        : AppBar(
            title: Text('new app'),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => this._showTransactionForm(context),
              )
            ],
          );
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final landScapePage = Column(
      children: <Widget>[
        Container(
          height: (mediaQuery.size.height - appBar.preferredSize.height) * .2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show chart',
                style: theme.textTheme.title,
              ),
              Switch.adaptive(
                value: this._isSwitchOn,
                activeColor: theme.accentColor,
                onChanged: (value) {
                  this.setState(() {
                    this._isSwitchOn = value;
                  });
                },
              ),
            ],
          ),
        ),
        Container(
          height: (mediaQuery.size.height - appBar.preferredSize.height) * .8,
          child: this._isSwitchOn
              ? Chart(this._recentTransactions)
              : TransactionList(this._transactions, this.onDelete),
        ),
      ],
    );
    final portraitPage = Column(
      children: <Widget>[
        Container(
            height: (mediaQuery.size.height - appBar.preferredSize.height) * .3,
            child: Chart(this._recentTransactions)),
        Container(
          height: (mediaQuery.size.height - appBar.preferredSize.height) * .7,
          child: TransactionList(this._transactions, this.onDelete),
        ),
      ],
    );
    final body = SafeArea(
      child: SingleChildScrollView(
        child: isLandScape ? landScapePage : portraitPage,
      ),
    );
    return isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isIOS
                ? null
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => this._showTransactionForm(context),
                  ),
          );
  }
}
