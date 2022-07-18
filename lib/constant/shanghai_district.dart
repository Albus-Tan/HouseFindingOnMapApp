enum Shanghai {
  shangHai,
  huangPu,
  // luWan,
  xuHui,
  changNing,
  jingAn,
  puTuo,
  // zhaBei,
  hongKou,
  yangPu,
  minHang,
  baoShan,
  jiaDing,
  puDong,
  jinShan,
  songJiang,
  qingPu,
  // nanHui,
  fengXian,
  chongMing,
}

class District {
  District(String name_, double lng_, double lat_) {
    name = name_;
    lat = lat_.toString();
    lng = lng_.toString();
  }

  late String name;
  late String lat;
  late String lng;
}

final Map<Shanghai, District> infoShanghaiDistrict = {
  Shanghai.shangHai: District('上海市', 121.47, 31.23),
  Shanghai.huangPu: District('黄浦区', 121.48, 31.23),
  // Shanghai.luWan: District('卢湾区', 121.47, 31.22),
  Shanghai.xuHui: District('徐汇区', 121.43, 31.18),
  Shanghai.changNing: District('长宁区', 121.42, 31.22),
  Shanghai.jingAn: District('静安区', 121.45, 31.23),
  Shanghai.puTuo: District('普陀区', 121.4, 31.25),
  // Shanghai.zhaBei: District('闸北区', 121.45, 31.25),
  Shanghai.hongKou: District('虹口区', 121.5, 31.27),
  Shanghai.yangPu: District('杨浦区', 121.52, 31.27),
  Shanghai.minHang: District('闵行区', 121.38, 31.12),
  Shanghai.baoShan: District('宝山区', 121.48, 31.4),
  Shanghai.jiaDing: District('嘉定区', 121.27, 31.38),
  Shanghai.puDong: District('浦东新区', 121.53, 31.22),
  Shanghai.jinShan: District('金山区', 121.33, 30.75),
  Shanghai.songJiang: District('松江区', 121.22, 31.03),
  Shanghai.qingPu: District('青浦区', 121.12, 31.15),
  // Shanghai.nanHui: District('南汇区', 121.75, 31.05),
  Shanghai.fengXian: District('奉贤区', 121.47, 30.92),
  Shanghai.chongMing: District('崇明县', 121.4, 31.62),
};

