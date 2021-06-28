<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
</head>
<body>
	<%
		session.invalidate();//세션을 빼았는것 -> 로그아웃
	%>
	<script>
		location.href = "main.jsp";
	</script>

</body>
</html>