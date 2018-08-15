<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>图书详情</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
    <link rel="stylesheet" href="http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css">
    <script src="http://cdn.static.runoob.com/libs/angular.js/1.4.6/angular.min.js"></script>
    <script src="https://cdn.bootcss.com/angular-ui-bootstrap/1.3.2/ui-bootstrap-tpls.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
</head>

<body style="background:#424c50">
<%
    response.setCharacterEncoding("UTF=8");
    response.setContentType("text/html;charset=UTF-8");
    String isbn = new String(request.getParameter("isbn").getBytes("iso-8859-1"), "utf-8");
%>
    <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
         url="jdbc:mysql://localhost:3306/douban?useUnicode=true&characterEncoding=utf-8"
         user="root"  password="123456"/>

    <sql:update dataSource="${snapshot}" var="count">
    UPDATE books SET count = count+1 WHERE isbn='<%=isbn%>';
    </sql:update>
    <sql:query dataSource="${snapshot}" var="result">
    SELECT * from books where isbn='<%=isbn%>';
    </sql:query>

<style>
img {
    margin: 0cm 4cm;
    width : 220px;
    height: 250px;
}
#txt {

    font-size:24px;
    line-height:30px;
}

</style>
        <div>
            <table width="80%" frame=void rules=none align=center style="border-collapse:separate;border-spacing:10px 0px">
                    <tbody>
                    <c:forEach var="row" items="${result.rows}">
                        <tr style="font-weight:bold;font-size:40px;color:#789262">
                            <td>${row.title}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
            </table>
        </div>

        <div>
            <div style="float:left">
                <img src="https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1525775531&di=eaf07ce4695aff510a0faa26fee00aba&src=http://img1.gtimg.com/cul/pics/hv1/167/10/2017/131158142.jpg">`
            </div>
            <div style="float:left;color:#789262">
                <c:forEach var="row" items="${result.rows}">
                    <p id="txt">作者:${row.author}</p>
                    <p id="txt">评分:${row.score}</p>
                    <p id="txt">编号:${row.isbn}</p>
                </c:forEach>
            </div>
        </div>


        <div>
            <table width="80%" frame=void rules=none align=center style="border-collapse:separate;border-spacing:10px 20px">
                    <thead>
                     <tr style="font-size:22px;color:white">
                        <th width="50%"> 标签</th>
                     </tr>
                     </thead>
                     <tbody>
                     <c:forEach var="row" items="${result.rows}">
                     <tr style="font-size:18px;color:#789262">
                        <td>${row.tags}</td>
                     </tr>
                     </c:forEach>
                     </tbody>
            </table>
            <table width="80%" frame=void rules=none align=center style="border-collapse:separate;border-spacing:10px 20px">
                        <thead>
                         <tr style="font-size:22px;color:white">
                            <th width="100%"> 简介</th>
                         </tr>
                         </thead>
                         <tbody>
                         <c:forEach var="row" items="${result.rows}">
                         <tr style="font-size:18px;color:#789262">
                            <td>${row.intro}</td>
                         </tr>
                         </c:forEach>
                         </tbody>
            </table>
            <table width="80%" frame=void rules=none align=center style="border-collapse:separate;border-spacing:10px 20px">
                <thead>
                <tr style="font-size:22px;color:white">
                    <th width="100%"> 推荐</th>
                </tr>
                </thead>
            </table>
        </div>

<div ng-app="myApp" ng-controller="myCtrl">
        <div class="row marketing" >
            <table width="60%" frame=void rules=none align=center style="border-collapse:separate;border-spacing:10px">
                <thead>
                <tr bgcolor="#789262" style="font-size:20px;color:white">
                    <th width="60%"</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="page in records" style="font-size:18px;color:#789262">
                    <td><a href="javascript:void(0)" title="{{page.isbn}}" onclick="check(title)">《{{page.title}}》</a></td>
                    <td>{{page.author}}</td>
                </tr>
                </tbody>
            </table>
        </div>
</div>

<script>
    var app = angular.module('myApp', ['ui.bootstrap']);
    app.controller('myCtrl', function($scope, $http) {
                $scope.value = "<%=isbn%>";
                $scope.searchword = "";
                $scope.words = [];

                window.onload = function(){
                    $http({
                        method: "POST",
                        url: "http://localhost:8080/BooksRs/book-pages/getRecommend.do",
                        data: {word: $scope.value}
                        }).success(function (data){
                        $scope.records = data;
                        })
                };
    });

    function check(value){
          var url = 'details?isbn=';
           window.location.href=url+value;
    }

</script>
</body>
</html>
