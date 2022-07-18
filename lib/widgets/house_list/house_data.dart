//临时用来做demo的一些数据
import '../../routes/house_detail_page.dart';
import '../house_card.dart';

HouseDetail toDetail(String title, int rooms, double squares, String community,
    int price, String url, String latitude, String longitude, String location, String hid, String layout) {
  return HouseDetail(
    title: title,
    pricePerMonth: price,
    squares: squares,
    shiNumber: rooms,
    community: community,
    image: url,
    district: "上海",
    latitude: latitude,
    longitude: longitude,
    location: location,
    hid : hid,
    layout: layout,
  );
}
//
// final List<HouseCard> houseCardExample = <HouseCard>[
//   HouseCard(
//     houseDetail: toDetail(
//       "整租 | 城市经典高迪 2室2厅1卫 10500元月 108平",
//       2,
//       108,
//       "城市经典高迪",
//       10500,
//       "https://pic4.58cdn.com.cn/anjuke_58/036b1dd7f06f0091bea434be71b8eb3b?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "首次出租中央空调新风系统，带车位，南北三房，随时看",
//       3,
//       118,
//       "九龙仓兰廷",
//       9500,
//       "https://pic8.58cdn.com.cn/anjuke_58/e500e8d261816baca57a3a5257f145f5?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "整租 | 店长!仁恒河滨城(一期)好房出租,居住舒适,干净整洁",
//       3,
//       152.70,
//       "仁恒河滨城(一期)",
//       19000,
//       "https://pic4.58cdn.com.cn/anjuke_58/9295edd86d264357ecb4724954daee0d?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "真房！真价！东外滩 品质豪宅 电梯高层 采光老好 清爽三房",
//       3,
//       91,
//       " 保利香槟花园",
//       12300,
//       "https://pic4.58cdn.com.cn/anjuke_58/6ae32dc2ca10e439e7f0da84329d2bff?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "整租 | 现实太残酷，找套房子不容易，好房横空出世",
//       4,
//       252,
//       "静安枫景苑",
//       50000,
//       "https://pic8.58cdn.com.cn/anjuke_58/b5eaa682608a3411c0a1fa91125ff26e?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "复地新都国际，精装修三房，看房随时，拎包入住，近地铁，有车位",
//       3,
//       130,
//       "复地新都国际",
//       14000,
//       "https://pic4.58cdn.com.cn/anjuke_58/3b1153fa0ec5d392351fea30ade3111f?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "整租 | 百兴花园 3室2厅1卫 电梯房 106平 精装修拎",
//       3,
//       106,
//       "百兴花园",
//       9800,
//       "https://pic1.58cdn.com.cn/anjuke_58/9f58971ea7550e08648a0f6f64f4d941?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "西郊独栋别墅可会所办公居家，全新豪装 3个车位 业主急租",
//       5,
//       445.10,
//       "尚联西郊创世纪别墅",
//       43500,
//       "https://pic2.58cdn.com.cn/anjuke_58/96565e05456c262a0f3a1748189bb76f?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
//   HouseCard(
//     houseDetail: toDetail(
//       "（可看实房）丨翠湖御苑南北通两房丨二次装修丨全屋新风地暖",
//       2,
//       175.00,
//       " 翠湖天地御苑 ",
//       38000,
//       "https://pic5.58cdn.com.cn/anjuke_58/548979b260ca88cc397a4feded8517d3?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
//       "0",
//       "0",
//       "",
//     ),
//   ),
// ];
