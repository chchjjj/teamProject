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

            /* 2. 테이블 헤더와 셀 스타일 수정 */
            th, td {
                padding: 15px 10px;
                border-bottom: 1px solid #eee;
                text-align: left; /* 전체 셀을 왼쪽 정렬로 변경 */
            }

            /* 첫 번째 열 (가게명)에 약간의 여백을 줘서 더 깔끔하게 */
            table td:first-child {
                padding-left: 20px;
            }
          
            .info{
                margin-left: 30px;
                font-size: 12px;
                color:#666;
            }

            .myAddr{ /*내 주소 나오는 영역*/
                margin-top: 20px;
                font-family: 'GmarketSansMedium', sans-serif;
                font-size : 18px;
                color: #333;
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
                        <div class="myAddr">
                            내 주소 : {{info.userAddr}}
                        </div>

                        <!-- 고객 주소 기반 지도 표시 -->
                        <div id="map"></div>

                        <!-- 가게 리스트 / 주변 반경 5km 미만 반영 전 -->
                        <div>
                            <table>
                                <tr>
                                    <th>가게명</th>
                                    <th>주소</th>
                                    <th>거리</th>
                                </tr>
                                <tr v-for="item in sellerList">
                                    <td>{{item.storeName}}</td>
                                    <td>{{item.storeAddr}}</td>
                                    <td>{{item.distanceKm}} km</td>
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

                    // ⭐ 수정: 초기값 설정
                    info : { userAddr: '고객 주소를 불러오는 중입니다...(로그인세션이 풀렸는지 확인해주세요.)' }, 
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
                            // ⭐ 핵심 수정: data.info가 null인지 먼저 확인합니다.
            if (data.info && data.info.userAddr) { 
                self.info = data.info;
                
                // 로그인 유저 USER_TBL 기반 주소 위치부분에 문구 표시
                self.setMarkerByAddress(self.info.userAddr, "내 주소 위치", true);

                if(callback) callback(); // userCoords 세팅 후 실행
            } else {
                console.warn("로그인 정보(data.info)가 null이거나 유효한 주소를 찾을 수 없습니다. (ID: " + self.userId + ")");
                // 주소가 없을 경우에도 콜백을 호출하여 다음 단계(가게 리스트 조회)는 진행 (필터링은 실패로 이어짐)
                if (callback) callback();
            }
                        }
                    });
                },

                //지도에 마커 찍기 (고객 주소)
                setMarkerByAddress(address, titleText = "위치", setUser=false) {
                    let self = this;
                    if (!self.geocoder || !self.map) {
                        console.warn("지도 또는 Geocoder가 초기화되지 않았습니다.");
                        return;
                    }

                    self.geocoder.addressSearch(address, function(result, status) {
                        if (status === kakao.maps.services.Status.OK) {
                            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                            if(setUser) self.userCoords = coords;

                            // 마커 생성
                            const marker = new kakao.maps.Marker({
                                map: self.map,
                                position: coords
                            });

                            // 인포윈도우
                            const infowindow = new kakao.maps.InfoWindow({
                                content: '<div style="padding:5px; font-size:13px;">내 주소 위치</div>'
                            });
                            infowindow.open(self.map, marker);

                            // 마커 클릭 이벤트 등록 
                            kakao.maps.event.addListener(marker, 'click', function() {
                                infowindow.open(self.map, marker);
                            });

                            // 지도 중심 이동
                            //self.map.setCenter(coords);
                            if(setUser) self.map.setCenter(coords);

                        } 

                    });
                },   

                // 판매자(가게) 리스트
                fnSellerList() {
                    let self = this;
                    $.ajax({
                        url: "/main/storeList.dox", // 전체 가게 리스트 가져오기
                        dataType: "json",
                        type: "POST",
                        success: function(data) {
                            self.sellerList = data.list; // 전체 리스트를 받아옴 (필터링 전)
                            
                            // **고객 좌표 설정 확인 후 필터링 함수 호출**
                            if (self.userCoords) {
                                self.filterNearbySellers(); // 5km 필터 적용
                            } else {
                                console.warn("고객 주소 좌표가 아직 설정되지 않았습니다.");
                            }
                        }
                    });
                },
                
                //-----------------------------------------------------------------------------------
                // 두 좌표(LatLng 객체) 간의 거리(m)를 계산하는 함수
                calculateDistance(latLng1, latLng2) {
                    if (!kakao.maps.geometry) {
                        console.error("geometry 라이브러리가 로드되지 않았습니다.");
                        return Infinity;
                    }
                    // 거리를 미터 단위로 반환
                    return kakao.maps.geometry.spherical.computeDistanceBetween(latLng1, latLng2);
                },

                filterNearbySellers() {
                    let self = this;
                    if (!self.userCoords || !self.sellerList.length) {
                        console.warn("고객 좌표 또는 판매자 리스트가 준비되지 않았습니다.");
                        self.sellerList = []; // 데이터가 없으면 리스트 초기화
                        return;
                    }

                    self.nearbySellers = []; // 필터링된 리스트 초기화

                    // 주소-좌표 변환을 비동기적으로 처리하기 위해 Promise.all 사용
                    const promises = self.sellerList.map(item => {
                        return new Promise((resolve) => {
                            self.geocoder.addressSearch(item.storeAddr, function(result, status) {
                                if (status === kakao.maps.services.Status.OK) {
                                    const storeCoords = new kakao.maps.LatLng(result[0].y, result[0].x);
                                    const distance = self.calculateDistance(self.userCoords, storeCoords); // 거리 계산 (m)
                                    const distanceKm = (distance / 1000).toFixed(1); // km 단위로 변환 및 소수점 1자리

                                    // 5000m (5km) 이내인 경우
                                    if (distance <= 5000) { 
                
                                        // ⭐ 수정된 핵심 로직 ⭐
                                        // 1. 기존 객체의 속성을 복사하면서, distanceKm 속성을 명시적으로 추가하여 새로운 객체 생성
                                        const nearbyItem = {
                                            ...item, // 기존 item 객체의 모든 속성(storeName, storeAddr 등) 복사
                                            coords: storeCoords, // 좌표 정보 추가
                                            distanceKm: distanceKm // 계산된 거리 정보 추가
                                        };
                                        
                                        // 2. 필터링된 리스트에 새로운 객체 추가
                                        self.nearbySellers.push(nearbyItem); 
                                        
                                        // 3. 지도에 마커 표시 (5km 이내 가게만)
                                        self.setStoreMarker(storeCoords, nearbyItem.storeName, distanceKm); 
                                        
                                        console.log(`[필터링 성공] ${nearbyItem.storeName} (${distanceKm} km)`);
                                        // ⭐ 여기까지 복사하여 붙여넣으시면 됩니다. ⭐
                                        
                                    } else {
                                        console.log(`[필터링 제외] ${item.storeName} (${distanceKm} km) - 5km 초과`);
                                    }
                                } else {
                                    console.warn(`[주소 변환 실패] ${item.storeName} (${item.storeAddr}): ${status}`);
                                }
                                resolve(); // 성공하든 실패하든 promise는 완료
                            });
                        });
                    });

                    // 모든 주소 변환 및 필터링이 끝난 후 Vue 데이터 바인딩
                    Promise.all(promises).then(() => {
                        // 1. 모든 주소 변환이 완료된 후 거리순으로 정렬
                        self.nearbySellers.sort((a, b) => parseFloat(a.distanceKm) - parseFloat(b.distanceKm));
                        // 2. v-for가 사용할 최종 리스트를 업데이트
                        self.sellerList = self.nearbySellers;
                        console.log("5km 이내 필터링 완료. 결과 개수: " + self.sellerList.length); // 디버깅 로그 추가
                    });
                },
                // 가게 마커와 인포윈도우를 표시하는 함수
                setStoreMarker(coords, name, distanceKm) {
                    let self = this;
                    const marker = new kakao.maps.Marker({
                        map: self.map,
                        position: coords,
                        image: self.createStoreMarkerImage() // 가게 전용 마커 이미지 사용 (선택 사항)
                    });

                    // 인포윈도우 내용
                    const content = `
                        <div class="simple-infowindow">
                            ${name} <br> (${distanceKm} km)
                        </div>
                    `;

                    const infowindow = new kakao.maps.InfoWindow({
                        content: content,
                        removable: true
                    });
                    
                    // 마커에 마우스 오버 시 인포윈도우 표시 이벤트
                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        infowindow.open(self.map, marker);
                    });

                    // 마커에서 마우스 아웃 시 인포윈도우 닫기 이벤트
                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        infowindow.close();
                    });
                },

                // 가게 마커 이미지 생성 (선택 사항)
                createStoreMarkerImage() {
                    const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_selected.png'; 
                    const imageSize = new kakao.maps.Size(32, 45); 
                    const imageOption = {offset: new kakao.maps.Point(16, 45)};

                    return new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
                }
                                                

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
                kakao.maps.load(() => {
                    const mapContainer = document.getElementById('map');
                    self.map = new kakao.maps.Map(mapContainer, {
                        center: new kakao.maps.LatLng(37.5665, 126.9780),
                        level: 4
                    });

                    // Geocoder 생성
                    self.geocoder = new kakao.maps.services.Geocoder();

                    // 로그인 사용자의 주소 불러오기
                    self.fnUserInfo(() => {
                        // userCoords가 세팅된 이후에 반경 5km 이내 판매자 리스트 조회
                        self.fnSellerList();

                        // 지도 렌더링 후 bounds 확인
                        kakao.maps.event.addListener(self.map, 'idle', function() {
                        // 지도 반경 계산 (선택 사항)
                        // const bounds = self.map.getBounds();
                        // const ne = bounds.getNorthEast();
                        // const center = self.map.getCenter();
                        // const distance = kakao.maps.geometry.spherical.computeDistanceBetween(center, ne);
                        // console.log("현재 지도 반경(약): " + (distance / 1000).toFixed(2) + " km");
                    });
                });
            });
        }   
    });
    
        app.mount('#app');
    </script>