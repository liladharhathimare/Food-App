import '../model/chinese_model.dart';

List<ChineseModel> getChinese(){
  List<ChineseModel>chinese=[];
ChineseModel chineseModel = new ChineseModel();

  chineseModel.name = "Chow Mein";
  chineseModel.image ="images/c1.jpg";
  chineseModel.price =  "79";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();

  chineseModel.name = "Congee";
  chineseModel.image ="images/c2.jpg";
  chineseModel.price =  "99";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();



  chineseModel.name = "Sichuan Cuisine";
  chineseModel.image ="images/c3.jpg";
  chineseModel.price =  "199";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();



  chineseModel.name = "Mapo Tofu";
  chineseModel.image ="images/c4.jpg";
  chineseModel.price =  "249";
  chinese.add(chineseModel);
  chineseModel = new ChineseModel();

  return chinese;
}