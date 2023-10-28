import 'package:anotei/stores/filters_store.dart';
import 'package:anotei/stores/markets_store.dart';
import 'package:anotei/stores/products_store.dart';
import 'package:anotei/widgets/filter_button.dart';
import 'package:anotei/widgets/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productsStore = Modular.get<ProductsStore>();
  final _filtersStore = Modular.get<FiltersStore>();
  final _marketsStore = Modular.get<MarketsStore>();

  @override
  void initState() {
    super.initState();
    _productsStore.fetchProducts();
    _marketsStore.fetchMarkets();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Anotei'),
          ),
          actions: const [
            CustomPopUpMenu(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _productsStore.fetchProducts,
          child: const Icon(Icons.search),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Digite sua busca'),
                      onChanged: _filtersStore.updateSearch,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const FilterButton(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _productsStore.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = _productsStore.products[index];

                    return Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const Spacer(),
                                Text(
                                  "R\$ ${product.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                              ],
                            ),
                            Text(_getProductMarketName(product.marketId)),
                            Image.network(product.picture),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }

  String _getProductMarketName(int marketId) {
    final market =
        _marketsStore.markets.firstWhere((market) => market.id == marketId);

    return market.name;
  }
}
