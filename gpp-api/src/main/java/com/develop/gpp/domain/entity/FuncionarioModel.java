// package com.develop.gpp.domain.entity;

// import javax.persistence.Column;
// import javax.persistence.Entity;
// import javax.persistence.FetchType;
// import javax.persistence.GeneratedValue;
// import javax.persistence.GenerationType;
// import javax.persistence.Id;
// import javax.persistence.JoinColumn;
// import javax.persistence.ManyToOne;
// import javax.persistence.Table;

// //@Entity
// //@Table(name = "funcionario")
// public class FuncionarioModel {

//     @Id
//     @GeneratedValue(strategy = GenerationType.IDENTITY)
//     @Column(name = "id_funcionario")
//     private Long idFuncionario;

//     @ManyToOne(fetch = FetchType.LAZY)
//     @JoinColumn(name = "id_cliente", referencedColumnName = "id_cliente")
//     private ClienteModel cliente;

// }
