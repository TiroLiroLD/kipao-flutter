import 'package:flutter/material.dart';
import 'package:kipao/models/market/catalog.dart';
import 'package:kipao/models/subscription/subscription_cart.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class SubscriptionCatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KipaoScaffold(body: CatalogPage());
  }
}

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _catalog = Provider.of<CatalogModel>(context, listen: false);

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
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
            onPressed: () => Navigator.pushNamed(context, '/subscriptionCart'),
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
    var item = context.select<CatalogModel, Item>(
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
              child: Text(
                item.name,
                style: textTheme,
              ),
            ),
            const SizedBox(width: 24),
            _DecreaseButton(item: item),
            _CartCount(item: item),
            _IncreaseButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _IncreaseButton extends StatelessWidget {
  final Item item;

  const _IncreaseButton({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*var count = context.select<SubscriptionCartModel, int?>(
      (cart) => cart.getCount(item),
    );
*/
    return TextButton(
      onPressed: () {
        var cart = context.read<SubscriptionCartModel>();
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
    var count = context.select<SubscriptionCartModel, int?>(
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
    var isInCart = context.select<SubscriptionCartModel, bool>(
      (cart) => cart.isInCart(item),
    );

    return TextButton(
      onPressed: () {
        var cart = context.read<SubscriptionCartModel>();
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

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline1!.copyWith(fontSize: 48);
    var cart = context.watch<SubscriptionCartModel>();

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Another way to listen to a model's change is to include
            // the Consumer widget. This widget will automatically listen
            // to SubscriptionCartModel and rerun its builder on every change.
            //
            // The important thing is that it will not rebuild
            // the rest of the widgets in this build method.
            Consumer<SubscriptionCartModel>(
                builder: (context, cart, child) =>
                    Text('\$${cart.totalPrice}', style: hugeStyle)),
            const SizedBox(width: 24),
            TextButton(
              onPressed: () {
                cart.placeOrder();
                //Todo: build request with selected items
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Pronto')));
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
