package com.zucc.demo.controller;

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
import java.io.IOException;

/**
 * Created by milly on 2018/06/24
 */


@Controller
public class UserController {
    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @RequestMapping(value = "/Individual", method = RequestMethod.GET)
    public ModelAndView indiPage() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("individual");
        return mav;
    }

    @RequestMapping(value = "/check", method = RequestMethod.POST)
    @ResponseBody
    private String admincheck(){
        logger.info("check{}");
        return "individual.jsp";
    }
}
