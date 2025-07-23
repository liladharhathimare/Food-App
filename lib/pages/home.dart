import 'package:flutter/material.dart';
import 'package:foodappp/model/category_model.dart';
import 'package:foodappp/service/burger_data.dart';
import 'package:foodappp/service/chinese_data.dart';
import 'package:foodappp/service/mexican_data.dart';
import 'package:foodappp/service/pizza_data.dart';
import 'package:foodappp/service/widget_support.dart';

import '../model/burger_model.dart';
import '../model/chinese_model.dart';
import '../model/mexican_model.dart';
import '../model/pizza_model.dart';
import '../service/category_data.dart';
import 'detail_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizza = [];
  List<BurgerModel> burger = [];
  List<MexicanModel> mexican = [];
  List<ChineseModel> chinese = [];

  List<PizzaModel> filteredPizza = [];
  List<BurgerModel> filteredBurger = [];
  List<MexicanModel> filteredMexican = [];
  List<ChineseModel> filteredChinese = [];

  String track = "0";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    categories = getCategories();
    pizza = getPizza();
    burger = getBurger();
    mexican = getMexican();
    chinese = getChinese();

    filteredPizza = pizza;
    filteredBurger = burger;
    filteredMexican = mexican;
    filteredChinese = chinese;

    super.initState();
  }

  void filterSearch(String query) {
    if (track == "0") {
      setState(() {
        filteredPizza = pizza
            .where((item) =>
            item.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else if (track == "1") {
      setState(() {
        filteredBurger = burger
            .where((item) =>
            item.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else if (track == "2") {
      setState(() {
        filteredMexican = mexican
            .where((item) =>
            item.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else if (track == "3") {
      setState(() {
        filteredChinese = chinese
            .where((item) =>
            item.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 40.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("images/logo.png",
                      height: 50, width: 110, fit: BoxFit.contain),
                  Text(
                    "Order your favourites food!",
                    style: AppWidget.SimpleTextFeildStyle(),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "images/boy1.jpg",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ]),
            const SizedBox(height: 30.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => filterSearch(value),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search food item...",
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30.0,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    categories[index].name!,
                    categories[index].image!,
                    index.toString(),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(child: buildFoodGrid()),
          ],
        ),
      ),
    );
  }

  Widget buildFoodGrid() {
    List items = [];
    if (track == "0") items = filteredPizza;
    if (track == "1") items = filteredBurger;
    if (track == "2") items = filteredMexican;
    if (track == "3") items = filteredChinese;

    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.69,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 15.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return FoodTile(item.name!, item.image!, item.price!);
        },
      ),
    );
  }

  Widget FoodTile(String name, String image, String price) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
          Text(name, style: AppWidget.boldTextFeildStyle()),
          Text("₹$price", style: AppWidget.priceTextFeildStyle()),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        image: image,
                        name: name,
                        price: price,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget CategoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        track = categoryindex;
        searchController.clear();
        filterSearch('');
        setState(() {});
      },
      child: track == categoryindex
          ? Container(
        margin: const EdgeInsets.only(right: 20.0, bottom: 10.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: const Color(0xffef2b39),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Image.asset(image, width: 40, height: 40, fit: BoxFit.cover),
                const SizedBox(width: 10.0),
                Text(name, style: AppWidget.WhiteTextFeildStyle()),
              ],
            ),
          ),
        ),
      )
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: const EdgeInsets.only(right: 20.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFececf8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(image, width: 40, height: 40, fit: BoxFit.cover),
            const SizedBox(width: 10.0),
            Text(name, style: AppWidget.SimpleTextFeildStyle()),
          ],
        ),
      ),
    );
  }
}
