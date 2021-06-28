<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 화면 최적화 -->
<meta name="viewpoint" content="width-device-width" initial-scale="1">
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 웹 사이트 게시판</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;//1페이지부터 시작
		if (request.getParameter("pageNumber") != null) {//만약 페이지넘버가 파라미터로 넘어왔다면
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<!-- 네비게이션 -->
		<div class="navbar-header">
			<!-- 네비게이션 상단 부분 -->
			<!-- 네비게이션 상단 박스 영역 -->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<!-- 상단 바에 제목이 나타나고 클릭하면 main 페이지로 이동 -->
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<!-- 게시판 제목 이름 옆에 나타나는 메뉴 영역 -->
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span>
				</a> <!-- 드랍다운 아이템 영역 -->
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>

			<%
				} else {
			%>

			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span>
				</a> <!-- 드랍다운 아이템 영역 -->
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>

			<%		
				}
			%>

		</div>
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd;" >
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						String searchType = "";				
						ArrayList<Bbs> searchList = new ArrayList<Bbs>();
						BbsDAO bbsDAO = new BbsDAO();
	
						if (request.getParameter("searchType").equals("searchBbsID")) {
							searchType = request.getParameter("searchBlank");
							searchList = bbsDAO.getSearchByBbsID(searchType);	
						} else if (request.getParameter("searchType").equals("searchBbsTitle")) {
							searchType = request.getParameter("searchBlank");
							searchList = bbsDAO.getSearchByBbsTitle(searchType);	
						} else if (request.getParameter("searchType").equals("searchUserID")) {
							searchType = request.getParameter("searchBlank");
							searchList = bbsDAO.getSearchByUserID(searchType);		
						}
						
						
						for (int i = 0; i < searchList.size(); i++) {
					%>
					<tr>
						<td><%= searchList.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID=<%= searchList.get(i).getBbsID() %>"><%= searchList.get(i).getBbsTitle() %></a></td>
						<td><%= searchList.get(i).getUserID() %></td>
						<td><%= searchList.get(i).getBbsDate().substring(0, 11) + searchList.get(i).getBbsDate().substring(11, 13) + "시" + searchList.get(i).getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<%		
						}
					%>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary pull-right">게시판 이동</a>
		</div>
	</div>
	<!-- 부트스트랩 참조 영역 -->
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>