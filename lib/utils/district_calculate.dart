import 'package:app/constant/shanghai_district.dart';

Map<Shanghai, int> districtHouseNum = {
  Shanghai.shangHai: 0,
  Shanghai.huangPu: 0,
  // Shanghai.luWan: 0,
  Shanghai.xuHui: 0,
  Shanghai.changNing: 0,
  Shanghai.jingAn: 0,
  Shanghai.puTuo: 0,
  // Shanghai.zhaBei: 0,
  Shanghai.hongKou: 0,
  Shanghai.yangPu: 0,
  Shanghai.minHang: 0,
  Shanghai.baoShan: 0,
  Shanghai.jiaDing: 0,
  Shanghai.puDong: 0,
  Shanghai.jinShan: 0,
  Shanghai.songJiang: 0,
  Shanghai.qingPu: 0,
  // Shanghai.nanHui: 0,
  Shanghai.fengXian: 0,
  Shanghai.chongMing: 0,
};

void resetDistrictHouseNumCalculation() {
  districtHouseNum.clear();
  districtHouseNum.addAll({
    Shanghai.shangHai: 0,
    Shanghai.huangPu: 0,
    // Shanghai.luWan: 0,
    Shanghai.xuHui: 0,
    Shanghai.changNing: 0,
    Shanghai.jingAn: 0,
    Shanghai.puTuo: 0,
    // Shanghai.zhaBei: 0,
    Shanghai.hongKou: 0,
    Shanghai.yangPu: 0,
    Shanghai.minHang: 0,
    Shanghai.baoShan: 0,
    Shanghai.jiaDing: 0,
    Shanghai.puDong: 0,
    Shanghai.jinShan: 0,
    Shanghai.songJiang: 0,
    Shanghai.qingPu: 0,
    // Shanghai.nanHui: 0,
    Shanghai.fengXian: 0,
    Shanghai.chongMing: 0,
  });
}

void _addOne(Shanghai dis) {
  districtHouseNum[dis] = districtHouseNum[dis]! + 1;
}

int? getHouseNumByDistrict(Shanghai dis) {
  if(dis == Shanghai.shangHai) {
    int total = 0;
    districtHouseNum.forEach((key, value) {
      total += value;
    });
    return total;
  } else {
    return districtHouseNum[dis];
  }
}


void addHouseByDistrictName(String district) {
  switch (district) {
    case "黄浦":
    case "黄浦区":
      _addOne(Shanghai.huangPu);
      break;
    // case "卢湾":
    //   _addOne(Shanghai.luWan);
    //   break;
    case "徐汇":
      _addOne(Shanghai.xuHui);
      break;
    case "长宁":
      _addOne(Shanghai.changNing);
      break;
    case "静安":
      _addOne(Shanghai.jingAn);
      break;
    case "普陀":
      _addOne(Shanghai.puTuo);
      break;
    // case "闸北":
    //   _addOne(Shanghai.zhaBei);
    //   break;
    case "虹口":
      _addOne(Shanghai.hongKou);
      break;
    case "杨浦":
      _addOne(Shanghai.yangPu);
      break;
    case "闵行":
      _addOne(Shanghai.minHang);
      break;
    case "宝山":
      _addOne(Shanghai.baoShan);
      break;
    case "嘉定":
      _addOne(Shanghai.jiaDing);
      break;
    case "浦东":
    case "浦东新区":
      _addOne(Shanghai.puDong);
      break;
    case "金山":
      _addOne(Shanghai.jinShan);
      break;
    case "松江":
      _addOne(Shanghai.songJiang);
      break;
    case "青浦":
      _addOne(Shanghai.qingPu);
      break;
    // case "南汇":
    //   _addOne(Shanghai.nanHui);
    //   break;
    case "奉贤":
      _addOne(Shanghai.fengXian);
      break;
    case "崇明":
      _addOne(Shanghai.chongMing);
      break;
    default:
      break;
  }
}
