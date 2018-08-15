<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<html>
<head>
<title>SELECT 操作</title>
</head>
<body>
<%
    response.setCharacterEncoding("UTF=8");
    response.setContentType("text/html;charset=UTF-8");
    String isbn = new String(request.getParameter("isbn").getBytes("iso-8859-1"), "utf-8");
%>

<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/douban?useUnicode=true&characterEncoding=utf-8"
     user="root"  password="123456"/>

<sql:query dataSource="${snapshot}" var="result">
SELECT * from books where isbn='<%=isbn%>';
</sql:query>
<h1>BOOK DETAILS</h1>
<table border="1" width="100%">
<tr>
   <th>ID</th>
   <th>书名</th>
   <th>作者</th>
   <th>评分</th>
   <th>标签</th>
   <th>简介</th>
</tr>
<c:forEach var="row" items="${result.rows}">
<tr>
   <td><c:out value="${row.isbn}"/></td>
   <td><c:out value="${row.title}"/></td>
   <td><c:out value="${row.author}"/></td>
   <td><c:out value="${row.score}"/></td>
   <td><c:out value="${row.tags}"/></td>
   <td><c:out value="${row.intro}"/></td>
</tr>
</c:forEach>
</table>

</body>
</html>