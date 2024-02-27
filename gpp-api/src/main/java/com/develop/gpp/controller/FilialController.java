package com.develop.gpp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.develop.gpp.domain.entity.FilialModel;
import com.develop.gpp.domain.service.FilialService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/filial")
public class FilialController {

    @Autowired
    private FilialService filialService;

    @PostMapping("/")
    public FilialModel salvarFilial(@RequestBody FilialModel filial) {

        return filialService.salvarFilial(filial);
    }

    @GetMapping("/")
    public List<FilialModel> todasFiliais() {

        return filialService.todasFiliais();

    }
}