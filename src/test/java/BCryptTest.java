public class BCryptTest {
    public static void main(String[] args) {
        String hashed = "$2a$10$wF2ZrC9hZJ9u9c6UHd92PuzX9PKXYe0zVZldqIsg7pUgG73VZzqvK";
        String input = "admin123"; // 你想验证的明文密码

        boolean matches = org.mindrot.jbcrypt.BCrypt.checkpw(input, hashed);
        System.out.println("匹配结果: " + matches);
    }
}
