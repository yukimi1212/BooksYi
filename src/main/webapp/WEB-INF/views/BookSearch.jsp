<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>图书搜索</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css">
    <script src="http://cdn.static.runoob.com/libs/angular.js/1.4.6/angular.min.js"></script>

    <script src="https://cdn.bootcss.com/angular-ui-bootstrap/1.3.2/ui-bootstrap-tpls.js"></script>
    	<link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
	<script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>


	<style type="text/css">
    .position{
      text-align:right;
      position:absolute;
      right: 40%;
      bottom: 0%;
      margin-bottom:0px;
      margin-right:150px;
      font-size:18px;
    }


    </style>

</head>
<body style="background:#424c50">

<div ng-app="myApp" ng-controller="myCtrl">
    <div class="container">
        <div class="jumbotron" style="background:#424c50">
            <div class="row">

            <div class="col-md-6">
                <input type="text" ng-model="selected"  uib-typeahead="n.title as n.title+'<'+n.score+'>' for n in suggestWords($viewValue)"
                           typeahead-loading="loadingLocations" typeahead-no-results="noResults" class="form-control" style="height:45px;font-size:18px;color:#789262">
                <i ng-show="loadingLocations" class="glyphicon glyphicon-refresh"></i>
            </div>

            <div class="btn-group">
                <button type="button" class="btn btn-success dropdown-toggle btn-lg" data-toggle="dropdown" style="background:#789262;border-color:#789262">Search
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu">
                    <li>
                    <a href="#" ng-click="getTitlePages();getNum();getTime()">书名</a>
                    </li>
                    <li>
                     <a href="#" ng-click="getAuthorPages();getNum();getTime()">作者</a>
                    </li>
                    <li>
                    <a href="#" ng-click="getIsbnPages();getNum();getTime()">ISBN</a>
                    </li>
                 </ul>
            </div>
        </div>

        <div class="searchword">
            <table width="50%" frame=void rules=none align=left style="border-collapse:separate;border-spacing:10px">
                <tbody>
                    <tr>
                    <td ng-repeat="hot in list" style="font-size:18px;color:#fff">
                        <a ng-click="hotsearch(hot.type,hot.word);getNum();getTime()">#{{hot.word}}</a>
                    </td>
                    </tr>
                </tbody>
            </table>
         </div>
    </div>

        <div class="row marketing" >
            <%//<p style="font-size:12px;color:#789262">共查找到{{num}}个结果，耗时{{time}}ms</p>%>
            <table width="60%" frame=void rules=none align=center style="float:left;border-collapse:separate;border-spacing:10px">
                <thead>
                <tr bgcolor="#789262" style="font-size:20px;color:white">
                    <th width="60%"</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="page in records | startFrom:currentPage*pageSize | limitTo:pageSize" style="font-size:18px;color:#789262">
                    <td><a href="javascript:void(0)" title="{{page.isbn}}" onclick="check(title)">《{{page.title}}》</a></td>
                    <td>{{page.author}}</td>
                </tr>
                </tbody>
            </table>
            <div class="position " id="d1" style="font-size:20px;color:white">
                <button class="btn btn-success" ng-disabled="currentPage == 0" ng-click="currentPage=currentPage-1">
                    Previous
                </button>
                {{currentPage+1}}/{{numberOfPages()}}
                <button class="btn btn-info" ng-disabled="currentPage >= records.length/pageSize - 1" ng-click="currentPage=currentPage+1">
                    Next
                </button>
            </div>
            <table width="25%" frame=void rules=none style="float:right;border-collapse:separate;border-spacing:10px">
                <thead>
                <tr bgcolor="#424c50" style="font-size:20px;color:white">
                    <th><a ng-click="getListByHot()">热门</a>|<a ng-click="getListByScore()">高分</a></th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="book in books" style="font-size:18px;color:#789262">
                    <td><a href="javascript:void(0)" title="{{book.isbn}}" onclick="check(title)">《{{book.title}}》</a></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    var app = angular.module('myApp', ['ui.bootstrap']);
    app.controller('myCtrl', function($scope, $http) {
        $scope.num = 0;
        $scope.time = 0;
        $scope.currentPage = 0;
        $scope.pageSize = 10;
        $scope.searchword = "";
        $scope.words = [];

        window.onload = function() {
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getSearchwords.do",
                data: {word: null}
            }).success(function (data){
                $scope.list = data;
            })
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getListByHot.do",
                data: {word: null}
            }).success(function (data){
                $scope.books = data;
            })
        };

        $scope.getNum = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getNum.do",
                data: {word: null}
            }).success(function (data){
                $scope.num = data;
            })
        }
        $scope.getTime = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getTime.do",
                data: {word: null}
            }).success(function (data){
                $scope.time = data;
            })
        }
        $scope.getListByHot = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getListByHot.do",
                data: {word: null}
            }).success(function (data){
                $scope.books = data;
            })
        };
        $scope.getListByScore = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getListByScore.do",
                data: {word: null}
            }).success(function (data){
                $scope.books = data;
            })
        };
        $scope.getTitlePages = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getTitlePages.do",
                data: {word: $scope.selected}
            }).success(function (data){
                $scope.records = data;
            })
        };
        $scope.getAuthorPages = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getAuthorPages.do",
                data: {word: $scope.selected}
            }).success(function (data){
                $scope.records = data;
            })
        };

        $scope.getIsbnPages = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksRs/book-pages/getIsbnPages.do",
                data: {word: $scope.selected}
            }).success(function (data){
                $scope.records = data;
            })
        };

        $scope.numberOfPages=function(){
            return Math.ceil($scope.records.length/$scope.pageSize);
        };

        $scope.suggestWords = function(searchword) {
            return $http.post('/BooksRs/book-pages/suggestWord.do', {
            word: searchword
            })
            .then(function (response) {
                return response.data;
            });
        };
        $scope.hotsearch = function(type,word){
            if(type.match("title") != null){
                $http({
                    method: "POST",
                    url: "http://localhost:8080/BooksRs/book-pages/getTitlePages.do",
                    data: {word: word}
                }).success(function (data){
                    $scope.records = data;
                })
            }
            else{
                $http({
                    method: "POST",
                    url: "http://localhost:8080/BooksRs/book-pages/getAuthorPages.do",
                    data: {word: word}
                }).success(function (data){
                    $scope.records = data;
                })
            }
       }

    });
    app.filter('startFrom', function() {
        return function(input, start) {
            start = +start; //parse to int
            return input.slice(start);
        }
    });
    function check(value){
        var url = 'http://localhost:8080/BooksRs/book-pages/details?isbn=';
        window.open(url+value);
    }
</script>
</body>
</html>