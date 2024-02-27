package com.develop.gpp.domain.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.develop.gpp.domain.entity.ClienteModel;
import com.develop.gpp.domain.repository.ClienteRepository;

@RestController
@RequestMapping("/cliente")
public class ClienteService {

	@Autowired
	private ClienteRepository clienteRepository;

	@GetMapping("/")
	public List<ClienteModel> get() {
		return clienteRepository.findAll();
	}

	@PostMapping("/")
	public ClienteModel salvarCli(@RequestBody ClienteModel cli) {

		return clienteRepository.save(cli);

	}

}
