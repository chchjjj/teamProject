<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배송지 팝업</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* 1. CSS 변수 정의 */
        :root {
            /* 메인 컬러: 네비게이션 및 버튼에 사용되는 진한 갈색 */
            --main-bg-color: #3C2F2F; 
            /* 배경색: RGB (240, 226, 182) 밝은 베이지색 */
            --sub-bg-color: #F0E2B6; 
            /* 카드 내부 배경색 (흰색 유지) */
            --card-bg-color: #FFFFFF;
            /* 강조 버튼/링크 색상 */
            --primary-color: #6B574C; 
            /* 일반 텍스트 색상 (주로 밝은 배경에서 사용) */
            --text-color: #333333;
            /* 연한 테두리 색상 */
            --border-color: #E0E0E0;
            /* 밝은 배경 도트 패턴 색상 */
            --light-dot-bg-color: rgba(0,0,0,0.1); /* 은은한 도트 효과 (대비 조절) */
            /* 어두운 배경색 (body로 이동) */
            --app-dark-bg: #3E2723;
            /* 밝은 텍스트 색상 */
            --light-text-color: #FFFFFF;
        }
        
        /* 2. body 및 전체 배경 스타일 */
        body {
            /* ★★★ 배경색 교체: #app의 기존 어두운 색상 적용 ★★★ */
            background-color: var(--app-dark-bg); 
            
            /* 은은한 도트 패턴 (어두운 배경에 대비되도록 밝은 도트 사용) */
            background-image: radial-gradient(circle at 1px 1px, rgba(255,255,255,0.08) 1px, transparent 0);
            background-size: 15px 15px; /* 도트 간격 */
            
            min-height: 100vh;
            font-family: 'Malgun Gothic', 'Dotum', sans-serif;
            /* ★★★ 텍스트 색상을 흰색으로 변경하여 대비 확보 ★★★ */
            color: var(--light-text-color); 
            margin: 0; /* body 기본 마진 제거 */
            padding: 20px;
        }

        /* 3. 팝업 전체 컨테이너 스타일 */
        #app {
            width: 100%;
            max-width: 450px; /* 팝업 크기 조정 */
            margin: 0 auto;
            /* ★★★ 배경색 교체: body의 기존 밝은 색상 적용 ★★★ */
            background-color: var(--sub-bg-color); 
            border: 1px solid #000; /* 검은색 테두리 */
            padding: 10px;
            box-sizing: border-box;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5); /* 어두운 배경에 더 잘 보이도록 그림자 강화 */
            /* ★★★ #app 내부의 기본 텍스트 색상을 어둡게 재설정 ★★★ */
            color: var(--text-color);
            position: relative; /* ::before를 위한 position 설정 유지 */
        }

        /* Section 1 제목 스타일 제거 */
        #app::before {
            content: none; 
        }
        
        /* 신규 배송지 입력 영역 스타일 */
        .new-address-input-area {
            background-color: var(--card-bg-color); /* 흰색 배경으로 설정 */
            padding: 15px;
            border: 1px solid var(--text-color); /* 단색 테두리로 변경 */
            margin-bottom: 15px;
            box-shadow: 2px 2px 0 #000;
        }
        .new-address-input-area > div {
            margin-bottom: 10px;
        }

        /* ★★★ 4. 주소검색 버튼 스타일 추가 ★★★ */
        .btn-addr-search {
            background-color: var(--border-color); /* 밝은 회색 */
            color: var(--text-color);
            border: 1px solid var(--text-color);
            padding: 5px 10px;
            cursor: pointer;
            font-weight: bold;
            margin-left: 10px; /* 입력 필드와의 간격 */
        }
        .btn-addr-search:hover {
            background-color: #D0D0D0;
        }


        /* 신규 배송지 추가 버튼 컨테이너 */
        .add-new-btn-container {
            padding: 15px 0 5px 0; /* 상단 간격 조정 */
            text-align: center;
        }
        
        /* 주소록 항목 카드 스타일 */
        .address-card {
            /* ★★★ 이미지의 회색 배경 대신 흰색 배경으로 대비 유지 ★★★ */
            background-color: var(--card-bg-color); 
            padding: 15px;
            margin-top: 15px;
            border: 1px solid var(--text-color);
            position: relative;
            font-size: 15px;
            color: var(--text-color); 
            box-shadow: 2px 2px 0 #000;
        }

        /* 기본 배송지 스타일 */
        .default-address-card {
            margin-top: 15px; 
        }
        
        /* 카드 제목 (기본 배송지) */
        .card-title {
            font-weight: bold;
            margin-bottom: 5px;
            font-size: 16px;
        }
        /* 추가 배송지 이름 (item.addressName을 가정하고 임시 설정) */
        .card-title-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        /* 상세 주소 및 폰 번호 */
        .card-detail-text {
            line-height: 1.5;
            color: #555;
            /* ★★★ 버튼 그룹 공간 확보를 위해 하단 패딩 추가 ★★★ */
            padding-bottom: 40px; /* 버튼 그룹 높이 + 충분한 여백을 고려하여 40px 지정 */
            margin-bottom: 0; /* 기존 margin-bottom: 15px; 대신 padding-bottom 사용 */
        }
        
        /* 버튼 그룹 (선택/삭제) */
        .card-button-group {
            position: absolute;
            bottom: 15px;
            right: 15px;
            display: flex;
            gap: 5px;
        }

        /* 선택 버튼 */
        .btn-modify {
            background-color: var(--card-bg-color);
            border: 1px solid var(--text-color);
            padding: 5px 10px;
            cursor: pointer;
            font-size: 13px;
        }

        /* 삭제 버튼 */
        .btn-delete {
            background-color: var(--card-bg-color);
            border: 1px solid var(--text-color);
            padding: 5px 10px;
            cursor: pointer;
            font-size: 13px;
        }

        /* 구분선은 이미지에 없으므로 삭제하거나 숨김 처리 */
        hr {
            display: none;
        }

        /* phone 입력 칸 크기 조정 */
        .phone {
            width: 50px;
            text-align: center;
        }
        /* 주소 입력 칸 크기 조정 */
        .new-address-input-area input[disabled] {
            width: 250px;
        }

        /* 신규 배송지 저장 버튼을 감싸는 div (가운데 정렬) */
        .new-address-input-area > div:last-child {
            text-align: center; /* 이 div 내부의 인라인 콘텐츠(버튼)를 가운데 정렬 */
            margin-bottom: 0; /* 불필요한 하단 마진 제거 또는 유지 */
        }
        
        /* ... 기존의 .new-address-input-area > div:last-child button 스타일 ... */
        
        /* ★★★ 5. 배송지 저장 버튼 스타일 조정 (마진 추가) ★★★ */
        .new-address-input-area > div:last-child button {
            background-color: #E0E0E0;
            border: 1px solid var(--text-color);
            padding: 8px 15px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div id="app">
        <div class="new-address-input-area" v-if="showAddForm"> 
            <div> 
                주소 : <input v-model="addr" disabled>
                <button class="btn-addr-search" @click="fnSearchAddr">주소검색</button>
            </div>
            <div>
                핸드폰번호 :
                <input class="phone" v-model="phone1"> -
                <input class="phone" v-model="phone2"> -
                <input class="phone" v-model="phone3">
            </div>
             <div>
                <button @click="fnAddAddress">+ 배송지 신규 입력</button>
            </div> 
        </div>

        <div v-if="showAddrFrame" style="margin-top:10px; text-align:center;">
            <iframe 
                id="jusoFrame" 
                src="/user/addr.do" 
                style="width:100%; height:500px; border:1px solid #ccc;"
            ></iframe>
            <button @click="showAddrFrame=false" style="margin-top:10px;">닫기</button>
        </div>


        <div class="address-card default-address-card">
            <div class="card-title">기본배송지</div>
            <div class="card-detail-text">
                <div>{{userPhone}}</div>
                <div>{{userAddress}}</div>
            </div>
            <div class="card-button-group">
                <button class="btn-modify" @click="fnUseAddress(userAddress)">선택</button>
            </div>
        </div>

        <div class="address-card" v-for="(item, index) in addressList" :key="item.addressId">
            <div class="card-detail-text">
                {{item.phone}} <br>
                {{item.fullAddress}}
            </div>
            <div class="card-button-group">
                <button class="btn-modify" @click="fnUseAddress(item.fullAddress, item.phone)">선택</button>
                <button class="btn-delete" @click="fnRemoveAddress(item.addressId)">삭제</button>
            </div>
        </div>
        
    </div>

</body>
</html>

<script>
    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
                // console.log(roadFullAddr);
                // console.log(addrDetail);
                // console.log(zipNo);

                window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
    }
    //주소 api 관련 여기까지

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                addressList: [
                    // 이미지 형태를 위해 임시 데이터 추가 (나중에 실제 데이터로 대체됨)
                    {addressId: 1, phone: '010-0000-0000', fullAddress: 'ㅇㅇ시 ㅇㅇ구 ㅇㅇ동 ㅇㅇㅇㅇㅇㅇㅇㅇ....'},
                    {addressId: 2, phone: '010-0000-0000', fullAddress: 'ㅇㅇ시 ㅇㅇ구 ㅇㅇ동 ㅇㅇㅇㅇㅇㅇㅇㅇ....'}
                ], // 기본 주소 이외에 구매자가 추가로 입력한 배송지 정보
                addr: "", //추가할 배송지 주소 

                //세션
                userPhone: "${sessionPhone}", //사용자의 기본 휴대폰 번호
                userAddress: "${sessionAddress}", //사용자의 기본 주소
                userId: "${sessionId}", //사용자 아이디

                //payment.jsp에서 넘겨받기
                orderIdList: [],

                //추가할 배송지 휴대폰 번호
                phone1: "",
                phone2: "",
                phone3: "",

                // 신규 배송지 입력 폼 표시 여부 (기본 true로 설정)
                showAddForm: true ,
                showAddrFrame: false // iframe 표시 여부

            };
        },
        methods: {
            // 함수(메소드) - (key : function())

            fnToggleAddrFrame: function(){
                this.showAddrFrame = !this.showAddrFrame;
            },

            // iframe에서 postMessage로 받은 결과 처리
            fnResult: function (roadFullAddr, addrDetail, zipNo) {
                this.addr = roadFullAddr + " " + addrDetail;
                this.showAddrFrame = false; // 닫기
            },
            //주소 api 사용하기 여기부터
            fnSearchAddr: function(){
                window.open("/user/addr.do", "addr", "width=500, height=500, top=100, left=900");
            },
            // fnResult: function (roadFullAddr, addrDetail, zipNo) {
            //         let self = this;
            //         self.addr = roadFullAddr;
            // },
            //주소 api 사용하기 여기까지

            // 신규 배송지 입력 폼 표시/숨김 토글
            fnToggleAddForm: function() {
                let self = this;
                self.showAddForm = !self.showAddForm;
            },
            
            //배송지 추가
            fnAddAddress: function(){
                let self = this;
                if (self.addr == "") {
                    alert("주소를 입력해주세요.");
                    return;
                }
                if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                    alert("휴대폰 형식이 맞지 않습니다.");
                    return;
                }

                let phone = self.phone1 + "-" + self.phone2 + "-" + self.phone3;

                let param = {
                    userId: self.userId,
                    phone: phone,
                    addr : self.addr
                };
                $.ajax({
                    url: "/payment/addAddress.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("배송지가 성공적으로 추가되었습니다!");
                        self.fnAddressList();
                        //self.showAddForm = false; // 저장 후 폼 숨기기
                    }
                });
            },

            //배송지 주소, 휴대폰 목록 (기본 정보 외에 추가한 것 출력)
            fnAddressList: function () {
                let self = this;
                let param = {
                    userId: self.userId
                };
                $.ajax({
                    url: "/payment/addressList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // console.log(data);
                        self.addressList = data.list;
                    }
                });
            },

            fnRemoveAddress: function(addressId){
                let self = this;
                let param = {
                    addressId : addressId
                };
                $.ajax({
                    url: "/payment/removeAddress.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("배송지가 삭제되었습니다.");
                        self.fnAddressList(); //주소 목록 출력(기본 주소 외에 추가 입력한 것)
                    }
                });
            },

            fnUseAddress: function(fullAddress, phone){
                let self = this;
                if (self.orderIdList.length === 0) {
                        alert("배송지를 선택할 주문서가 없습니다.");
                        return;
                }
                let param = {
                    fullAddress : fullAddress,
                    phone : phone,
                    orderIdList: JSON.stringify(self.orderIdList) //문자열로 전송
                };
                $.ajax({
                    url: "/payment/useAddress.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("배송지가 선택되었습니다.");
                        window.opener.location.reload(); // 부모페이지 새로고침
                        window.close();
                    }
                });
            }

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            //스크립트에서 vue 내부의 데이터 접근 (주소 api 관련)
            window.vueObj = this;
            window.addEventListener("message", (event) => {
                // 보안 검증 (내 도메인에서만 허용)
                if (event.origin !== window.location.origin) {
                    console.warn("외부 origin의 메시지는 무시", event.origin);
                    return;
                }

                // jusoPopup.jsp에서 보낸 데이터 받기
                if (event.data && event.data.type === "jusoResult") {
                    this.fnResult(event.data.roadFullAddr, event.data.addrDetail, event.data.zipNo);
                }
            });


            self.fnAddressList(); //주소 목록 출력(기본 주소 외에 추가 입력한 것)
            let str = "${orderIdList}";
             self.orderIdList = JSON.parse(str); //파싱을 해줘야 문자열을 리스트로 바꿀 수 있다.
            // console.log("self.orderIdList: " + self.orderIdList);
            // console.log("최종적으로 사용할 orderIdList 값은 => " + self.orderIdList);
        }
    });

    app.mount('#app');
</script>