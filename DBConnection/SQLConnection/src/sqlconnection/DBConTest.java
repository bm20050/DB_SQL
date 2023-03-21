package sqlconnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class DBConTest {

	static Connection conn = null;
	static PreparedStatement psmt = null;
	static ResultSet rs = null;

	public static void create(Connection conn) {
		try {
			Scanner sc1 = new Scanner(System.in);
			Scanner sc2 = new Scanner(System.in);
			Scanner sc3 = new Scanner(System.in);
			String query = "insert into user (id, name, email) values (?,?,?)";
			psmt = conn.prepareStatement(query);

			System.out.println("추가할 사용자의 ID를 입력하세요.");
			psmt.setInt(1, sc1.nextInt());
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
		psmt = conn.prepareStatement("select * from user");
		rs = psmt.executeQuery();
		while (rs.next()) {
			int id = rs.getInt("id");
			String name = rs.getString("name");
			String email = rs.getString("email");
			System.out.println("ID: " + id + ", 이름: " + name + ", email: " + email);
		}
	}

	public static void sread(Connection conn) {
		try {
			Scanner sc = new Scanner(System.in);

			String query = "select * from user where id = ?";
			psmt = conn.prepareStatement(query);
			System.out.println("검색할 사용자의 ID를 입력하세요.");
			psmt.setInt(1, sc.nextInt());

			rs = psmt.executeQuery();

			while (rs.next()) {
				int id = rs.getInt("id");
				String name = rs.getString("name");
				String email = rs.getString("email");
				System.out.println("ID: " + id + ", 이름: " + name + ", email: " + email);
			}
		} catch (Exception e) {
			System.out.println("존재하지 않는 사용자입니다.");
		}
	}

	public static void update(Connection conn) {

		try {
			Scanner sc1 = new Scanner(System.in);
			Scanner sc2 = new Scanner(System.in);
			Scanner sc3 = new Scanner(System.in);

			String query = "update user set name = ?, email = ? where id = ?";

			psmt = conn.prepareStatement(query);

			System.out.println("수정할 사용자의 ID를 입력하세요.");
			psmt.setInt(3, sc1.nextInt());
			System.out.println("사용자의 이름을 입력하세요.");
			psmt.setString(1, sc2.nextLine());
			System.out.println("사용자의 email을 입력하세요.");
			psmt.setString(2, sc3.nextLine());

			psmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("존재하지 않는 사용자입니다.");
			e.printStackTrace();
		}
	}

	public static void delete(Connection conn) {
		try {
			Scanner sc = new Scanner(System.in);

			String query = "delete from user where id = ?";
			psmt = conn.prepareStatement(query);

			System.out.println("삭제할 사용자의 ID를 입력하세요.");
			psmt.setInt(1, sc.nextInt());

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
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db0321", "root", "1234");

			while (true) {
				Scanner sc = new Scanner(System.in);
				System.out.println("1: Create, 2: Read(전체), 3: Read(부분), 4: Update, 5: Delete, 6: exit");

				int num = sc.nextInt();
				boolean flag = false;
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
