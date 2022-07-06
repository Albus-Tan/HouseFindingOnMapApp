import 'package:flutter/material.dart';

import 'house_list_page.dart';

class SearchBarViewDelegate extends SearchDelegate<String> {

  String searchHint = "请输入搜索内容...";

  /// 待搜索的所有条目
  var sourceList = [
    "汤臣一品",
    "上海交通大学西一区",
    "上海交通大学东区",
    "平安里",
    "东方明珠",
    "金茂大厦",
    "sousuo",
    "sss",
    "sobk",
    "haofangzi",
    "abcdef",
  ];

  /// 推荐的搜索条目
  var suggestList = ["汤臣一品", "上海交通大学"];

  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {
    ///显示在最右边的控件列表
    return [
      /// 清除按钮
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";

          ///搜索建议的内容
          showSuggestions(context);
        },
      ),

      /// 搜索按钮
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => query = "",
      )
    ];
  }

  ///左侧带动画的控件，此处是返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),

      ///调用 close 关闭 search 界面
      onPressed: () => close(context, ""),
    );
  }

  ///展示搜索结果
  @override
  Widget buildResults(BuildContext context) {
    List<String> result = [];

    ///模拟搜索过程
    for (var str in sourceList) {
      ///query 就是输入框的 TextEditingController
      if (query.isNotEmpty && str.contains(query)) {
        result.add(str);
      }
    }

    ///展示搜索结果
    // return ListView.builder(
    //   itemCount: result.length,
    //   itemBuilder: (BuildContext context, int index) => ListTile(
    //     title: Text(result[index]),
    //   ),
    // );
    return const HouseListPage(
      needAppBar: false,
    );
  }

  /// 搜索推荐下拉列表
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggest = query.isEmpty
        ? suggestList
        : sourceList.where((input) => input.startsWith(query)).toList();
    return query.isEmpty
        ? const SingleChildScrollView(
            child: SearchContentView(),
          )
        : ListView.builder(
            itemCount: suggest.length,
            itemBuilder: (BuildContext context, int index) => InkWell(
              child: ListTile(
                title: RichText(
                  key: Key(suggest[index]),
                  text: TextSpan(
                    text: suggest[index].substring(0, query.length),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: suggest[index].substring(query.length),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                query.replaceAll("", suggest[index].toString());
                searchHint = "";
                query = suggest[index].toString();
                showResults(context);
              },
            ),
          );
  }
}

class SearchContentView extends StatefulWidget {
  const SearchContentView({Key? key}) : super(key: key);

  @override
  createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '房源推荐',
            style: TextStyle(fontSize: 16),
          ),
          const SearchItemView(),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              '历史记录',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SearchItemView()
        ],
      ),
    );
  }
}

class SearchItemView extends StatefulWidget {
  const SearchItemView({Key? key}) : super(key: key);

  @override
  createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items = [
    "汤臣一品",
    "上海交通大学西一区",
    "上海交通大学东区",
    "平安里",
    'gradle',
    'Camera',
    '代码混淆 安全',
    '逆向加固'
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      // runSpacing: 0,
      children: items.map((item) {
        return SearchItem(title: item);
      }).toList(),
    );
  }
}

class SearchItem extends StatefulWidget {
  @required
  final String title;

  const SearchItem({Key? key, required this.title}) : super(key: key);

  @override
  createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Chip(
        label: Text(widget.title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () {
        debugPrint(widget.title);
      },
    );
  }
}
