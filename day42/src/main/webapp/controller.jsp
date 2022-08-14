<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="error/error.jsp" import="java.util.ArrayList,model.vo.*" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="mDAO" class="model.dao.MemberDAO" />
<jsp:useBean id="bDAO" class="model.dao.BoardDAO" />
<jsp:useBean id="bVO" class="model.vo.BoardVO" />
<jsp:setProperty property="*" name="bVO" />
<jsp:useBean id="mVO" class="model.vo.MemberVO" />
<jsp:setProperty property="*" name="mVO" />
<%
	

	String action=request.getParameter("action");//다른 페이지에서 전달된 액션 파라미터 값을 변수 action에 저장 한다
	System.out.println("로그: "+action); // 어떤 action 파라미터 값이 넘어온 것인지 확인 하기 위해
	
	if(action==null){
		response.sendRedirect("controller.jsp?action=main");
	}
	if(action.equals("login")){ // 로그인
		MemberVO member=mDAO.selectOne(mVO);
		if(member!=null){
			session.setAttribute("member", member);
			response.sendRedirect("controller.jsp?action=main");
		}
		else{
			response.sendRedirect("login.jsp");
		}
	}
	
	else if(action.equals("logout")){
		session.invalidate();
		response.sendRedirect("login.jsp");
	}
	else if(action.equals("reg")){ // 회원가입
		if(mDAO.insert(mVO)){
			response.sendRedirect("login.jsp");
		}
		else{
			throw new Exception("reg 오류");
		}
	}
	else if(action.equals("mypage")){ //마이페이지
		MemberVO member=(MemberVO)session.getAttribute("member");
	
		if(member!=null){
			request.setAttribute("data", member);
			pageContext.forward("mypage.jsp");
		}
		else{
			throw new Exception("mypage 오류");
		}
	}
	else if(action.equals("mdelete")){ // 회원탈퇴시 회원이 작성한 게시글을 함께 삭제
		MemberVO member =(MemberVO)session.getAttribute("member");
		if(member!=null && mDAO.delete(member)){
				bVO.setWriter(member.getMname());
				bDAO.delete_All(bVO);
				session.invalidate();
				response.sendRedirect("login.jsp");
		}
				 
		
		else{
			throw new Exception("delete 오류");
		}
	
		
	}
	
	else if(action.equals("mupdate")){ // 회원정보 변경
		if(mDAO.update(mVO)){
			bVO.setWriter(mVO.getMname());
			session.invalidate(); 
			response.sendRedirect("login.jsp");
		}
		else{
			throw new Exception("update 오류");
		}
	}
	else if(action.equals("main")){ // 글 목록 전체 출력
		ArrayList<BoardVO> datas=bDAO.selectAll(bVO);
		request.setAttribute("datas", datas);
		pageContext.forward("main.jsp"); 
	}
	else if(action.equals("board")){ // 글 정보 보기
		BoardVO data=bDAO.selectOne(bVO);
		if(data==null){
			response.sendRedirect("controller.jsp?action=main");
		}
		request.setAttribute("data", data);
		pageContext.forward("board.jsp");
	}
	else if(action.equals("insert")){ // 글 내용 등록하기
		if(bDAO.insert(bVO)){
			response.sendRedirect("controller.jsp?action=main");
		}
		else{
			throw new Exception("insert 오류");
		}
	}
	else if(action.equals("update")){ // 글 내용 변경하기
		
		if(bDAO.update(bVO)){
			response.sendRedirect("controller.jsp?action=main");
		}
		else{
			throw new Exception("update 오류");
		}
	}
	else if(action.equals("delete")){ // 글 내용 삭제하기
		if(bDAO.delete(bVO)){
			response.sendRedirect("controller.jsp?action=main");
		}
		else{
			throw new Exception("delete 오류");
		}
	}
	else{ // 위의 작성되어있는 if문을 모두 만족하지 못하고 else로 닿게 되면 다른 페이지에서 전달된 action 파라미터값이 올바르게 작성되지 않았기 떄문에 아래의 출력문이 나타나게 됩니다.
		out.println("<script>alert('action 파라미터 값이 올바르지 않습니다...');location.href='controller.jsp?action=main'</script>");	
	}
	
	
	
	

%>