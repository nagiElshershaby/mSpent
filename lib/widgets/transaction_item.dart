import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({Key? key, required this.Transaction, required this.deleteTx, required this.i}) : super(key: key);
  final transaction Transaction;
  final Function deleteTx;
  final int i;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 178,
                    child: Card(
                      child: MaterialButton(
                        child: Transaction.galleryImage != null
                            ? Image.file(
                          Transaction.galleryImage!,
                          width: 200,
                          height: 200,
                        )
                            : Icon(
                          Icons.photo,
                          size: 50,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 130,
                  width: 240,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Transaction.name,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            '${Transaction.price.toStringAsFixed(2)} EGP',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'U bought ${Transaction.amount}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: const Alignment(0.9, -0.8),
              child: MaterialButton(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: (){},
                onLongPress: () {
                  deleteTx(i);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
