package com.zucc.demo.dao;

import com.zucc.demo.model.SearchwordVo;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SearchwordDAOImpl implements SearchwordDAO {

    @Override
    public void putSearchWords(String word, String type) {
        try {
            Connection con = getConnection();
            Statement stmt = null;
            stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select * from searchwords where word='" + word + "' and type='" + type + "'");
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                String sql = "update searchwords set count=" + count + " where word='" + word + "'and type='" + type + "'";
                stmt.execute(sql);
            } else {
                String sql = "insert into searchwords(word,type,count) values('" + word + "','" + type + "'," + 1 + ")";
                stmt.execute(sql);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public List<SearchwordVo> getAllSearchwords() {
        List<SearchwordVo> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            Statement stmt = null;

            stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select * from searchwords order by count desc");
            while (rs.next()) {
                String word = rs.getString("word");
                String type = rs.getString("type");
                int count = rs.getInt("count");
                SearchwordVo searchword = new SearchwordVo();
                searchword.setWord(word);
                searchword.setType(type);
                searchword.setCount(count);
                list.add(searchword);
                if (list.size() >= 5) break;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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