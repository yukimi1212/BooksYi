package com.zucc.demo.dao;

import com.zucc.demo.model.SearchwordVo;

import java.util.List;

public interface SearchwordDAO {
    public void putSearchWords(String word,String type);
    public List<SearchwordVo> getAllSearchwords();
}
