package com.zucc.demo.controller;

import java.util.Comparator;

public class descComparator implements Comparator {
    public int compare(Object o1,Object o2){
        Double i1 = (Double)o1;
        Double i2 = (Double)o2;
        return i2.compareTo(i1);
    }
}
