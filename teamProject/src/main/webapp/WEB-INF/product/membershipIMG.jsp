<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>멤버십 사진 적용</title>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
           
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>

            <div id="app">
                
            </div>

            <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userId: "${sessionId}",
                };
            },
            methods: {
               
            },
            mounted() {
                let self = this;
            }
        });

        app.mount('#app');
    </script>