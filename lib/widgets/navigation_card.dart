import 'package:flutter/material.dart';

class NavigationCard extends StatefulWidget {
  const NavigationCard({Key? key}) : super(key: key);

  @override
   createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
      minChildSize: 0.4,
      // 限制child最小高度, minChildSize必须 <= initialChildSize
      maxChildSize: 0.4,
      // 限制child最大高度,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.white,
                child: const NavigationForm(),
              ),
              Container(
                height: 200,
                color: Colors.white,
                child: const NavigationResultBar(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavigationResultBar extends StatelessWidget {
  const NavigationResultBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: <Widget>[
          //设置选项卡
          Material(
            //这里设置tab的背景色
            color: Colors.white,
            child: buildNavigationResultTabBar(),
          ),
          Expanded(
            flex: 1,
            child: buildNavigationResultTabBarView(), //设置选项卡对应的page
          )
        ],
      ),
    );
  }
}

buildNavigationResultTabBar() {
  return TabBar(
    unselectedLabelColor: Colors.redAccent,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Colors.redAccent,
          Colors.orangeAccent,
        ],
      ),
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(50),
    ),
    tabs: [
      Row(
        children: const [
          Icon(Icons.directions_car),
          SizedBox(width: 10),
          Text("驾车"),
        ],
      ),
      Row(
        children: const [
          Icon(Icons.directions_walk),
          SizedBox(width: 10),
          Text("步行"),
        ],
      ),
      Row(
        children: const [
          Icon(Icons.directions_bus),
          SizedBox(width: 10),
          Text("公交"),
        ],
      ),
      Row(
        children: const [
          Icon(Icons.directions_bike),
          SizedBox(width: 10),
          Text("骑行"),
        ],
      ),
    ],
  );
}

buildNavigationResultTabBarView() {
  return TabBarView(
    children: [
      ListView.builder(
        //controller: scrollController,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return buildNavigationResultCard();
        },
      ),
      ListView.builder(
        //controller: scrollController,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return buildNavigationResultCard();
        },
      ),
      ListView.builder(
        //controller: scrollController,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return buildNavigationResultCard();
        },
      ),
      ListView.builder(
        //controller: scrollController,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return buildNavigationResultCard();
        },
      ),
    ],
  );
}

buildNavigationResultCard() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      // 抗锯齿
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      child: Container(
        height: 80,
        alignment: Alignment.center,

        // 演示 ListTile
        child: const ListTile(
          title: Text("20分钟"),
          subtitle: Text("1003m"),

          // 列表尾部的图标
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    ),
  );
}

class NavigationForm extends StatelessWidget {
  const NavigationForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    TextFieldDemo(
                        labelText: '起始点',
                        hintText: '请输入出发地',
                        prefixIconColor: Colors.green),
                    TextFieldDemo(
                        labelText: '终止点',
                        hintText: '请输入目的地',
                        prefixIconColor: Colors.red),
                  ],
                ),
              ),
              Container(
                width: 100,
                alignment: Alignment.center,
                color: Colors.white70,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.near_me),
                  label: const Text("导航"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    //change background color of button
                    onPrimary: Colors.white,
                    //change text color of button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldDemo extends StatefulWidget {
  final String labelText;
  final String hintText;
  final MaterialColor prefixIconColor;

  const TextFieldDemo(
      {Key? key,
      this.labelText = '',
      this.hintText = '',
      this.prefixIconColor = Colors.grey})
      : super(key: key);

  @override
  createState() => _TextFieldDemoState();
// @override
// _TextFieldDemoState createState() => _TextFieldDemoState(labelText, hintText);
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.trip_origin,
            color: widget.prefixIconColor,
            size: 12,
          ),
          //图标
          labelText: widget.labelText,
          //题目
          hintText: widget.hintText,
          //提示文字
          border: InputBorder.none,
          //隐藏边框
          // border: OutlineInputBorder(),//有边框
          filled: true,
          //启用背景颜色边框，可用color属性设置颜色
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
