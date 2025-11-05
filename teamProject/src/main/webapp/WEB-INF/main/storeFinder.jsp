<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>:: 내 주변 디저트 지점 찾기 ::</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!--페이지 이동-->
    <script src="/js/page-change.js"></script>

    <!--카카오맵 api-->
    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1dea2458084bcfa27a4ea450ca55655b&libraries=services"></script>

    <style>
        .simple-infowindow {
            /* background-color: white; */
            /* border: 1px solid #ccc; */
            border-radius: 8px;
            padding: 6px 10px;
            color: #000 !important;
            font-size: 13px;
            text-align: center;
            white-space: nowrap;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

       
        .title {
            font-size: 28px;
            font-weight: 700;
            font-family: 'GmarketSansMedium', sans-serif;
            color: #333;
            margin-top: 30px;
            margin-bottom: 25px;
            padding-bottom: 10px;
            text-align: left;
        }

        #map {
            width: 100%;
            height: 400px;
            border-radius: 10px;
            margin: 20px auto;
            display: block;
        }

        .addr-info {
            margin-top: 10px;
            color: #555;
        }

        div.kakao-infowindow,
        .wrap div {
            color: #000 !important;
            opacity: 1 !important;
        }


        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            margin-top: 20px;
            font-size: 14px;
        }

        th,
        td {
            padding: 15px 10px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        table td:first-child {
            padding-left: 20px;
        }

        .info {
            margin-left: 30px;
            font-size: 12px;
            color: #666;
        }

        .myAddr {
            margin-top: 20px;
            font-family: 'GmarketSansMedium', sans-serif;
            font-size: 18px;
            color: #333;
        }
    </style>
</head>

<body>
    <%@ include file="/WEB-INF/main/header.jsp" %>

    <div id="app">
        <div class="container">
            <main class="content-container">
                <h1 class="title">내 주변 디저트 지점 찾기</h1>
                <hr class="divider">

                <div>※ 현재 고객님의 마이페이지 주소를 기반으로 한 5Km 이내 디저트 지점 정보입니다. </div>
                <div class="myAddr">
                    내 주소 : {{info.userAddr}}
                </div>

                <div id="map"></div>

                <div>
                    <table>
                        <tr>
                            <th>가게명</th>
                            <th>주소</th>
                            <th>거리</th>
                        </tr>
                        <tr v-for="item in sellerList" :key="item.storeAddr">
                            <td>{{item.storeName}}</td>
                            <td>{{item.storeAddr}}</td>
                            <td>{{item.distanceKm || "-"}} km</td>
                        </tr>
                    </table>
                    <div v-if="sellerList.length === 0" style="text-align: center; padding: 20px; color: #777;">
                        고객님 주변 5km 이내에는 등록된 가게가 없습니다.
                    </div>
                </div>
                <section class="external-ad">
                    <p>외부 광고</p>
                </section>
            </main>
        </div>
    </div>

    <%@ include file="/WEB-INF/main/footer.jsp" %>
</body>

</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            info: { userAddr: '고객 주소를 불러오는 중입니다...(로그인세션 확인)' },
            list: [],
            userId: "${sessionId}",
            keyword: "",
            pageSize: 10,
            page: 1,
            index: 0,
            map: null,
            geocoder: null,
            userCoords: null,
            sellerList: [],
            nearbySellers: [],
        };
    },

    methods: {
        fnList() {
            let self = this;
            $.ajax({
                url: "/main/list.dox",
                dataType: "json",
                type: "POST",
                data: { keyword: self.keyword },
                success: function (data) { self.list = data.list; }
            });
        },

        fnUserInfo(callback) {
            const self = this;
            $.ajax({
                url: "/main/userInfo.dox",
                type: "POST",
                dataType: "json",
                data: { userId: self.userId },
                success(data) {
                    if (data.info && data.info.userAddr) {
                        self.info = data.info;
                        self.setMarkerByAddress(self.info.userAddr, "내 주소 위치", true, callback);
                    } else if (callback) callback();
                }
            });
        },

        setMarkerByAddress(address, titleText = "위치", setUser = false, callback = null) {
            const self = this;
            self.geocoder.addressSearch(address, (result, status) => {
                if (status === kakao.maps.services.Status.OK && result[0]) {
                    const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    if (setUser) self.userCoords = coords;

                    // 빨간색 고객 마커
                    const marker = new kakao.maps.Marker({
                        map: self.map,
                        position: coords,
                        image: new kakao.maps.MarkerImage(
                            'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                            new kakao.maps.Size(35, 40),
                            { offset: new kakao.maps.Point(12, 35) }
                        )
                    });

                    // infoWindow
                    const infowindow = new kakao.maps.InfoWindow({
                        content: '<div class="simple-infowindow">' + titleText + '</div>'
                    });

                    // 바로 열기
                    infowindow.open(self.map, marker);

                    // 클릭 이벤트도 유지
                    kakao.maps.event.addListener(marker, 'click', () => infowindow.open(self.map, marker));

                    if (setUser) self.map.setCenter(coords);
                    if (callback) callback();
                } else if (callback) callback();
            });
        },

        fnSellerList() {
            const self = this;
            $.ajax({
                url: "/main/storeList.dox",
                type: "POST",
                dataType: "json",
                success(data) {
                    self.sellerList = data.list;
                    if (self.userCoords) self.filterNearbySellers();
                }
            });
        },

        calculateDistanceByCoords(coord1, coord2) {
            const R = 6371;
            const lat1 = coord1.getLat() * Math.PI / 180;
            const lat2 = coord2.getLat() * Math.PI / 180;
            const dLat = (coord2.getLat() - coord1.getLat()) * Math.PI / 180;
            const dLon = (coord2.getLng() - coord1.getLng()) * Math.PI / 180;

            const a = Math.sin(dLat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon/2)**2;
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
            return R * c;
        },

        async filterNearbySellers() {
            const self = this;
            if(!self.userCoords || !self.sellerList.length) { self.sellerList = []; return; }

            self.nearbySellers = [];
            const promises = self.sellerList.map(item => {
                if(!item || !item.storeAddr) return Promise.resolve();

                return new Promise(resolve => {
                    self.geocoder.addressSearch(item.storeAddr, (result,status)=>{
                        if(status===kakao.maps.services.Status.OK && result[0]){
                            const storeCoords = new kakao.maps.LatLng(result[0].y, result[0].x);
                            const distanceKm = self.calculateDistanceByCoords(self.userCoords, storeCoords);

                            if(distanceKm <= 5){
                                self.nearbySellers.push({...item, coords: storeCoords, distanceKm: distanceKm.toFixed(1)});
                                self.setStoreMarker(storeCoords, item.storeName, distanceKm.toFixed(1));
                            }
                        }
                        resolve();
                    });
                });
            });

            await Promise.all(promises);

            // 🚩 [요청 3] 모든 마커를 포함하도록 지도 영역 설정
            if (self.userCoords && self.nearbySellers.length > 0) {
                // LatLngBounds 객체 생성
                const bounds = new kakao.maps.LatLngBounds();

                // 1. 고객 주소 좌표를 영역에 포함
                bounds.extend(self.userCoords);

                // 2. 모든 가게 좌표를 영역에 포함
                self.nearbySellers.forEach(item => {
                    if (item.coords) {
                        bounds.extend(item.coords);
                    }
                });

                // 3. 지도 영역을 계산된 bounds로 설정
                self.map.setBounds(bounds);
            }
            // 🚩 지도 영역 설정 끝

            self.$nextTick(()=>{
                self.nearbySellers.sort((a,b)=>parseFloat(a.distanceKm||9999)-parseFloat(b.distanceKm||9999));
                self.sellerList = [...self.nearbySellers];
            });
        },

        setStoreMarker(coords, name, distanceKm) {
            const self = this;
            
            const marker = new kakao.maps.Marker({
                map: self.map,
                position: coords,
                image: self.createStoreMarkerImage()
            });

            const content = '<div class="simple-infowindow">' + name + '<br>(' + distanceKm + ' km)</div>';
            const infowindow = new kakao.maps.InfoWindow({ content });
            // 마커 올리자마자 바로 열기
  infowindow.open(self.map, marker);
        },

        createStoreMarkerImage() {
            const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
            const imageSize = new kakao.maps.Size(32, 45);
            const imageOption = { offset: new kakao.maps.Point(16, 45) };
            return new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
        }
    },

    mounted() {
        const self = this;
        kakao.maps.load(()=>{
            self.map = new kakao.maps.Map(document.getElementById('map'), {
                center: new kakao.maps.LatLng(37.5665, 126.9780),
                level: 4
            });
            self.geocoder = new kakao.maps.services.Geocoder();
            self.fnUserInfo(()=>self.fnSellerList());
        });
    }
});

app.mount('#app');
</script>
