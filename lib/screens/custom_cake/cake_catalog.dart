import 'package:flutter/material.dart';
import 'package:kipao/models/custom_cake/cake_catalog.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:kipao/models/market/cart.dart';

class CakeCatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KipaoScaffold(body: CakeCatalog());
  }
}

class CakeCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _catalog = Provider.of<CakeCatalogModel>(context, listen: false);

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              //_MyAppBar(),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => _MyListItem(index),
                    childCount: _catalog.itemNames.length),
              ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            child: Text('Confirmar'))
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CakeCatalogModel, Item>(
      // Here, we are only interested in the item at [index]. We don't care
      // about any other change.
      (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: textTheme),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'R\$' + item.price.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            /*
            _DecreaseButton(item: item),
            _CartCount(item: item),
            _IncreaseButton(item: item),
            */
          ],
        ),
      ),
    );
  }
}
/*

class _IncreaseButton extends StatelessWidget {
  final Item item;

  const _IncreaseButton({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    */
/*var count = context.select<CartModel, int?>(
      (cart) => cart.getCount(item),
    );
*/ /*

    return TextButton(
      onPressed: () {
        var cart = context.read<CartModel>();
        cart.increase(item);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: const Text('+'),
    );
  }
}

class _CartCount extends StatelessWidget {
  final Item item;

  const _CartCount({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = context.select<CartModel, int?>(
      (cart) => cart.getCount(item),
    );

    return (count != null && count != 0)
        ? Text(count.toString())
        : SizedBox(width: 0, height: 0);
  }
}

class _DecreaseButton extends StatelessWidget {
  final Item item;

  const _DecreaseButton({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isInCart = context.select<CartModel, bool>(
      (cart) => cart.isInCart(item),
    );

    return TextButton(
      onPressed: () {
        var cart = context.read<CartModel>();
        cart.decrease(item);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInCart ? const Text('-') : SizedBox(width: 0, height: 0),
    );
  }
}
*/
