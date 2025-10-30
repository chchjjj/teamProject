<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
        .phone {
                width: 40px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->

        <!-- 비밀번호 정규식 제대로 작동 안해서 주석 처리 -->
        <!-- 이메일 정규식 향후 추가 -->
        <!-- 문자 인증 기능 잠시 정지시킴 -->
        <!-- 파일 첨부는 나중에 구매자가 판매자로 회원가입할 때 사용하면 될 듯 -->
        <div>
            <label>아이디 :
                <input v-if="!userIdFlg" v-model="userId">
                <input v-else v-model="userId" disabled>
            </label>
            <button @click="fnCheck">중복체크</button>
         </div>
        <div>
            <label>비밀번호 : <input type="password" v-model="userPass"></label>
        </div>
        <div>
            <label>비밀번호 확인 : <input type="password" v-model="userPass2"></label>
        </div>
        <div>
            성함 : <input v-model="userName">
        </div>
        <div>
            이메일 : <input v-model="email">
        </div>
        <div>
            주소 : <input v-model="userAddr" disabled><button @click="fnAddr">주소검색</button>
        </div>
        <div>
            핸드폰번호 :
            <input class="phone" v-model="phone1"> -
            <input class="phone" v-model="phone2"> -
            <input class="phone" v-model="phone3">
        </div>

        <div v-if="!joinFlg">
            문자인증 : <input v-model="inputNum" :placeholder="timer">
            <template v-if="!smsFlg">
                <button @click="fnSms">인증번호 전송</button>
            </template>
            <template v-else>
                <button @click="fnSmsAuth">인증</button>
            </template>
        </div>
        <div v-else style="color : red;">
            문자인증이 완료되었습니다.
        </div>

        <!-- multiple 속성을 주면 다중 -->
        <!-- <div>
            파일첨부: <input type="file" id="file1" name="file1" accept=".jpg, .png">
        </div> -->


        <div>
            <button @click="fnJoin">회원가입</button>
        </div>
    </div>
</body>
</html>

<script>
    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
            console.log(roadFullAddr);
            console.log(addrDetail);
            console.log(zipNo);

            window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
    }
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId: "",
                userPass: "",
                userPass2: "",
                userAddr: "",
                userName: "",
                email: "",
                phone1: "",
                phone2: "",
                phone3: "",
                inputNum: "", //문자인증 번호
                smsFlg: false, //문자인증 메세지 전송 여부
                timer: "",
                count: 180,
                userIdFlg: false, //아이디 중복 체크 유무
                joinFlg: false, //문자 인증 유무
                ranStr: "" //문자 인증 번호
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
           fnCheck: function () {
                    let self = this;
                    let param = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/user/check.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "true") {
                                alert("이미 사용중인 아이디 입니다.");
                            }
                            else {
                                alert("사용 가능한 아이디 입니다.");
                                self.userIdFlg = true;
                            }
                        }
                    });
            },
            fnAddr: function () {
                //두 번째 인자가 팝업창의 이름
                window.open("/user/addr.do", "addr", "width=500, height=500, top=100, left=100");
            },
            fnResult: function (roadFullAddr, addrDetail, zipNo) {
                let self = this;
                self.userAddr = roadFullAddr;
            },
            fnSms: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/send-one",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if (data.res.statusCode == "2000") {
                            alert("문자 전송 완료");
                            self.ranStr = data.ranStr;
                            self.smsFlg = true;
                            self.fnTimer();
                        } else {
                            alert("잠시 후 다시 시도해주세요.");
                        }
                    }
                });
            },
            fnTimer: function () {
                let self = this;
                let interval = setInterval(() => {
                    if (self.count == 0) {
                        clearInterval(interval);
                        alert("시간이 만료되었습니다.");
                    } else {
                        let min = parseInt(self.count / 60);
                        let sec = self.count % 60;
                        min = min < 10 ? "0" + min : min;
                        sec = sec < 10 ? "0" + sec : sec;
                        self.timer = min + " : " + sec;

                        self.count--;
                    }
                }, 1000);
            },
            fnJoin: function () {
                let self = this;
                let regPassword = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,500}$/; //비밀번호 정규식 (영문 숫자 특수기호 조합 8자리 이상 500자리 이하)
                let regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; // 이메일 정규식
                let phone = self.phone1 + "-" + self.phone2 + "-" + self.phone3;

                if (self.userId.length < 5) {
                    alert("아이디는 5글자 이상이어야 합니다.");
                    return;
                }

                if (!self.userIdFlg) {
                    alert("아이디 중복 체크를 진행해주세요.");
                    return;
                }

                if(!regPassword.test(self.userPass)) {
                    alert('비밀번호 형식에 따라 정확히 입력해주세요');
                    return;
                }

                if (self.userPass != self.userPass2) {
                    alert("비밀번호를 다시 확인해주세요.");
                    return;
                }

                if (self.userName == "") {
                    alert("성함이 있어야 합니다.");
                    return;
                }

                if(!regEmail.test(self.email)) {
                    alert('이메일 형식에 따라 정확히 입력해주세요');
                    return;
                }

                if (self.userAddr == "") {
                    alert("주소가 있어야 합니다.");
                    return;
                }

                if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                    alert("휴대폰 형식이 맞지 않습니다.");
                    return;
                }

                //문자 인증 기능 잠시 정지 시킴

                //문자 인증이 완료되지 않으면 
                //회원가입 불가능(안내문구 출력)
                // if(!self.joinFlg){
                //     alert("문자 인증을 진행해주세요.");
                //     return;
                // }

                let param = {
                    userId: self.userId,
                    userPass: self.userPass,
                    userName: self.userName,
                    userAddr: self.userAddr,
                    phone: phone,
                    email: self.email
                };

                $.ajax({
                    url: "/user/join.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            alert("회원가입 완료");
                            var form = new FormData();
                            form.append("file1", $("#file1")[0].files[0]);
                            form.append("id", data.id); // 임시 pk
                            self.upload(form);
                            //location.href = "/member/login.do";
                        }
                        else {
                            alert("오류가 발생했습니다.");
                        }


                    }
                });
            },
                // 파일 업로드
            upload: function (form) {
                var self = this;
                $.ajax({
                    url: "/member/fileUpload.dox"
                    , type: "POST"
                    , processData: false
                    , contentType: false
                    , data: form
                    , success: function (data) {
                        console.log(data);
                    }
                });
            },
            fnSmsAuth: function () {
                let self = this;
                if (self.ranStr == self.inputNum) {
                    alert("문자인증이 완료되었습니다.");
                    self.joinFlg = true;
                } else {
                    alert("문자인증에 실패했습니다.");
                }
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;

            //스크립트에서 vue 내부의 데이터 접근
            window.vueObj = this;
        }
    });

    app.mount('#app');
</script>