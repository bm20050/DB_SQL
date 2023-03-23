package JDBCProject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import com.mysql.cj.protocol.x.SyncFlushDeflaterOutputStream;

public class DBConnection {

	static Connection conn = null;
	static PreparedStatement psmt = null;
	static ResultSet rs = null;
	
	public static void create(Connection conn) {
		try {
			Scanner sc1 = new Scanner(System.in);
			Scanner sc2 = new Scanner(System.in);
			Scanner sc3 = new Scanner(System.in);
			// String query = "insert into user (id, name, email) values (?,?,?)";
			// psmt = conn.prepareStatement(query);
			
			psmt = conn.prepareCall("{call InsertUser(?,?,?)}");
			
			System.out.println("추가할 사용자의 ID를 입력하세요.");
			psmt.setString(1, sc1.nextLine());
			System.out.println("추가할 사용자의 이름을 입력하세요.");
			psmt.setString(2, sc2.nextLine());
			System.out.println("추가할 사용자의 email을 입력하세요.");
			psmt.setString(3, sc3.nextLine());

			psmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("중복된 ID의 사용자 입니다.");
		}
	}

	public static void read(Connection conn) throws SQLException {
		// psmt = conn.prepareStatement("select * from user");
		psmt = conn.prepareCall("{call SearchUser()}");
		
		rs = psmt.executeQuery();
		while (rs.next()) {
			String uid = rs.getString("uid");
			String uname = rs.getString("uname");
			String email = rs.getString("email");
			String rdate = rs.getString("rdate");
			System.out.println("UID: " + uid + ", 이름: " + uname + ", email: " + email + " 가입날짜: " + rdate);
		}
	}

	public static void sread(Connection conn) {
		try {
			Scanner sc = new Scanner(System.in);

			// String query = "select * from user where id = ?";
			// psmt = conn.prepareStatement(query);
			
			psmt = conn.prepareCall("{call SearchUserOne(?)}");
			System.out.println("검색할 사용자의 ID를 입력하세요.");
			psmt.setString(1, sc.nextLine());

			rs = psmt.executeQuery();

			
			while (rs.next()) {
				String uid = rs.getString("uid");
				String uname = rs.getString("uname");
				String email = rs.getString("email");
				String rdate = rs.getString("rdate");
				System.out.println("UID: " + uid + ", 이름: " + uname + ", email: " + email + " 가입날짜: " + rdate);
			}
			
		} catch (Exception e) {
			System.out.println("존재하지 않는 사용자입니다.");
			e.printStackTrace();
		}
	}

	public static void update(Connection conn) {

		try {
			Scanner sc1 = new Scanner(System.in);
			Scanner sc2 = new Scanner(System.in);
			Scanner sc3 = new Scanner(System.in);

			// String query = "update user set name = ?, email = ? where id = ?";
			// psmt = conn.prepareStatement(query);

			psmt = conn.prepareCall("{call UpdateUser(?,?,?)}");
			System.out.println("수정할 사용자의 ID를 입력하세요.");
			psmt.setString(1, sc1.nextLine());
			System.out.println("사용자의 이름을 입력하세요.");
			psmt.setString(2, sc2.nextLine());
			System.out.println("사용자의 email을 입력하세요.");
			psmt.setString(3, sc3.nextLine());

			psmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("존재하지 않는 사용자입니다.");
			e.printStackTrace();
		}
	}

	public static void delete(Connection conn) {
		try {
			Scanner sc = new Scanner(System.in);

			// String query = "delete from user where id = ?";
			// psmt = conn.prepareStatement(query);
			
			psmt = conn.prepareCall("{call DeleteUser(?)}");
			
			System.out.println("삭제할 사용자의 ID를 입력하세요.");
			psmt.setString(1, sc.nextLine());

			psmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("존재하지 않는 사용자입니다.");
		}
	}

	public static void main(String[] args) {
		// 드라이버 로딩
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("JDBC드라이버 로딩 오류");
			e.printStackTrace();
			return;
		}

		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pnusw45", "root", "1234");

			while (true) {
				Scanner sc = new Scanner(System.in);
				System.out.println();
				System.out.println("CRUD 선택");
				System.out.println("1: Create(Insert)");
				System.out.println("2: Read(Search) (전체)");
				System.out.println("3: Read(Search) (1명)");
				System.out.println("4: Update");
				System.out.println("5: Delete");
				System.out.println("6: exit");
				System.out.print("=".repeat(100));
				System.out.println();
				System.out.print("입력 : ");
				int num = sc.nextInt();
				
				switch (num) {
				case 1:
					create(conn);
					break;
				case 2:
					read(conn);
					break;
				case 3:
					sread(conn);
					break;
				case 4:
					update(conn);
					break;
				case 5:
					delete(conn);
					break;
				case 6:
					if (rs != null)
						rs.close();
					if (psmt != null)
						psmt.close();
					conn.close();
					
					System.out.println("종료되었습니다.");
					return;
				}

			}

		} catch (Exception e) {
			System.out.println("DB 연결 오류");
			e.printStackTrace();
		}
	}
}
