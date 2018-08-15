/*
package com.zucc.demo.controller;

import com.zucc.demo.dao.BookDAO;
import com.zucc.demo.dao.SearchwordDAO;
import com.zucc.demo.dao.SearchwordDAOImpl;
import com.zucc.demo.model.BookVo;
import com.zucc.demo.model.SearchwordVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.awt.print.Book;
import java.util.*;


import javax.annotation.Resource;
import javax.naming.directory.SearchControls;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/book-pages")
public class BookController {
    private int num = 0;
    private long time = 0;
    private List<BookVo> pages = new ArrayList<>();
    private List<SearchwordVo> searchwordList = new ArrayList<>();

    private static final Logger logger = LoggerFactory.getLogger(BookController.class);

    @Autowired
    BookDAO bookDAO;
    @Autowired
    SearchwordDAO searchwordDAO;

    @RequestMapping(value = "/search", method = RequestMethod.GET)
    public ModelAndView search() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("BookSearch");
        return mav;
    }

    @RequestMapping(value = "/details", method = RequestMethod.GET)
    public ModelAndView searchdetails() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("BookDetails");
        return mav;
    }
    @RequestMapping(value = "/getNum.do", method = RequestMethod.POST)
    @ResponseBody
    public int getNum(){
        try {
            Thread.sleep(300);
        }catch(Exception e){

        }
        return num;
    }
    @RequestMapping(value = "/getTime.do", method = RequestMethod.POST)
    @ResponseBody
    public long getTime(){
        try {
            Thread.sleep(300);
        }catch(Exception e){

        }
        return time;
    }
    @RequestMapping(value = "/getTitlePages.do", method = RequestMethod.POST)
    @ResponseBody
    public List<BookVo> getTitle(@RequestBody SearchParam searchParam) {
        logger.info("getTitlePages {}", searchParam.getWord());
        Map<Integer, List<BookVo>> pageRank = new TreeMap<>();
        long startTime = System.currentTimeMillis();
        if (pages.isEmpty()) {
            pages = bookDAO.getAllPages();
        }
        List<BookVo> result;
        if (StringUtils.isEmpty(searchParam.getWord())) {
            result = pages.subList(1, 10);
        } else {
            searchwordDAO.putSearchWords(searchParam.getWord(), "title");
            result = new ArrayList<>();
            for (BookVo page : pages) {
                if (page.getTitle().contains(searchParam.getWord())) {
                    int c = new Recommend().Levenshtein(page.getTitle(), searchParam.getWord());
                    if (pageRank.containsKey(c)) {
                        pageRank.get(c).add(page);
                    } else {
                        List<BookVo> list = new ArrayList<>();
                        list.add(page);
                        pageRank.put(c, list);
                    }
                }
            }
            for (int key : pageRank.keySet()) {
                Collections.sort(pageRank.get(key));
                for (BookVo book : pageRank.get(key))
                    result.add(book);
            }
        }
        num = result.size();
        time = System.currentTimeMillis()-startTime;
        return result;
    }

    @RequestMapping(value = "/getAuthorPages.do", method = RequestMethod.POST)
    @ResponseBody
    public List<BookVo> getAuthor(@RequestBody SearchParam searchParam) {
        logger.info("getAuthorPages {}", searchParam.getWord());
        long startTime = System.currentTimeMillis();
        if (pages.isEmpty()) {
            pages = bookDAO.getAllPages();
        }
        List<BookVo> result;
        if (StringUtils.isEmpty(searchParam.getWord())) {
            result = pages.subList(1, 10);
        } else {
            searchwordDAO.putSearchWords(searchParam.getWord(),"author");
            result = new ArrayList<>();
            for (BookVo page : pages) {
                if (page.getAuthor().contains(searchParam.getWord())) {
                    result.add(page);
                }
            }
        }
        num = result.size();
        time = System.currentTimeMillis()-startTime;
        return result;
    }

    @RequestMapping(value = "/getIsbnPages.do", method = RequestMethod.POST)
    @ResponseBody
    public List<BookVo> getIsbn(@RequestBody SearchParam searchParam) {
        logger.info("getIsbnPages {}", searchParam.getWord());
        long startTime = System.currentTimeMillis();
        if (pages.isEmpty()) {
            pages = bookDAO.getAllPages();
        }

        List<BookVo> result;
        if (StringUtils.isEmpty(searchParam.getWord())) {
            result = pages.subList(1, 10);
        } else {
            searchwordDAO.putSearchWords(searchParam.getWord(),"isbn");
            result = new ArrayList<>();
            for (BookVo page : pages) {
                if (page.getIsbn().equals(searchParam.getWord())) {
                    result.add(page);
                    //if (result.size() >= 10) break;
                }
            }
        }
        num = result.size();
        time = System.currentTimeMillis()-startTime;
        return result;
    }

    @RequestMapping(value="/suggestWord.do", method=RequestMethod.POST)
    @ResponseBody
    public List<BookVo> suggestWord(@RequestBody SearchParam searchParam) {
        String keyWord = searchParam.getWord();
        logger.info("suggestWord {}", keyWord);
        if (keyWord.isEmpty()) {
            return new ArrayList<>();
        }
        List<BookVo> result = bookDAO.getSuggestWords(keyWord);

        return result;
    }

    @RequestMapping(value="/getListByScore.do", method=RequestMethod.POST)
    @ResponseBody
    public List<BookVo> getListByScore() {
        List<BookVo> result = bookDAO.getListByScore();
        return result;
    }
    @RequestMapping(value="/getListByHot.do", method=RequestMethod.POST)
    @ResponseBody
    public List<BookVo> getListByHot() {
        List<BookVo> result = bookDAO.getListByHot();
        return result;
    }
    @RequestMapping(value = "/getSearchwords.do", method = RequestMethod.POST)
    @ResponseBody
    public List<SearchwordVo> getSearchwords() {
        return searchwordDAO.getAllSearchwords();
    }

    @RequestMapping(value="/getRecommend.do", method=RequestMethod.POST)
    @ResponseBody
    public List<BookVo> getRecommend(@RequestBody SearchParam searchParam){
        logger.info("getRecommend {}", searchParam.getWord());
        List<BookVo> result = new ArrayList<>();
        Map<Double, List<BookVo>> bookRank = new TreeMap<Double,List<BookVo>>(new descComparator());
        if (pages.isEmpty()) {
            pages = bookDAO.getAllPages();
        }
        String[] tags1 = bookDAO.getTagsByIsbn(searchParam.getWord()).split("\\|");
        for(BookVo page:pages){
            if(page.getIsbn().compareTo(searchParam.getWord()) != 0){
                String[] tags2 = page.getTags().split("\\|");
                double sim = new Recommend().getSimilarDegree(tags1,tags2);
                if(bookRank.containsKey(sim)){
                    bookRank.get(sim).add(page);
                }
                else{
                    List<BookVo> list = new ArrayList<>();
                    list.add(page);
                    bookRank.put(sim,list);
                }
            }
        }
        for(double key:bookRank.keySet()){
            if (result.size() > 4) break;
            Collections.sort(bookRank.get(key));
            for(BookVo book:bookRank.get(key)) {
                result.add(book);
                System.out.println(book.getTitle() + "---" + key+"---"+book.getCount()+"---"+book.getScore());
                if (result.size() > 4) break;
            }
        }
        return result;
    }
//    @RequestMapping(value="/getRecommend.do", method=RequestMethod.POST)
//    @ResponseBody
//    public List<BookVo> getRecommend(@RequestBody SearchParam searchParam){
//        logger.info("getRecommend {}", searchParam.getWord());
//        List<BookVo> result = new ArrayList<>();
//        Map<Double, List<BookVo>> bookRank = new TreeMap<Double,List<BookVo>>(new descComparator());
//        if (pages.isEmpty()) {
//            pages = bookDAO.getAllPages();
//        }
//        String[] tags1 = bookDAO.getTagsByIsbn(searchParam.getWord()).split("\\|");
//        for(BookVo page:pages){
//            if(page.getIsbn().compareTo(searchParam.getWord()) != 0){
//                String[] tags2 = page.getTags().split("\\|");
//                double sim = new Recommend().getSimilarDegree(tags1,tags2);
//                if(bookRank.containsKey(sim)){
//                    bookRank.get(sim).add(page);
//                }
//                else{
//                    List<BookVo> list = new ArrayList<>();
//                    list.add(page);
//                    bookRank.put(sim,list);
//                }
//            }
//        }
//        for(double key:bookRank.keySet()){
//            if (result.size() > 4) break;
//            for(BookVo book:bookRank.get(key)) {
//                result.add(book);
//                System.out.println(book.getTitle() + "----" + key);
//                if (result.size() > 4) break;
//            }
//        }
//        return result;
//    }
}*/
