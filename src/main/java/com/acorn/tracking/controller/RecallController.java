package com.acorn.tracking.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RecallController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/detail") // "/recall/detail"로 접속하면 이 메서드가 처리
    public String detail() {
        return "recall/detail"; // JSP 파일의 경로
    }


}
