<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기</title>
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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            성함 : <input v-model="userName">
        </div>
        <div>
            핸드폰번호 :
            <input class="phone" v-model="phone1"> -
            <input class="phone" v-model="phone2"> -
            <input class="phone" v-model="phone3">
        </div>

        <!-- 최종본에서 주석 해제할 것 여기부터 -->
        <!-- <div v-if="!smsFlg">
            <template v-if="!sendMessageFlg">
                <button @click="fnSendSms">인증</button>
            </template>
            <template v-else>
                문자인증 : <input v-model="inputNum" :placeholder="timer">
                <button @click="fnSmsAuth">확인</button>
            </template>
        </div>
        <div v-else>
            {{userName}}님의 아이디는 
            {{info.userId}}
            입니다.
        </div> -->
        <!-- 여기까지 -->
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                info: {},
                userName: "",
                phone1: "",
                phone2: "",
                phone3: "",
                inputNum: "", //문자인증 번호
                sendMessageFlg: false, //문자인증 메세지 전송 여부
                timer: "",
                count: 180,
                smsFlg: false, //문자 인증 유무
                ranStr: "" //문자 인증 번호
            };
        },
        methods: {
            // 함수(메소드) - (key : function())

            fnSendSms: function () {
                let self = this;
                let phone = self.phone1 + self.phone2 + self.phone3;
                console.log(phone);
                let param = {
                    phone : phone
                };
                $.ajax({
                    url: "/send-one",
                    dataType: "json",
                    type: "POST",
                    data: JSON.stringify(param), //에러 잡으려고 수정함
                    contentType: "application/json", //에러 잡으려고 추가함
                    success: function (data) {
                        console.log(data);
                        if (data.res.statusCode == "2000") {
                            alert("문자 전송 완료");
                            self.ranStr = data.ranStr;
                            self.sendMessageFlg = true;
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
            fnSmsAuth: function () {
                let self = this;
                if(!self.sendMessageFlg){
                    alert("문자 인증을 진행해주세요.");
                    return;
                }
                if (self.ranStr == self.inputNum) {
                    alert("문자인증이 완료되었습니다.");
                    self.smsFlg = true;
                    self.fnFind(); //db에서 id 가져오는 함수 실행
                } else {
                    alert("문자인증에 실패했습니다.");
                }
            },
            fnFind: function(){
                let self = this;
                let phone = self.phone1 + "-" + self.phone2 + "-" + self.phone3;
                let param = {
                    phone: phone,
                    userName: self.userName
                };
                $.ajax({
                    url: "/user/findId.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                    }
                });
            }
            
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>