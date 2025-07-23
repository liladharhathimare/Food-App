

import '../model/pizza_model.dart';

List<PizzaModel> getPizza(){
  List<PizzaModel>pizza=[];
  PizzaModel pizzaModel = new PizzaModel();

  pizzaModel.name = "Cheese Pizza";
  pizzaModel.image ="images/pizza1.png";
  pizzaModel.price =  "99";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  pizzaModel.name = "Margherita Pizza";
  pizzaModel.image ="images/veggie.jpg";
  pizzaModel.price =  "159";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  pizzaModel.name = "Corn Pizza";
  pizzaModel.image ="images/pizza3.png";
  pizzaModel.price =  "49";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();

  pizzaModel.name = "Pepperoni Pizza";
  pizzaModel.image ="images/pizza4.png";
  pizzaModel.price =  "199";
  pizza.add(pizzaModel);
  pizzaModel = new PizzaModel();




  return pizza;
}