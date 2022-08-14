package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.util.JDBCUtil;
import model.vo.BoardVO;

public class BoardDAO {
	Connection conn;
	PreparedStatement pstmt;
	final String sql_selectOne="SELECT * FROM BOARD WHERE BID=?"; //상세페이지
	final String sql_selectAll_T="SELECT BID, TITLE, CONTENT, MNAME FROM BOARD LEFT OUTER JOIN MEMBER ON BOARD.WRITER=MEMBER.MID WHERE TITLE LIKE '%'||?||'%'  ORDER BY BID ASC";//검색 혹은 모든 게시물 출력
	final String sql_selectAll_W="SELECT BID, TITLE, CONTENT, MNAME FROM BOARD LEFT OUTER JOIN MEMBER ON BOARD.WRITER=MEMBER.MID WHERE WRITER LIKE '%'||?||'%' ORDER BY BID ASC";//검색 혹은 모든 게시물 출력
	final String sql_insert="INSERT INTO BOARD VALUES((SELECT NVL(MAX(BID),0)+1 FROM BOARD),?,?,?)"; // 게시물 작성	
	final String sql_update="UPDATE BOARD SET TITLE=?,CONTENT=? WHERE BID=?"; //게시물 변경
	final String sql_delete="DELETE FROM BOARD WHERE BID=?";//게시물 삭제
	final String sql_delete_All="DELETE FROM BOARD WHERE WRITER=?";//게시물 삭제
	
	public BoardVO selectOne(BoardVO vo) {
		System.out.println("BoardDAO Board의 로그: "+vo);
		conn=JDBCUtil.connect();
		try {
			pstmt=conn.prepareStatement(sql_selectOne);
			pstmt.setInt(1, vo.getBid());
			ResultSet rs=pstmt.executeQuery();
			if(rs.next()) {
				BoardVO data=new BoardVO();
				data.setBid(rs.getInt("BID"));
				data.setContent(rs.getString("CONTENT"));
				data.setTitle(rs.getString("TITLE"));
				data.setWriter(rs.getString("WRITER"));
				return data;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCUtil.disconnect(pstmt, conn);
		}		
		return null;
	}
	public ArrayList<BoardVO> selectAll(BoardVO vo){
		System.out.println("BoardDAO selectAll의 로그: "+vo);
		ArrayList<BoardVO> datas=new ArrayList<BoardVO>();
		conn=JDBCUtil.connect();
		try {
			if(vo.getSearchCondition()==null) {
				vo.setSearchCondition("TITLE");
			}
			if(vo.getSearchContent()==null) {
				vo.setSearchContent("");
			}
			String sql_selectAll=sql_selectAll_T;
			if(vo.getSearchCondition().equals("WRITER")) {
			sql_selectAll=sql_selectAll_W;
				
			}
			
			pstmt=conn.prepareStatement(sql_selectAll);
			pstmt.setString(1, vo.getSearchContent());
			
			ResultSet rs=pstmt.executeQuery();
			while(rs.next()) {
				BoardVO data=new BoardVO();
				data.setBid(rs.getInt("BID"));
				data.setContent(rs.getString("CONTENT"));
				data.setTitle(rs.getString("TITLE"));
				data.setWriter(rs.getString("MNAME"));
				datas.add(data);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCUtil.disconnect(pstmt, conn);
		}		
		return datas;
	}
	public boolean insert(BoardVO vo) {
		System.out.println("BoardDAO insert의 로그: "+vo);
		conn=JDBCUtil.connect();
		try {
			pstmt=conn.prepareStatement(sql_insert);
			pstmt.setString(1, vo.getTitle());
			pstmt.setString(2, vo.getContent());
			pstmt.setString(3, vo.getWriter());
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			JDBCUtil.disconnect(pstmt, conn);
		}
		return true;
	}
	public boolean update(BoardVO vo) {
		System.out.println("BoardDAO update의 로그: "+vo);
		conn=JDBCUtil.connect();
		try {
			pstmt=conn.prepareStatement(sql_update);
			pstmt.setString(1, vo.getTitle());
			pstmt.setString(2, vo.getContent());
			pstmt.setInt(3,vo.getBid());
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			JDBCUtil.disconnect(pstmt, conn);
		}
		return true;
	}
	public boolean delete(BoardVO vo) {
		System.out.println("BoardDAO delete의 로그: "+vo);
		conn=JDBCUtil.connect();
		try {
			pstmt=conn.prepareStatement(sql_delete);
			pstmt.setInt(1,vo.getBid());
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			JDBCUtil.disconnect(pstmt, conn);
		}
		return true;
	}
	public boolean delete_All(BoardVO vo) {
		System.out.println("BoardDAO delete의 로그: "+vo);
		conn=JDBCUtil.connect();
		try {
			pstmt=conn.prepareStatement(sql_delete_All);
			pstmt.setString(1,vo.getWriter());
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			JDBCUtil.disconnect(pstmt, conn);
		}
		return true;
	}
}
