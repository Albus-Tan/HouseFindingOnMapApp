import 'package:flutter/material.dart';

class HouseImage {
  final Color color;
  final String image;
  final String title;

  HouseImage({
    required this.color,
    required this.image,
    required this.title,
  });
}

List houses = [
  HouseImage(
    color: const Color(0xFF86F3FB),
    image: "assets/house_detail_page_houses/house1.jpg",
    title: '1',
  ),
  HouseImage(
    color: const Color(0xFF7D6588),
    image: "assets/house_detail_page_houses/house2.jpg",
    title: '2',
  ),
  HouseImage(
    color: const Color(0xFF4C314D),
    image: "assets/house_detail_page_houses/house3.jpg",
    title: '3',
  ),
];

// void main() {
//   runApp(
//     MaterialApp(
//       title: "carousel",
//       home: Carousel(items: houses, height: 250),
//     )
//   );
// }

/*
* 绘制走马灯，需要提供 一个List，一个height
*  List中必须含有 'image'和 'title'
*  height为走马灯区域的高度
* */
Widget renderCarousel() {
  return Carousel(
    items: houses,
    height: 200,
  );
}

class Carousel extends StatefulWidget {
  final List items;
  final double height;

  const Carousel({
    Key? key,
    required this.items,
    required this.height,
  }) : super(key: key);

  @override
  createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _pageIndex = 0;
  late PageController _pageController;

  Widget _buildItem(activeIndex, index) {
    final items = widget.items;

    return Center(
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        height: activeIndex == index ? 500.0 : 450.0,
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: items[index].color,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              child: Image.asset(
                items[index].image,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        items[index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            pageSnapping: true,
            itemCount: houses.length,
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _pageIndex = index;
              });
            },
            itemBuilder: (BuildContext ctx, int index) {
              return _buildItem(_pageIndex, index);
            },
          ),
        ),
        PageIndicator(
          currentIndex: _pageIndex,
          pageCount: widget.items.length,
        ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;

  const PageIndicator({
    Key? key,
    required this.currentIndex,
    required this.pageCount,
  }) : super(key: key);

  Widget _indicator(bool isActive) {
    return Container(
      width: 6.0,
      height: 6.0,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff666a84) : const Color(0xffb9bcca),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 3.0),
            blurRadius: 3.0,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < pageCount; i++) {
      indicators.add(
        i == currentIndex ? _indicator(true) : _indicator(false),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildIndicators(),
    );
  }
}
