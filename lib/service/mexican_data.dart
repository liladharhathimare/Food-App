import '../model/mexican_model.dart';

List<MexicanModel> getMexican(){
  List<MexicanModel>maxican=[];
  MexicanModel maxicanModel = new MexicanModel();

  maxicanModel.name = "Tacos";
 maxicanModel.image ="images/m1.jpg";
  maxicanModel.price =  "79";
  maxican.add(maxicanModel);
  maxicanModel = new MexicanModel();

  maxicanModel.name = " Burritos";
  maxicanModel.image ="images/m2.jpg";
  maxicanModel.price =  "99";
  maxican.add(maxicanModel);
  maxicanModel = new MexicanModel();

  maxicanModel.name = "Quesadillas";
  maxicanModel.image ="images/m3.jpg";
  maxicanModel.price =  "149";
  maxican.add(maxicanModel);
  maxicanModel = new MexicanModel();



  maxicanModel.name = "Enchiladas";
  maxicanModel.image ="images/m4.jpg";
  maxicanModel.price =  "249";
  maxican.add(maxicanModel);
  maxicanModel = new MexicanModel();

  return maxican;
}