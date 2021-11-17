class Vendor_Model{
  String id,name,specialist,phone,email,description,deliver,ex_product,minmum_amount,holiday,mini_money,shop_i,start_time,closing_time,address1,jomla;

  Vendor_Model(
this.id,
      this.name,
      this.specialist,
      this.phone,
      this.email,
      this.description,
      this.deliver,
      this.ex_product,
      this.minmum_amount,
      this.holiday,
      this.mini_money,
      this.start_time,
      this.closing_time,
      this.shop_i,
      this.address1,
      this.jomla);
  Vendor_Model.fromjson(Map<String,dynamic> json){
    this.id=json['id'];
    this.name=json['name'];
    this.phone=json['about_phone1'];
    this.specialist=json['specialist'];
    this.email=json['email'];
    this.minmum_amount=json['minimum_order_amount'];
    this.holiday=json['holiday'];
    this.mini_money=json['mini_money'];
    this.description=json['description'];
    this.deliver=json['deliver'];
    this.shop_i=json['shop_i'];
    this.ex_product=json['ex_product'];
    this.start_time=json['opening_hour'];
    this.closing_time=json['closing_hour'];
    this.address1=json['address1'];
    this.jomla=json['jomla'];
  }

}