
insert into perfil_usuario (id_perfil_usuario,descricao) values (1,'Administrativo');
insert into perfil_usuario (id_perfil_usuario,descricao) values (2,'Solicitante');
insert into perfil_usuario (id_perfil_usuario,descricao) values (3,'Estagio');


insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (1,'0xf7cc','Peças',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (2,'0xe1b1','Astecas',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (3,'0xf5d3','Estoque',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (4,'0xf89e','Administração',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (5,'0xe1bf','Produtos',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (6,'0xf01f4','Fornecedores',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (7,'0xf01f4','Home',1);



insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (1,'Usuários','/usuarios',1,4);
insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (2,'Perfil de usuário','/perfil-usuario',1,4);
insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (3,'Home','/home',1,7);


insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (1,1,1);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (2,2,1);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (3,3,1);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (4,4,1);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (5,5,1);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (6,6,1);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (7,7,1); 


insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (8,1,2);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (9,2,2);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (10,3,2);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (11,5,2);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (12,6,2);
insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (13,7,2);


insert into perfil_usuario_funcionalidade (id_perfil_usuario_funcionalidadade,funcionalidade_id_funcionalidade,perfil_usuario_id_perfil_usuario) 
 values (14,7,3);


select * from perfil_usuario_funcionalidade puf; 

select * from funcionalidades f ;


select * from account a;      

select * from "token" t order by id desc;

select * from sub_funcionalidadades sf ;   

select * from perfil_usuario pu;


-- fornecedor
insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (4,'Fornecedores','/fornecedores',1,6);

insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (4,'Fornecedores','/fornecedores',1,6);

insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (4,'Fornecedores','/fornecedores',1,6);

insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade) 
values (10,'Criar Peça','/criar-peca',1,1);

