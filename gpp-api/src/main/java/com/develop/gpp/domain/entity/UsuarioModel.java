// package com.develop.gpp.domain.entity;

// import java.time.LocalDateTime;

// import javax.persistence.Column;
// import javax.persistence.Entity;
// import javax.persistence.GeneratedValue;
// import javax.persistence.GenerationType;
// import javax.persistence.Id;
// import javax.persistence.JoinColumn;
// import javax.persistence.ManyToOne;
// import javax.persistence.Table;
// import lombok.Getter;
// import lombok.Setter;

// @Getter
// @Setter
// //@Entity
// //@Table(name = "usuario")
// public class UsuarioModel {
//     @Id
//     @GeneratedValue(strategy = GenerationType.IDENTITY)
//     private Long id;

//     private Long uid;

//     private String nome;

//     private String email;

//     @Column(name = "idfilial")
//     private Long idFilial;

//     private String accessToken;

//     private String tokenType;

//     @Column(name = "email_verified_at")
//     private LocalDateTime emailVerifiedAt;

//     private String password;

//     @Column(name = "remember_token")
//     private String rememberToken;

//     private LocalDateTime createdAt;

//     private LocalDateTime updatedAt;

//     private Boolean active;

//     private String iddepto;

//     private String foto;

//     @ManyToOne
//     @JoinColumn(name = "iddepto", referencedColumnName = "iddepto", insertable = false, updatable = false)
//     private DepartamentoModel departamento;

//     // @OneToOne(mappedBy = "usuario")
//     // private PefllUsuarioModel petfllUsuario;



//     // Getters and Setters
//     // ...
// }
