<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
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
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <input type="text" ng-model="selected"  uib-typeahead="n for n in suggestWords($viewValue)"
                           typeahead-loading="loadingLocations" typeahead-no-results="noResults" class="form-control" style="height:45px;font-size:18px;color:#789262">
                    <i ng-show="loadingLocations" class="glyphicon glyphicon-refresh"></i>
                </div>


<div class="btn-group">
    <button type="button" class="btn btn-success dropdown-toggle btn-lg" data-toggle="dropdown" style="background:#789262;border-color:#789262">Search
        <span class="caret"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
        <li>
            <a href="#" ng-click="getTitlePages()">书名</a>
        </li>
        <li>
            <a href="#" ng-click="getAuthorPages()">作者</a>
        </li>
         <li>
             <a href="#" ng-click="getIsbnPages()">ISBN</a>
          </li>
    </ul>
</div>


            </div>
        </div>

        <div class="row marketing" >
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
            <div class="position " id="d1">
            <button ng-disabled="currentPage == 0" ng-click="currentPage=currentPage-1">
                    Previous
                </button>
                {{currentPage+1}}/{{numberOfPages()}}
                <button ng-disabled="currentPage >= data.length/pageSize - 1" ng-click="currentPage=currentPage+1">
                    Next
                </button>
                </div>
        </div>
    </div>
</div>

<script>
    var app = angular.module('myApp', ['ui.bootstrap']);
app.controller('myCtrl', function($scope, $http) {
                $scope.currentPage = 0;
                $scope.pageSize = 10;
                $scope.searchword = "";
                $scope.words = [];

               $scope.sites = [
        	    {site : "Title", function:"getTitlePages()"},
        	    {site : "Author", function:"getAuthorPages()"},
        	    {site : "Isbn", function:"getIsbnPages()"},
        	];


        $scope.getTitlePages = function(){
            $http({
                method: "POST",
                url: "http://localhost:8080/BooksYi/book-pages/getTitlePages.do",
                data: {word: $scope.selected}
            }).success(function (data){
                $scope.records = data;
            })
        };
        $scope.getAuthorPages = function(){
                    $http({
                        method: "POST",
                        url: "http://localhost:8080/BooksYi/book-pages/getAuthorPages.do",
                        data: {word: $scope.selected}
                    }).success(function (data){
                        $scope.records = data;
                    })
                };
         $scope.getIsbnPages = function(){
                    $http({
                        method: "POST",
                        url: "http://localhost:8080/BooksYi/book-pages/getIsbnPages.do",
                        data: {word: $scope.selected}
                    }).success(function (data){
                        $scope.records = data;
                    })
                };
                   $scope.numberOfPages=function(){
                    return Math.ceil($scope.records.length/$scope.pageSize);
                 }
            });


app.filter('startFrom', function() {
    return function(input, start) {
        start = +start; //parse to int
        return input.slice(start);
    }
});

function check(value){
                    var url = 'details?isbn=';
                    window.location.href=url+value;
                   }

</script>
</body>
</html>