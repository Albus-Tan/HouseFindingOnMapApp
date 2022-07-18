import mysql.connector

station = [
    [],
    ["上海南站", "上海马戏城", "中山北路", "人民广场", "共富新村", "共康路", "呼兰路", "外环路", "宝安公路", "延长路", "彭浦新村", "汶水路", "通河新村", "锦江乐园"],
    ["世纪公园", "世纪大道", "东昌路", "中山公园", "北新泾", "威宁路", "川沙", "广兰路", "徐泾东", "淞虹路", "虹桥火车站"],
    ["中潭路", "大柏树", "宜山路", "宝山路", "宝杨路", "殷高西路", "江湾镇", "淞发路", "漕溪路", "长江南路", "龙漕路"],
    ["上海体育场", "临平路", "南浦大桥", "塘桥", "浦东大道", "浦电路", "海伦路", "蓝村路", "西藏南路", "鲁班路"],
]


def getonestation(i, s, flag):
    str = ""
    str += f'''
                    {{
                        "title": "{i}号线",
                        "key": "station",
                        "type": "radio",
                        "defaultValue": "",
                        "value": "{i}",
                        "children": [
                '''
    for j in range(len(s)):
        str += f'''
                        {{
                            "title": "{s[j]}",
                            "key": "{s[j]}",
                            "type": "checkbox",
                            "defaultValue": "",
                            "value": "{s[j]}"
                          }}'''
        if j < len(s) - 1:
            str += ",\n"
        else:
            str += "\n"
    str += f'''
                        ]
                    }}
                '''
    if flag:
        str += ",\n"
    else:
        str += "\n"
    return str


def getstations(s):
    str = ""
    str += '''
        {
                "title": "地铁",
                "key": "subway",
                "type": "radio",
                "defaultValue": "",
                "value": "",
                "children": ['''

    for i in range(1, len(s)):
        str += getonestation(i, list(s[i]), i < len(s) - 1)

    str += '''
                ]
        }
        '''
    return str


S = [set() for _ in range(19)]
try:
    connection = mysql.connector.connect(host='124.71.183.73',
                                         database='zlm',
                                         user='g2',
                                         password='SE2320')
    sql_select_Query = "select * from house"
    cursor = connection.cursor()
    cursor.execute(sql_select_Query)
    # get all records
    records = cursor.fetchall()
    print("Total number of rows in table: ", cursor.rowcount)

    print("\nPrinting each row")
    for row in records:
        # print("line = ", row[24])
        # print("station  = ", row[25], "\n")
        if row[24]>0:
            S[row[24]].add(row[25])

except mysql.connector.Error as e:
    print("Error reading data from MySQL table", e)
finally:
    if connection.is_connected():
        connection.close()
        cursor.close()
        print("MySQL connection is closed")

print(len(S))
json = getstations(S)
print(json)
