<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.Bbs" %>
<%@ page import = "bbs.BbsDAO" %>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 화면 최적화 -->
<meta name="viewpoint" content="width-device-width" initial-scale="1">
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 웹 사이트 게시판</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int bbsID = 0;//게시판 글을 클릭했을 때 불러오기 구현을 위함
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) {//번호가 존재해야만 글을 볼 수 있기 때문에
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);//해당 글을 가져오기 위함
	%>
	<nav class="navbar navbar-default"><!-- 네비게이션 -->
		<div class="navbar-header"><!-- 네비게이션 상단 부분 -->
			<!-- 네비게이션 상단 박스 영역 -->
			<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
					aria-expanded="false">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
			</button>
			<!-- 상단 바에 제목이 나타나고 클릭하면 main 페이지로 이동 -->
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<!-- 게시판 제목 이름 옆에 나타나는 메뉴 영역 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">접속하기<span class="caret"></span>
					</a>
							<!-- 드랍다운 아이템 영역 -->
							<ul class="dropdown-menu">
								<li><a href="login.jsp">로그인</a></li>
								<li><a href="join.jsp">회원가입</a></li>
							</ul>
				</li>				
			</ul>			
			
			<%
				} else {
			%>
			
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">회원관리<span class="caret"></span>
					</a>
							<!-- 드랍다운 아이템 영역 -->
							<ul class="dropdown-menu">
								<li><a href="logoutAction.jsp">로그아웃</a></li>
							</ul>
				</li>				
			</ul>
			
			<%		
				}
			%>
			
		</div>
	</nav>
	<div class="container">
		<div class="row">			
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align:center;">게시판 글 보기</th>
		
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;">글 제목</td>
							<td colspan="2"><%= bbs.getBbsTitle() %></td>		
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2"><%= bbs.getUserID() %></td>		
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) +bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>		
						</tr>	
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align:left;"><%= bbs.getBbsContent() %></td>		
						</tr>													
					</tbody>	
				</table>
				<a href="bbs.jsp" class="btn btn btn-primary">목록</a>
				<%
					if(userID != null && userID.equals(bbs.getUserID())) {
				%>
					<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>		
				<%
				}
				%>
		</div>
	</div>
	<!-- 부트스트랩 참조 영역 -->
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>