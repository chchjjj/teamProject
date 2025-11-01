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

        <!-- mitt 불러오기 -->
        <!-- <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script>  -->         
        
        <!--카카오맵 api-->
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1dea2458084bcfa27a4ea450ca55655b&libraries=services,geometry"></script>

        <style>
            /* 카카오맵 인포윈도우 텍스트 표시용 */
            .simple-infowindow {
                background-color: white;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 6px 10px;
                color: #000;
                font-size: 13px;
                text-align: center;
                white-space: nowrap;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            }

            /* 제목 스타일 */
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
                width:100%; 
                height:350px; 
                border-radius:10px; 
                margin: 20px auto; /* 위아래 여백 20px, 좌우 자동 중앙정렬 */
                display: block;    /* auto 정렬을 위해 block 지정 */
            }
            .addr-info { 
                margin-top:10px; color:#555; 
            }

            /* 카카오맵 인포윈도우 공통 스타일 */
            div.kakao-infowindow, .wrap div {
                color: #000 !important;
                opacity: 1 !important;
            }

            table {
                width: 100%; /* 테이블 전체 너비 */
                border-collapse: collapse; /* 테이블 셀 경계선을 하나로 합침 */
                table-layout: fixed; /* 컬럼 너비를 고정된 비율로 설정 */
                margin-top: 20px;
                font-size: 14px;
            }

            /* 2. 테이블 헤더와 셀 스타일 */
            th, td {
                padding: 15px 10px; /* 셀 내부 여백을 넓직하게 설정 */
                border-bottom: 1px solid #eee; /* 하단에 옅은 회색 선 추가 */
                text-align: center; /* 기본 텍스트는 가운데 정렬 */
            }

            /* 제목은 왼쪽 정렬 */
            /* table td:nth-child(1) {
                text-align: center;
                padding-left: 20px;
            }

            table td:nth-child(2) {
                text-align: left;
                white-space: nowrap;      /* 텍스트가 줄 바꿈 되는 것을 방지 
            } */
          
            .info{
                margin-left: 30px;
                font-size: 12px;
                color:#666;
            }

        </style>
    </head>

    <body>
        <!-- 헤더 -->
        <%@ include file="/WEB-INF/main/header.jsp" %>

            <div id="app">
                <!-- html 코드는 id가 app인 태그 안에서 작업 -->

                <div class="container">


                    <main class="content-container">                        
                        <h1 class="title">내 주변 디저트 지점 찾기</h1>
                        <hr class="divider">

                        <div>※ 현재 고객님의 마이페이지 주소를 기반으로 한 주변 디저트 지점 정보입니다. </div>
                        <div>
                            내 주소 : {{info.userAddr}}
                        </div>

                        <!-- 고객 주소 기반 지도 표시 -->
                        <div id="map"></div>

                        <!-- 주변 반경 5km 미만(임시) 가게 리스트 -->
                        <!-- <table v-if="nearbySellers.length > 0">
                            <thead>
                                <tr>
                                    <th>상호</th>
                                    <th>주소</th>
                                    <th>거리(km)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in nearbySellers" :key="item.id">
                                    <td>{{ item.storeName }}</td>
                                    <td>{{ item.storeAddr }}</td>
                                    <td>{{ (item.distance/1000).toFixed(2) }}</td>
                                </tr>
                            </tbody>
                        </table>
                        <div v-else>5km 이내 디저트 지점이 없습니다.</div>                       -->


                        <section class="external-ad">
                            <p>외부 광고</p>
                        </section>
                    </main>
                </div>
            </div>
            <!-- 푸터 -->
            <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        // mitt 전역 이벤트 버스 생성 (헤더, 메인 양쪽에서 동일하게 사용)
        //const emitter = mitt();

        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    info : {},
                    list: [], // 헤더에서 쓰는 리스트
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                    keyword: "", // 헤더 검색 키워드 변수 추가

                    // 페이징
                    pageSize : 10, // 한 페이지에 출력할 게시글 개수 (10개로 기본값)
                    page : 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index : 0, // 최대 페이지 값 (표현할 페이지 개수)

                    // 지도 관련
                    map: null,
                    geocoder: null,
                    userCoords: null,
                    sellerList : [], // 전체 판매자 리스트
                    nearbySellers: [], // 필터링된 5km 이내 판매자
                };
            },

            methods: {
                // 함수(메소드) - (key : function())

                // 헤더 검색창에 내용 검색했을 때 main 쪽에서 검색되도록
                fnList: function () {
                    let self = this;
                    let param = {
                        keyword: self.keyword
                    };
                    $.ajax({
                        url: "/main/list.dox", // 상품 리스트 조회주소 
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      

                        }
                    });
                },

                // 로그인 세션 사용자의 정보 통해 주소 불러오기
                fnUserInfo(callback) {
                    let self = this;
                    let param = {
                        userId : self.userId
                    };
                    $.ajax({
                        url: "/main/userInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.info = data.info;
                            // 로그인 유저 USER_TBL 기반 주소 위치부분에 문구 표시
                            self.setMarkerByAddress(self.info.userAddr, "내 주소 위치", true);

                            if(callback) callback(); // userCoords 세팅 후 실행
                        }
                    });
                },

                // 지도에 마커 찍기 (고객 주소)
                // setMarkerByAddress(address, titleText = "위치", setUser=false) {
                //     let self = this;
                //     if (!self.geocoder || !self.map) {
                //         console.warn("지도 또는 Geocoder가 초기화되지 않았습니다.");
                //         return;
                //     }

                //     self.geocoder.addressSearch(address, function(result, status) {
                //         if (status === kakao.maps.services.Status.OK) {
                //             const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                //             if(setUser) self.userCoords = coords;

                //             // 마커 생성
                //             const marker = new kakao.maps.Marker({
                //                 map: self.map,
                //                 position: coords
                //             });

                //             // 인포윈도우
                //             const infowindow = new kakao.maps.InfoWindow({
                //                 content: '<div style="padding:5px; font-size:13px;">내 주소 위치</div>'
                //             });
                //             infowindow.open(self.map, marker);

                //             // 마커 클릭 이벤트 등록 
                //             kakao.maps.event.addListener(marker, 'click', function() {
                //                 infowindow.open(self.map, marker);
                //             });

                //             // 지도 중심 이동
                //             //self.map.setCenter(coords);
                //             if(setUser) self.map.setCenter(coords);

                //         } 

                //     });
                // },   

                // // 판매자(가게) 리스트
                // fnSellerList() {
                //     let self = this;
                //     $.ajax({
                //         url: "", // 전체 판매자 리스트 가져오기
                //         dataType: "json",
                //         type: "POST",
                //         success: function(data) {
                //             self.sellerList = data.list; // 전체 리스트를 받아옴
                //             self.filterNearbySellers(); // 5km 필터 적용
                //         }
                //     });
                // },
                
                // // 5km 이내 판매자(가게 주소) 필터링
                // filterNearbySellers() {
                //     let self = this;
                //     if(!self.userCoords) return;

                //     const promises = self.sellerList.map(seller => {
                //         return new Promise((resolve) => {
                //             self.geocoder.addressSearch(seller.storeAddr, function(result, status){
                //                 if(status === kakao.maps.services.Status.OK){
                //                     const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                //                     const distance = kakao.maps.geometry.spherical.computeDistanceBetween(self.userCoords, coords);
                //                     if(distance <= 5000){ // 5km
                //                         seller.distance = distance;
                //                         resolve(seller);
                //                     } else {
                //                         resolve(null);
                //                     }
                //                 } else {
                //                     resolve(null);
                //                 }
                //             });
                //         });
                //     });

                //     Promise.all(promises).then(results => {
                //         self.nearbySellers = results.filter(s => s!==null);
                //     });
                // }
                                                

            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트 
                //self.fnUserInfo();                        

                // 헤더에서 keyword (검색어) 이벤트 수신 (주석처리해도 되네?)
                // emitter.on('keyword', (keyword) => {
                //     console.log("헤더에서 받은 검색어:", keyword);
                //     self.keyword = keyword;
                //     self.fnList(); // 메인에서 검색 실행
                // });

                // 헤더 메뉴 중 '카테고리' 하위 메뉴 클릭 이벤트 수신
                // emitter.on('categoryClick', (categoryName) => {
                //     console.log("카테고리 클릭:", categoryName);
                //     self.selectedCategory = categoryName;
                //     self.fnList(); // 해당 카테고리 상품만 조회
                // });


                // 지도 초기화
            //     kakao.maps.load(() => {
            //         const mapContainer = document.getElementById('map');
            //         self.map = new kakao.maps.Map(mapContainer, {
            //             center: new kakao.maps.LatLng(37.5665, 126.9780),
            //             level: 4
            //         });

            //         // Geocoder 생성
            //         self.geocoder = new kakao.maps.services.Geocoder();

            //         // 로그인 사용자의 주소 불러오기
            //         self.fnUserInfo(() => {
            //             // userCoords가 세팅된 이후에 반경 5km 이내 판매자 리스트 조회
            //             self.fnSellerList();

            //             // 지도 렌더링 후 bounds 확인
            //             kakao.maps.event.addListener(self.map, 'idle', function() {
            //             // 지도 반경 계산 (선택 사항)
            //             const bounds = self.map.getBounds();
            //             const ne = bounds.getNorthEast();
            //             const center = self.map.getCenter();
            //             const distance = kakao.maps.geometry.spherical.computeDistanceBetween(center, ne);
            //             console.log("현재 지도 반경(약): " + (distance / 1000).toFixed(2) + " km");
            //         });
            //     });
            // });
        }   
    });
    
        app.mount('#app');
    </script>