<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.vo.BoardVO,java.util.ArrayList" %>
<jsp:useBean id="datas" class="java.util.ArrayList" scope="request" />
<jsp:useBean id="member" class="model.vo.MemberVO" scope="session" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<body>
<script type="text/javascript">
	function check(){
		ans=prompt('비밀번호를 입력하세요.');
		if(ans=='<%=member.getMpw()%>'){
			location.href="controller.jsp?action=mypage";
		}
	}
</script>
<% if(member.getMid()!=null){
	%>
<h3><a href="javascript:check()"><%=member.getMname()%></a>님, 반갑습니다! :D</h3>
<h5>[등급:<%=member.getRole()%>]</h5>
<button type="button" onclick="location.href='controller.jsp?action=logout'">로그아웃</button>
<br>
<br>
<% 
}
else{
	%>
	<h3> 방문자님, 반갑습니다!!</h3>
<%
}
%>
<form action="controller.jsp" method="post">
<input type="hidden" name="action" value="main">
	<table border="1">
         <tr>
            <td><select name="searchCondition">
            <option value="TITLE">제목</option>
            <option value="WRITER">작성자</option>
            </select></td>
            <td><input type="text" name="searchContent" required></td>
         </tr>
         <tr>
            <td colspan="2" align="left">
            <input type="submit" value="검색하기"><input type="button" value="새로고침" onclick="location.href='controller.jsp?action=main'">
            </td>
         </tr>
      </table>
</form>
<hr>
<%
	if(datas.size()!=0){
		
%>
<table border="2">
	<tr>
		<th>번 호</th><th>제 목</th><th>내용</th><th>작성자</th>
	</tr>
<%	
	for(BoardVO v:(ArrayList<BoardVO>)datas){
%>
	<tr>
		<th><a href="controller.jsp?action=board&bid=<%=v.getBid()%>"><%=v.getBid()%></a></th>
		<td><%=v.getTitle()%></td>
		<td><%=v.getContent()%></td>
		<td><%=v.getWriter()%></td>
	</tr>
<%
		}
%>
	</table>
	<% }
	else{
		%>
		<h3>검색한 게시물이 존재하지 않습니다.</h3>
		
<% 			
	}
%>

<hr>

<% if(member.getMid()!=null){
	%>
<button type="button" onclick="location.href='form.jsp'">글 작성하기</button>
<% 
}
else{
%>
	<button type="button" onclick="location.href='login.jsp'">로그인</button>
	<h5>로그인 후 게시글 등록이 가능합니다.</h5>
<% 
}
%>	
	



</body>
</html>
