<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="data" class="model.vo.BoardVO" scope="request" />
<jsp:useBean id="member" class="model.vo.MemberVO" scope="session" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세페이지</title>
</head>
<body>
<script type="text/javascript">
	function del(){
		ans=confirm('정말 삭제할까요?');
		if(ans==true){
			document.bForm.action.value="delete";
			document.bForm.submit();
		}
		else{
			return;
		}
	}
	
</script>

<form name="bForm" action="controller.jsp" method="post">
	 <input type="hidden" name="action" value="update">
	<input type="hidden" name="bid" value="<%=data.getBid()%>">
	
	<table border="1">
		<tr>
			<td>제목</td>
			<td><input id="title" type="text" name="title" value="<%=data.getTitle()%>" required></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><input id="content" type="text" name="content" value="<%=data.getContent()%>" required></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><input type="text" name="writer" value="<%=member.getMname()%>" required readonly></td>
		</tr>
		<%
		if( (member.getMname()!=null && (data.getWriter().equals(member.getMname()) ||  (member.getRole().equals("ADMIN"))))){
		%>
		<tr>
			<td colspan="2" align="right">
				<input type="submit" value="변경하기" >&nbsp; <input type="button" value="삭제하기" onClick="del()">
			</td>
		</tr>
			<%
				}
			%>
		
	</table>
</form>
<hr>
<input type="button" value="메인으로 돌아가기" onclick="location.href='controller.jsp?action=main'">

</body>
</html>