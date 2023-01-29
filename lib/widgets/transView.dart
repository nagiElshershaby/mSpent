// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mspent/widgets/transaction_item.dart';

import '../models/transaction.dart';

class transView extends StatefulWidget {
  const transView({Key? key, required this.transactions, required this.deleteTx}) : super(key: key);

  final List<transaction> transactions;
  final Function deleteTx;

  @override
  State<transView> createState() => _transViewState();
}

class _transViewState extends State<transView> {
  @override
  Widget build(BuildContext context) {
    return widget.transactions.length!= 0?
    ListView.builder(
        itemBuilder: (ctx, i) {
          return TransactionItem(Transaction: widget.transactions[i], deleteTx: widget.deleteTx, i: i);
        },
        itemCount: widget.transactions.length,
      ):LayoutBuilder(builder: (context,constraint){
        return Column(
          children: [
            SizedBox(height: constraint.maxHeight * 0.15,child: Text('No transactions added yet', style: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.secondary,),)),
            SizedBox(height: constraint.maxHeight *0.02,),
            SizedBox(
              height: constraint.maxHeight *0.7,
              child: Image.asset(
                'assets/images/waiting.png',
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
    });
  }
}
