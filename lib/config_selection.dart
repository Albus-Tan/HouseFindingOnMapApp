//selection配置
const configSelect ='''
{
  "errno": 0,
  "data": {
    "list": [
      {
        "defaultValue": "",
        "key": "region",
        "type": "radio",
        "value": "region",
        "title": "地区",
        "children": [
          {
            "title": "区域",
            "key": "region",
            "type": "radio",
            "defaultValue": "2",
            "value": "",
            "children": [
              {
                "title": "全上海",
                "key": "town",
                "type": "unlimit",
                "defaultValue": "",
                "value": ""
              },
              {
                "title": "浦东",
                "key": "town",
                "type": "radio",
                "defaultValue": "",
                "value": "浦东",
                "children": [
                  {
                    "title": "全浦东",
                    "type": "unlimit",
                    "value": ""
                  },
                  {
                    "title": "八佰伴",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "八佰伴"
                  },
                  {
                    "title": "临港新城",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "临港新城"
                  },
                  {
                    "title": "张江",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "张江"
                  }
                ]
              },
              {
                "title": "闵行",
                "key": "town",
                "type": "radio",
                "defaultValue": "",
                "value": "浦东",
                "children": [
                  {
                    "title": "全闵行",
                    "type": "unlimit",
                    "value": ""
                  },
                  {
                    "title": "江川路",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "江川路"
                  },
                  {
                    "title": "老闵行",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "老闵行"
                  },
                  {
                    "title": "莘庄",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "莘庄"
                  }
                ]
              },
              {
                "title": "徐汇",
                "key": "town",
                "type": "radio",
                "defaultValue": "",
                "value": "徐汇",
                "children": [
                  {
                    "title": "全徐汇",
                    "type": "unlimit",
                    "value": ""
                  },
                  {
                    "title": "万体馆",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "万体馆"
                  },
                  {
                    "title": "徐汇滨江",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "徐汇滨江"
                  },
                  {
                    "title": "徐家汇",
                    "key": "",
                    "type": "checkbox",
                    "defaultValue": "",
                    "value": "徐家汇"
                  }
                ]
              }
            ]
          },
          {
            "title": "地铁",
            "key": "subway",
            "type": "radio",
            "defaultValue": "",
            "value": "",
            "children": [
              {
                "title": "1号线",
                "key": "1号线",
                "type": "radio",
                "defaultValue": "",
                "value": "1"
              },
              {
                "title": "2号线",
                "key": "2号线",
                "type": "radio",
                "defaultValue": "",
                "value": "2"
              },
              {
                "title": "3号线",
                "key": "3号线",
                "type": "radio",
                "defaultValue": "",
                "value": "3"
              },
              {
                "title": "4号线",
                "key": "4号线",
                "type": "radio",
                "defaultValue": "",
                "value": "4"
              },
              {
                "title": "5号线",
                "key": "5号线",
                "type": "radio",
                "defaultValue": "",
                "value": "5"
              },
              {
                "title": "6号线",
                "key": "6号线",
                "type": "radio",
                "defaultValue": "",
                "value": "6"
              },
              {
                "title": "7号线",
                "key": "7号线",
                "type": "radio",
                "defaultValue": "",
                "value": "7"
              },
              {
                "title": "8号线",
                "key": "8号线",
                "type": "radio",
                "defaultValue": "",
                "value": "8"
              },
              {
                "title": "9号线",
                "key": "9号线",
                "type": "radio",
                "defaultValue": "",
                "value": "9"
              }
            ]
          }
        ]
      },
      {
        "title": "租金",
        "key": "price",
        "type": "checkbox",
        "defaultValue": "",
        "value": "",
        "children": [
          {
            "title": "不限",
            "key": "",
            "type": "unlimit",
            "defaultValue": "",
            "value": "0"
          },
          {
            "title": "1500元以下",
            "key": "",
            "type": "radio",
            "defaultValue": "",
            "value": "1"
          },
          {
            "title": "1500-2000元",
            "key": "",
            "type": "radio",
            "defaultValue": "",
            "value": "2"
          },
          {
            "title": "2000-3000元",
            "key": "",
            "type": "radio",
            "defaultValue": "",
            "value": "3"
          },
          {
            "title": "3000-5000元",
            "key": "",
            "type": "radio",
            "defaultValue": "",
            "value": "4"
          },
          {
            "title": "5000-8000元",
            "key": "",
            "type": "radio",
            "defaultValue": "",
            "value": "5"
          },
          {
            "title": "8000元以上",
            "key": "",
            "type": "radio",
            "defaultValue": "",
            "value": "6"
          },
          {
            "defaultValue": "",
            "ext": {"min": 0, "max": 99999, "unit": "元"},
            "children": [],
            "key": "",
            "type": "range",
            "value": "",
            "title": "租金"
          }
        ]
      },
      {
        "defaultValue": "",
        "key": "room",
        "type": "checkbox",
        "value": "",
        "title": "居室",
        "children": [
          {
            "title": "户型",
            "key": "户型",
            "type": "radio",
            "defaultValue": "",
            "value": "",
            "children": [
              {
                "title": "不限",
                "key": "",
                "type": "unlimit",
                "defaultValue": "",
                "value": ""
              },
              {
                "title": "一室",
                "key": "",
                "type": "checkbox",
                "defaultValue": "",
                "value": "1"
              },
              {
                "title": "两室",
                "key": "",
                "type": "checkbox",
                "defaultValue": "",
                "value": "2"
              },
              {
                "title": "三室",
                "key": "",
                "type": "checkbox",
                "defaultValue": "",
                "value": "3"
              },
              {
                "title": "四室及以上",
                "key": "",
                "type": "checkbox",
                "defaultValue": "",
                "value": "4"
              }
            ]
          },
          {
            "title": "卧室",
            "key": "卧室",
            "type": "radio",
            "defaultValue": "",
            "value": "",
            "children": [
              {
                "title": "不限",
                "key": "",
                "type": "unlimit",
                "defaultValue": "",
                "value": ""
              },
              {
                "title": "主卧",
                "key": "",
                "type": "checkbox",
                "defaultValue": "",
                "value": "1"
              },
              {
                "title": "次卧",
                "key": "",
                "type": "checkbox",
                "defaultValue": "",
                "value": "2"
              }
            ]
          }
        ]
      }
    ]
  }
}
'''
;
