class HousePageEntity {
  List<Content>? content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  HousePageEntity(
      {this.content,
        this.pageable,
        this.last,
        this.totalElements,
        this.totalPages,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first,
        this.empty});

  HousePageEntity.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
      data['pageable'] = this.pageable!.toJson();
    }
    data['last'] = this.last;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class Content {
  String? id;
  String? createTime;
  String? displaySource;
  String? displayRentType;
  String? icon;
  String? publishDate;
  String? pictures;
  String? title;
  String? location;
  String? longitude;
  String? latitude;
  int? rentType;
  String? onlineUrl;
  String? district;
  String? city;
  int? price;
  String? source;
  String? residential;
  double? squares;
  String? layout;
  int? shi;
  int? ting;
  int? wei;
  int? metroLine;
  String? metroStation;
  String? firstPicUrl;

  Content(
      {this.id,
        this.createTime,
        this.displaySource,
        this.displayRentType,
        this.icon,
        this.publishDate,
        this.pictures,
        this.title,
        this.location,
        this.longitude,
        this.latitude,
        this.rentType,
        this.onlineUrl,
        this.district,
        this.city,
        this.price,
        this.source,
        this.residential,
        this.squares,
        this.layout,
        this.shi,
        this.ting,
        this.wei,
        this.metroLine,
        this.metroStation,
        this.firstPicUrl});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    displaySource = json['displaySource'];
    displayRentType = json['displayRentType'];
    icon = json['icon'];
    publishDate = json['publishDate'];
    pictures = json['pictures'];
    title = json['title'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    rentType = json['rentType'];
    onlineUrl = json['onlineUrl'];
    district = json['district'];
    city = json['city'];
    price = json['price'];
    source = json['source'];
    residential = json['residential'];
    squares = json['squares'];
    layout = json['layout'];
    shi = json['shi'];
    ting = json['ting'];
    wei = json['wei'];
    metroLine = json['metroLine'];
    metroStation = json['metroStation'];
    firstPicUrl = json['firstPicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['displaySource'] = this.displaySource;
    data['displayRentType'] = this.displayRentType;
    data['icon'] = this.icon;
    data['publishDate'] = this.publishDate;
    data['pictures'] = this.pictures;
    data['title'] = this.title;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['rentType'] = this.rentType;
    data['onlineUrl'] = this.onlineUrl;
    data['district'] = this.district;
    data['city'] = this.city;
    data['price'] = this.price;
    data['source'] = this.source;
    data['residential'] = this.residential;
    data['squares'] = this.squares;
    data['layout'] = this.layout;
    data['shi'] = this.shi;
    data['ting'] = this.ting;
    data['wei'] = this.wei;
    data['metroLine'] = this.metroLine;
    data['metroStation'] = this.metroStation;
    data['firstPicUrl'] = this.firstPicUrl;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    data['empty'] = this.empty;
    return data;
  }
}