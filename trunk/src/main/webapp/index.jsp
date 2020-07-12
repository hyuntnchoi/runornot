<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뛸까 말까?</title>
</head>
<body>
    <div id="header">
        <h2></h2>
    </div>
    <div id="container">
        <div id="title"></div>
        <div id="infos"></div>
    </div>
    
    <script>
        const ERR_MSG = "열차의 운행이 종료되었거나 일시적 장애로 데이터를 불러오지 못했습니다.";
        const API_KEY = '646b55564768797535374a76614678';
        const byId = function(id) { return document.getElementById(id); }

        var getStation = function(xmlDoc) {
            var stationNm = xmlDoc.getElementsByTagName("statnNm")[0].childNodes[0].nodeValue;
            var rcvdDate = xmlDoc.getElementsByTagName("recptnDt")[0].childNodes[0].nodeValue;
            var rcvdTime = rcvdDate.substring(11, 19);
            return "<b><h3>" + stationNm + "역</h3></b>";
        };

        var getTime = function(xmlDoc) {
            var rcvdDate = xmlDoc.getElementsByTagName("recptnDt")[0].childNodes[0].nodeValue;
            var hh = rcvdDate.substring(11, 13);
            var mm = rcvdDate.substring(14, 16);
            return hh + "시" + mm + "분에 받은 정보입니다.";
        }

        var getBody = function(xmlDoc, i) {
            var trainLineNm = xmlDoc.getElementsByTagName("trainLineNm")[i].childNodes[0].nodeValue;
            var arvlMsg = xmlDoc.getElementsByTagName("arvlMsg2")[i].childNodes[0].nodeValue;
            var detailInfo = trainLineNm + " 도착 정보 : " + arvlMsg;
            return detailInfo;
        };

        // count result of the station but not using at the moment
        var resultCount = function(xml) {
            var xmlDoc = xml.responseXML;
            return xmlDoc.getElementsByTagName("total")[0].childNodes[0].nodeValue;
        };

        var getUrl = function(apiKey, stationNm) {
            var url = "http://swopenapi.seoul.go.kr/api/subway/" 
                      + apiKey + "/xml/realtimeStationArrival/0/5/" 
                      + stationNm;
            var encodedUrl = encodeURI(url);
            return encodedUrl;
        };
        
        var xml = new XMLHttpRequest();
        xml.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var xmlDoc = this.responseXML;
                // display station name and received time of the data
                byId("title").innerHTML = getStation(xmlDoc) + getTime(xmlDoc) + "<br><br>";

                // var rltCnt = resultCount(xml);

                // display each train's 5 infos at the station
                var i = 0;
                for(; i<5; i++) {
                    var eachInfo = getBody(xmlDoc, i);
                    byId("infos").innerHTML += "<div>"+eachInfo+"</div>";
                };
            } else {
                byId("title").innerHTML = ERR_MSG;
            }
        };

        var rqstUrl = getUrl(API_KEY, "부천");
        xml.open("GET", rqstUrl, true);
        xml.send();
    </script>
</body>
</html>