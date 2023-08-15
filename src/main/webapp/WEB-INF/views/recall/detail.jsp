<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
    .main-nav{
        padding: 1rem;
        border-radius: 5px;
        display: flex; /*  종모양 위아래 가운데정렬 하기 */
        align-items: center; /* 수직 중앙 정렬 추가 */
        position: relative; /* 부모 요소에 position 설정 추가 */

    }
    .img-container {
        font-size: 20px;
        margin-left: auto; /* 이미지를 오른쪽으로 밀어내기 위해 추가 */
        position: absolute; /* 절대 위치 설정 */
        right: 15px;
        transform: translateY(-50%); /* 수직 가운데 정렬 */
    }
    .recall {
        width: 300px;
        height: 500px;
        background-color: white;
        border: 2px solid gray;
        border-radius:10px;
        text-align: center;
        display: none; /* 숨김 처리 */
        position: absolute; /* 위치 설정 */
        left: -275px;        
    }
    .img-container:hover .recall {
        display: block; /* 부모에 hover하면 자식을 보이게 함 */
        
    }
    p {
        /* 수평 중앙 정렬하기 */
        text-align: center;
        font-size: 15px;
    }
    .line {
        border: 1px solid gray;
        margin: 10px auto;
        width: 300px;        
    }
</style>
<body>
    <nav class="main-nav">
        <h1>고객 주문현황</h1>
        <div class="img-container">
            <img src="images/bell_icon.png" alt="bell_icon" width="30" height="30">
            <div class="recall">
                <p>신선도 알림</p>
                <div class="line"></div> <!-- 제목 밑 라인 추가-->
                    <!-- DB연결 데이터 설정 -->
                    <c:set var="jsonData">
                        [
                            <c:forEach var="item" items="${data}" varStatus="status">{
                                    "customerName": "${item.customer_name}",
                                    "freshnessLevel": ${item.freshness_level},
                                    "index": ${status.index}
                            }
                            <c:if test="${not status.last}">,</c:if>
                            </c:forEach>
                        ]
                    </c:set>
                    <!-- JSON 데이터를 기반으로 버튼 생성 -->
                    <c:forEach var="item" items="${jsonData}" varStatus="status">
                        <!-- <button onclick="handleButtonClicked(${status.index})"> -->
                        ${item.customer_name}님의 신선도가 70% 이하로 떨어졌습니다.<br>
                        현재 신선도는 ${item.freshness_level}% 입니다.
                        <br><br>
                    </c:forEach>
                </div>
            </div>
        </div>
    </nav>
    <div id="map" style="width:800px;height:500px;"></div>


    <script type="text/javascript" src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=d865c67a15044f7517639c54d9a0f65c"></script>
    <script> // 지도 기본값 
        var mapContainer = document.getElementById('map'),
            mapOption = {
                center: new kakao.maps.LatLng(37.5166572549305, 126.9830780329734),
                level: 8
            };

        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 마커 이벤트

        // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다 
        var positions = [
            {
                content: '<div style="padding:5px;">온도 : ${temperature1 }<br>습도 : ${humidity1}<br><button>리콜</button></div>', 
                latlng: new kakao.maps.LatLng(37.517236, 127.047324)
            },
            {
                content: '<div style="padding:5px;">온도 : ${temperature2 }<br>습도 : ${humidity2}<br><button>리콜</button></div>', 
                latlng: new kakao.maps.LatLng(37.516066, 127.019361)
            },
            {
                content: '<div style="padding:5px;">온도 : ${temperature3 }<br>습도 : ${humidity3}<br><button>리콜</button></div>', 
                latlng: new kakao.maps.LatLng(37.511293, 127.021324)
            },
            {
                content: '<div style="padding:5px;">온도 : ${temperature4 }<br>습도 : ${humidity4}<br><button>리콜</button></div>',
                latlng: new kakao.maps.LatLng(37.51098, 127.043593)
            }
        ];

        positions.push({
            content: '<div style="padding:5px;">온도 : ${temperature1 }<br>습도 : ${humidity1}<br><button>리콜</button></div>', 
            latlng: new kakao.maps.LatLng(37.478218, 126.952830)
        })
        positions.push({
            content: '<div style="padding:5px;">온도 : ${temperature1 }<br>습도 : ${humidity1}<br><button>리콜</button></div>', 
            latlng: new kakao.maps.LatLng(37.539950, 127.070591)
        })
        positions.push({
            content: '<div style="padding:5px;">온도 : ${temperature1 }<br>습도 : ${humidity1}<br><button>리콜</button></div>', 
            latlng: new kakao.maps.LatLng(37.560963, 126.975494)
        })
        positions.push({
            content: '<div style="padding:5px;">온도 : ${temperature1 }<br>습도 : ${humidity1}<br><button>리콜</button></div>', 
            latlng: new kakao.maps.LatLng(37.517262, 126.900983)
        })

            iwRemoveable = true; // removeable 속성을 true 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다
        for (var i = 0; i < positions.length; i ++) {
            // 마커를 생성합니다
            var marker = new kakao.maps.Marker({
                map: map, // 마커를 표시할 지도
                position: positions[i].latlng // 마커의 위치
                
            });

            // 마커에 표시할 인포윈도우를 생성합니다 
            var infowindow = new kakao.maps.InfoWindow({
                content: positions[i].content, // 인포윈도우에 표시할 내용
                removable: iwRemoveable
            });
            kakao.maps.event.addListener(marker, 'click', makeOverListener(map, marker, infowindow));
        }

        // 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
        function makeOverListener(map, marker, infowindow) {
            return function() {
                infowindow.open(map, marker);
            };
        }

        // 인포윈도우를 닫는 클로저를 만드는 함수입니다 
        function makeOutListener(infowindow) {
            return function() {
                infowindow.close();
            };
        }
        

        function handleButtonClicked(index) {
            var targetMarker = positions[index];
            var zoomLevel = 3;

            map.setLevel(zoomLevel);
            map.panTo(targetMarker.latlng);

            var infowindow = new kakao.maps.InfoWindow({
                content: targetMarker.content,
                removable: iwRemoveable
            });

            infowindow.open(map, new kakao.maps.Marker({ position: targetMarker.latlng }));

            // 리콜 버튼 클릭 시 해당 버튼 삭제
            var buttonToDelete = document.querySelector('#p' + (index + 1));
            if (buttonToDelete) {
                buttonToDelete.parentNode.removeChild(buttonToDelete);
            }
        }

        // 버튼 클릭 이벤트 설정 (p1~p6 버튼 클릭 이벤트 리스너 등록)
        for (var i = 0; i < positions.length; i++) {
            document.querySelector('#p' + (i + 1)).addEventListener('click', function (event) {
                var buttonId = event.target.id; // 클릭된 버튼의 ID
                var buttonIndex = parseInt(buttonId.substring(1)) - 1; // 버튼 인덱스 계산
                handleButtonClicked(buttonIndex);
            });
        }

        // 지도 마우스, 키보드 이벤트
        // 마우스 드래그로 지도 이동이 완료되었을 때 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
        kakao.maps.event.addListener(map, 'dragend', function () {

            // 지도 중심좌표를 얻어옵니다 
            var latlng = map.getCenter();

            var message = '변경된 지도 중심좌표는 ' + latlng.getLat() + ' 이고, ';
            message += '경도는 ' + latlng.getLng() + ' 입니다';

            var resultDiv = document.getElementById('result');
            resultDiv.innerHTML = message;

        });
        // 키보드 이벤트 리스너 등록
        document.addEventListener('keydown', function (event) {
            var currentCenter = map.getCenter();
            var currentLevel = map.getLevel();
            var newCenter, newLevel;

            switch (event.key) {
                case 'ArrowUp':
                    newCenter = new kakao.maps.LatLng(currentCenter.getLat() + 0.001, currentCenter.getLng());
                    break;
                case 'ArrowDown':
                    newCenter = new kakao.maps.LatLng(currentCenter.getLat() - 0.001, currentCenter.getLng());
                    break;
                case 'ArrowLeft':
                    newCenter = new kakao.maps.LatLng(currentCenter.getLat(), currentCenter.getLng() - 0.001);
                    break;
                case 'ArrowRight':
                    newCenter = new kakao.maps.LatLng(currentCenter.getLat(), currentCenter.getLng() + 0.001);
                    break;
                case '+':
                case '=':
                    newLevel = currentLevel - 1;
                    break;
                case '-':
                    newLevel = currentLevel + 1;
                    break;
                default:
                    return;
            }

            if (newCenter) {
                map.panTo(newCenter);
            }
            if (newLevel) {
                map.setLevel(newLevel);
            }
        });

        // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
        kakao.maps.event.addListener(map, 'zoom_changed', function () {

            // 지도의 현재 레벨을 얻어옵니다
            var level = map.getLevel();

                var message = '현재 지도 레벨은 ' + level + ' 입니다';
                var resultDiv = document.getElementById('result');
                resultDiv.innerHTML = message;

        });
    </script>
</body>
</html>