

import '../model/burger_model.dart';

List<BurgerModel> getBurger(){
  List<BurgerModel>burger=[];
  BurgerModel burgerModel = new BurgerModel();

  burgerModel.name = "Cheese Burger";
  burgerModel.image ="images/burger1.png";
  burgerModel.price =  "79";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  burgerModel.name = "veggie Burger";
  burgerModel.image ="images/burger2.png";
  burgerModel.price =  "99";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  burgerModel.name = "Patty Burger";
  burgerModel.image ="images/b1.jpg";
  burgerModel.price =  "119";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();

  burgerModel.name = "Veg Burger";
  burgerModel.image ="images/b2.jpg";
  burgerModel.price =  "179";
  burger.add(burgerModel);
  burgerModel = new BurgerModel();






  return burger;
}