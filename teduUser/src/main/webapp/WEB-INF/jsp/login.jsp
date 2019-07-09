<%--
  Created by IntelliJ IDEA.
  User: lulu
  Date: 2019-07-02
  Time: 17:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@include file="header.jsp"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>达内商城学子登陆页面</title>
    <link href="<%=ctxPath%>/css/header.css" rel="stylesheet"/>
    <link href="<%=ctxPath%>/css/footer.css" rel="stylesheet"/>
    <link href="<%=ctxPath%>/css/animate.css" rel="stylesheet"/>
    <link href="<%=ctxPath%>/css/login.css" rel="stylesheet"/>
</head>
<body>
<!-- 页面顶部-->
<header id="top">
    <div class="top">
        <img src="<%=ctxPath%>/img/header/logo.png" alt=""/>
        <span>欢迎登录</span>
    </div>
</header>
<div id="container">
    <div id="cover" class="rt">
        <form id="fm-login" name="form1" method="post" action="<%=ctxPath%>/login.do" >
            <div class="txt">
                <p>登录学子商城
                    <span>
                        <a href="<%=ctxPath%>/register.do">新用户注册</a>
                    </span>
                </p>
                <div class="text">
                    <input type="text" placeholder="请输入您的用户名" name="uname" id="uname" required>
                    <span></span>
                </div>

                <div class="text">
                    <input type="password" id="upwd" placeholder="请输入您的密码" name="upwd" required minlength="6" maxlength="15">
                    <span></span>
                </div>
                <div class="chose">

                </div>
                <input class="button_login" type="submit" value="登录" id="bt-login" />
            </div>
        </form>
    </div>
</div>
<!--错误提示-->
<div id="showResult"></div>
<!-- 品质保障，私人定制等-->
<div id="foot_box">
    <div class="icon1 lf">
        <img src="<%=ctxPath%>/img/footer/icon1.png" alt=""/>

        <h3>品质保障</h3>
    </div>
    <div class="icon2 lf">
        <img src="<%=ctxPath%>/img/footer/icon2.png" alt=""/>

        <h3>私人定制</h3>
    </div>
    <div class="icon3 lf">
        <img src="<%=ctxPath%>/img/footer/icon3.png" alt=""/>

        <h3>学员特供</h3>
    </div>
    <div class="icon4 lf">
        <img src="<%=ctxPath%>/img/footer/icon4.png" alt=""/>

        <h3>专属特权</h3>
    </div>
</div>
<!-- 页面底部-->
<div class="foot_bj">
    <div id="foot">
        <div class="lf">
            <p class="footer1"><img src="<%=ctxPath%>/img/footer/tedu.png" alt="" class=" footLogo"/></p>
            <p class="footer2"><img src="<%=ctxPath%>/img/footer/footerFont.png"alt=""/></p>
            <!-- 页面底部-备案号 #footer -->
            <div class="record">
                2001-2016 版权所有 京ICP证8000853号-56
            </div>
        </div>
        <div class="foot_left lf" >
            <ul>
                <li><a href="#"><h3>买家帮助</h3></a></li>
                <li><a href="#">新手指南</a></li>
                <li><a href="#">服务保障</a></li>
                <li><a href="#">常见问题</a></li>
            </ul>
            <ul>
                <li><a href="#"><h3>商家帮助</h3></a></li>
                <li><a href="#">商家入驻</a></li>
                <li><a href="#">商家后台</a></li>
            </ul>
            <ul>
                <li><a href="#"><h3>关于我们</h3></a></li>
                <li><a href="#">关于达内</a></li>
                <li><a href="#">联系我们</a></li>
                <li>
                    <img src="<%=ctxPath%>/img/footer/wechat.png" alt=""/>
                    <img src="<%=ctxPath%>/img/footer/sinablog.png" alt=""/>
                </li>
            </ul>
        </div>
        <div class="service">
            <p>达内商城客户端</p>
            <img src="<%=ctxPath%>/img/footer/ios.png" class="lf">
            <img src="<%=ctxPath%>/img/footer/android.png" alt="" class="lf"/>
        </div>
        <div class="download">
            <img src="<%=ctxPath%>/img/footer/erweima.png">
        </div>
    </div>
</div>
<script src="<%=ctxPath%>/js/jquery-3.1.1.min.js"></script>
<script>
    $("#uname").blur(function(){
        var data = $("#uname").val();
        if (data == null || data == "") {
            $("#showResult").text("用户名不能为空！");
            $("#showResult").css("color","red");
            return false;
        }
        $.ajax({
            type:"POST",
            url:"unameCheck.action",
            data:"uname="+data,
            beforeSend:function(XMLHttpRequest)
            {
                $("#showResult").text("正在查询");

            },
            success:function(msg)
            {
                if(msg ==="yes"){
                    $("#showResult").text("");
                }else if(msg === 'no'){
                    $("#showResult").text("该用户不存在");
                    $("#showResult").css("color","red");
                }
            },
            error:function()
            {
                //错误处理
                $("#showResult").text("系统异常！");
                $("#showResult").css("color","red");
            }
        });
    });
    /*$('#bt-login').click(function(){
        window.location.href =  "<%=ctxPath%>/login.do";
        //读取用户的输入——表单序列化
        var inputData = $('#fm-login').serialize();
        // alert(inputData);
        //异步提交请求，进行验证
        $.ajax({
            async: true,
            type: 'POST',
            url: 'login.action',
            data: inputData,
            success: function(txt, msg, xhr){
                // alert("*"+txt+"*");
                if(txt=='yes'){  //登录成功
                    var loginName = $('[name="uname"]').val();
                    console.log(loginName);
                    window.location.href =  "index.html";
                }else{ //登录失败
                    $('#showResult').html('登录失败！');
                }
            }
        });
    });*/
</script>
</body>
</html>

