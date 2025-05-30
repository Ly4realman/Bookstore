package com.bookstore.servlet;

import javax.imageio.ImageIO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

@WebServlet("/captcha")
public class CaptchaServlet extends HttpServlet {
    private static final int WIDTH = 100, HEIGHT = 40;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics g = image.getGraphics();
        Random r = new Random();

        g.setColor(Color.WHITE);
        g.fillRect(0, 0, WIDTH, HEIGHT);

        String captcha = "";
        for (int i = 0; i < 4; i++) {
            String digit = String.valueOf(r.nextInt(10));
            captcha += digit;
            g.setColor(new Color(r.nextInt(150), r.nextInt(150), r.nextInt(150)));
            g.setFont(new Font("Arial", Font.BOLD, 24));
            g.drawString(digit, 20 * i + 10, 30);
        }

        // 加入噪点（可选）
        for (int i = 0; i < 10; i++) {
            g.setColor(Color.GRAY);
            g.drawLine(r.nextInt(WIDTH), r.nextInt(HEIGHT), r.nextInt(WIDTH), r.nextInt(HEIGHT));
        }

        // 保存验证码到 session
        HttpSession session = req.getSession();
        session.setAttribute("captcha", captcha);

        // 设置响应头避免缓存
        resp.setContentType("image/png");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setDateHeader("Expires", 0);

        ImageIO.write(image, "png", resp.getOutputStream());

    }
}
