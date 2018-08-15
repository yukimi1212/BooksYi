/*
package com.zucc.demo.dao;

import com.zucc.demo.model.BookVo;
import com.zucc.demo.model.SearchwordVo;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


@Repository
public class BookDAOImpl implements BookDAO {
    @Override
    public List<BookVo> getAllPages() {
        List<BookVo> pages = new ArrayList<>();
        try {
            Connection con = getConnection();
            Statement stmt = null;

            stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT isbn,title,author,intro,score,tags,count FROM books");

            while (rs.next()) {
                String isbn = rs.getString("isbn");
                String title = rs.getString("title");
                String author = rs.getString("author");
                String intro = rs.getString("intro");
                String score = rs.getString("score");
                String tags = rs.getString("tags");
                int count = rs.getInt("count");
                BookVo page = new BookVo();
                page.setIsbn(isbn);
                page.setTitle(title);
                page.setAuthor(author);
                page.setIntro(intro);
                page.setScore(score);
                page.setTags(tags);
                page.setCount(count);
                pages.add(page);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pages;
    }
    public List<BookVo> getSuggestWords(String keyword) {
        List<BookVo> words = new ArrayList<>();
        try {
            Connection con = getConnection();
            Statement stmt = null;

            stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT title,score FROM books where title like '"+keyword+"%' order by count desc,score desc");

            while(rs.next()){
                BookVo book = new BookVo();
                book.setTitle(rs.getString("title"));
                book.setScore(rs.getString("score"));
                words.add(book);
                if(words.size()>=10) break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return words;
    }

    public List<BookVo> getListByScore(){
        List<BookVo> books = new ArrayList<>();
        try {
            Connection con = getConnection();
            Statement stmt = null;

            stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT isbn,title,author,intro,score,tags,count FROM books WHERE score='10.0' or score>'9.5' ORDER BY RAND() LIMIT 10");

            while(rs.next()){
                BookVo book = new BookVo();
                book.setIsbn(rs.getString("isbn"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIntro(rs.getString("intro"));
                book.setScore(rs.getString("score"));
                book.setTags(rs.getString("tags"));
                book.setCount(rs.getInt("count"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    public List<BookVo> getListByHot(){
        List<BookVo> books = new ArrayList<>();
        try {
            Connection con = getConnection();
            Statement stmt = null;

            stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM books order by count desc limit 10");

            while(rs.next()){
                BookVo book = new BookVo();
                book.setIsbn(rs.getString("isbn"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIntro(rs.getString("intro"));
                book.setScore(rs.getString("score"));
                book.setTags(rs.getString("tags"));
                book.setCount(rs.getInt("count"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    public String getTagsByIsbn(String isbn){
        String result = null;
        try {
            Connection con = getConnection();
            Statement stmt = null;

            stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT tags FROM books where isbn='"+isbn+"'");

            while(rs.next()){
                result = rs.getString("tags");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    private Connection getConnection() {
        try {
            //加载MySql的驱动类
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("找不到驱动程序类 ，加载驱动失败！");
            e.printStackTrace();
        }
        //连接MySql数据库，用户名和密码都是root
        String url = "jdbc:mysql://localhost:3306/douban";
        String username = "root";
        String password = "123456";
        try {
            Connection con =
                    DriverManager.getConnection(url, username, password);
            return con;
        } catch (SQLException se) {
            System.out.println("数据库连接失败！");
            se.printStackTrace();
        }
        return null;
    }
}
*/
