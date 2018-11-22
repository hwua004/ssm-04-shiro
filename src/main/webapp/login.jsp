<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录</title>
    <link rel="stylesheet" href="${path}/static/login/css/font-awesome.min.css">
    <link rel="stylesheet" href="${path}/static/login/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="${path}/static/login/css/demo.css">
    <link rel="stylesheet" type="text/css" href="${path}/static/login/css/login.css">
    <script type="text/javascript" src="${path}/static/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="${path}/static/js/jquery.cookie.js"></script>
    <script type="text/javascript">
        //当页面元素加载完成之后，即dom对象加载完成之后执行
        $(function(){
            var username=$.cookie("username");
            var password=$.cookie("password");
            var remember=$.cookie("remember");
            //alert(username+"-----"+password+"----"+remember);
            if(remember!=null){
                $("#username").val(username);
                $("#password").val(password);
                $("#remember").attr("checked","checked");
            }
        });

        function login() {
            var remember=$("#remember").is(":checked");
            var username = $("#username").val();
            var password = $("#password").val();
            if (username == "" || password == "") {
                alert("请填写用户名和密码");
                return;
            }

            $.ajax({
                url: "${path}/user/login",
                type: "post",
                dataType: "json",
                async: false,
                data: {
                    username: username,
                    password: password
                },
                success: function (result) {
                    console.log(result);
                    if (result.success) {
                        alert(result.info);
                        if(remember){
                            $.cookie("username",username,{expires:7});
                            $.cookie("password",password,{expires:7});
                            $.cookie("remember",remember,{expires:7});
                        }else{
                            $.cookie("username",null);
                            $.cookie("password",null);
                            $.cookie("remember",null);
                        }
                        window.location.href = "${path}/user/tomain";
                    } else {
                        alert(result.info);
                    }
                }
            });

        }


    </script>

</head>
<body>

<div class="demo" style="padding: 20px 0;">
    <div class="container">
        <div class="row">
            <div class="col-md-offset-3 col-md-6">
                <form class="form-horizontal">
                    <span class="heading">用户登录</span>
                    <div class="form-group">
                        <input type="text" class="form-control" id="username" placeholder="用户名或电子邮件">
                        <i class="fa fa-user"></i>
                    </div>
                    <div class="form-group help">
                        <input type="password" class="form-control" id="password" placeholder="密　码">
                        <i class="fa fa-lock"></i>
                        <a href="#" class="fa fa-question-circle"></a>
                    </div>
                    <div class="form-group">
                        <div class="main-checkbox">
                            <input type="checkbox" value="None" id="remember" name="remember">
                            <label for="remember"></label>
                        </div>
                        <span class="text">记住密码</span>
                        <button type="button" class="btn btn-default" onclick="login()">登录</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>

