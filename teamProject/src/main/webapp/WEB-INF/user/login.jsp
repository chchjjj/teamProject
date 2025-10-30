<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
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

        <!-- 향후 소셜 로그인 추가 필요 -->
        <div>
            <label>아이디 : <input v-model="userId"></label>
        </div>
        <div>
            <label>비밀번호 : <input type="password" v-model="userPass"></label>
        </div>
        <div>
            <button @click="fnLogin">로그인</button> 
            <button>카카오 로그인</button>
            <button>소셜 로그인</button>
            <a href="/user/join.do"><button>회원가입</button></a>
            <a href="/user/findId.do"><button>아이디 찾기</button></a>
            <a href="/user/newPwd.do"><button>비밀번호 찾기</button></a>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId: "",
                userPass: ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnLogin: function () {
                    let self = this;
                    let param = {
                        userId: self.userId,
                        userPass: self.userPass
                    };
                    $.ajax({
                        url: "/user/login.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert(data.msg);
                            if (data.result == "success") {
                                //location.href = data.url;
                                location.href="/main.do";
                            }
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