package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn;//자바와 데이터베이스 연결
	private ResultSet rset;//결과값 받아오기 (블로그에서는 rs라고 선언)
	
	//기본 생성자
	//UserDAO가 실행되면 자동으로 생성되는 부분
	//메소드마다 반복되는 코드를 이곳에 넣으면 코드가 간소화된다.
	public BbsDAO() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			//Class.forName("org.mysql.jdbc.Driver");
			/*String dbURL = "jdbc:mysql://localhost:3306/kopoctc";//:3306 or 그냥 localhost
			String dbID = "root";
			String dbPassword = "kopoctc";*/
			conn = DriverManager.getConnection("jdbc:mysql://192.168.23.78:3306/kopoctc","root","kopoctc");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String sql = "select now()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			if (rset.next()) {
				return rset.getString(1);//오늘 날짜
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";//데이터베이스 오류
	}
	
	public int getNext() {
		String sql = "select bbsID from BBS order by bbsID desc";//글번호를 위함
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();
			if (rset.next()) {
				return rset.getInt(1) + 1;//글번호 + 1
			}
			return 1;//첫번째 게시물인 경우
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public int write (String bbsTitle, String userID, String bbsContent) {
		String sql = "insert into BBS values (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);//삭제가 안된 것이기 때문에 1
			return pstmt.executeUpdate();//업데이트 해줘야 올라감
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
		
	}
	
	public ArrayList<Bbs> getList(int pageNumber) {//페이징
		String sql = "select * from BBS where bbsID < ? and bbsAvailable = 1 order by bbsID desc limit 10";//1페이지에 10개씩
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);//getNext() 다음으로 작성될 글의 번호
			rset = pstmt.executeQuery();
			while (rset.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rset.getInt(1));
				bbs.setBbsTitle(rset.getString(2));
				bbs.setUserID(rset.getString(3));
				bbs.setBbsDate(rset.getString(4));
				bbs.setBbsContent(rset.getString(5));
				bbs.setBbsAvailable(rset.getInt(6));
				list.add(bbs);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;//데이터베이스 오류
	}
	
	public boolean nextPage(int pageNumber) {//페이징2
		String sql = "select * from BBS where bbsID < ? and bbsAvailable = 1 order by bbsID desc limit 10;";//1페이지에 10개씩
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);//getNext() 다음으로 작성될 글의 번호
			rset = pstmt.executeQuery();
			if (rset.next()) {//결과가 하나라도 존재한다면
				return true;//다음페이지로 넘어갈 수 있다
			}				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;//데이터베이스 오류		
	}
	
	public Bbs getBbs(int bbsID) {//게시글을 클릭했을 때 글의 내용 보기
		String sql = "select * from BBS where bbsID = ?;";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			rset = pstmt.executeQuery();
			if (rset.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rset.getInt(1));
				bbs.setBbsTitle(rset.getString(2));
				bbs.setUserID(rset.getString(3));
				bbs.setBbsDate(rset.getString(4));
				bbs.setBbsContent(rset.getString(5));
				bbs.setBbsAvailable(rset.getInt(6));
				return bbs;
			}				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {//게시글 수정 
		String sql = "update BBS set bbsTitle = ?, bbsContent = ? where bbsID = ?;";//특정한 ID에 해당하는 게시판 제목과 내용 수정
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();//업데이트 해줘야 올라감
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public int delete(int bbsID) {//게시글 삭제 (어떤 글인지 알기위해 bbsID를 받음)
		String sql = "update BBS set bbsAvailable = 0 where bbsID = ?;";//bbaAvailable = 0 : 존재 x , bbsAvailable = 1 : 존재 o
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();//업데이트 해줘야 올라감
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류			
	}
	
	public ArrayList<Bbs> getSearchByBbsID(String searchBbsID) {//글 검색 : 게시글 번호
		String sql = "select * from BBS where bbsID = ? and bbsAvailable = 1 order by bbsID desc limit 10";//1페이지에 10개씩
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(searchBbsID));//첫번쨰 물음표(1)에 들어갈 변수
			rset = pstmt.executeQuery();
			while (rset.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rset.getInt(1));
				bbs.setBbsTitle(rset.getString(2));
				bbs.setUserID(rset.getString(3));
				bbs.setBbsDate(rset.getString(4));
				bbs.setBbsContent(rset.getString(5));
				bbs.setBbsAvailable(rset.getInt(6));
				list.add(bbs);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;//데이터베이스 오류
	}
	
	public ArrayList<Bbs> getSearchByBbsTitle(String searchBbsTitle) {//글 검색 : 게시글 제목
		String sql = "select * from BBS where bbsTitle = ? and bbsAvailable = 1 order by bbsID desc limit 10;";//1페이지에 10개씩
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, searchBbsTitle);//첫번쨰 물음표(1)에 들어갈 변수
			rset = pstmt.executeQuery();
			while (rset.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rset.getInt(1));
				bbs.setBbsTitle(rset.getString(2));
				bbs.setUserID(rset.getString(3));
				bbs.setBbsDate(rset.getString(4));
				bbs.setBbsContent(rset.getString(5));
				bbs.setBbsAvailable(rset.getInt(6));
				list.add(bbs);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;//데이터베이스 오류
	}
	
	public ArrayList<Bbs> getSearchByUserID(String searchUserID) {//글 검색 : 게시글 제목
		String sql = "select * from BBS where userID = ? and bbsAvailable = 1 order by bbsID desc limit 10";//1페이지에 10개씩
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, searchUserID);//첫번쨰 물음표(1)에 들어갈 변수
			rset = pstmt.executeQuery();
			while (rset.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rset.getInt(1));
				bbs.setBbsTitle(rset.getString(2));
				bbs.setUserID(rset.getString(3));
				bbs.setBbsDate(rset.getString(4));
				bbs.setBbsContent(rset.getString(5));
				bbs.setBbsAvailable(rset.getInt(6));
				list.add(bbs);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;//데이터베이스 오류
	}
	
	
}	