--fornecedor
TRUNCATE TABLE fornecedor CASCADE;

INSERT INTO fornecedor (id_fornecedor, nome_fornecedor, cnpj, email)
VALUES
    (1, 'Acme Corporation', '11223344556677', 'acme@example.com'),
    (2, 'Globex Corporation', '99887766554433', 'globex@example.com'),
    (3, 'Stark Industries', '55443322110099', 'stark@example.com'),
    (4, 'Initech', '33221100998877', 'initech@example.com'),
    (5, 'Hooli', '77665544332211', 'hooli@example.com'),
    (6, 'Vehement Capital Partners', '12345678901234', 'vehement@example.com'),
    (7, 'Waystar Royco', '56789012345678', 'waystar@example.com'),
    (8, 'Pied Piper', '87654321098765', 'piedpiper@example.com'),
    (9, 'Prestige Worldwide', '11223344556688', 'prestige@example.com'),
    (10, 'Weyland-Yutani Corporation', '99887766554411', 'weyland@example.com'),
    (11, 'Cyberdyne Systems', '33221100998822', 'cyberdyne@example.com'),
    (12, 'Umbrella Corporation', '55443322110044', 'umbrella@example.com'),
    (13, 'Wonka Industries', '77665544332266', 'wonka@example.com')
ON CONFLICT (id_fornecedor) DO NOTHING;


SELECT *
FROM public.fornecedor;

SELECT id_fornecedor, nome_fornecedor, cnpj, email
FROM public.fornecedor order by id_fornecedor desc;

--****************************************************************************************************************************************************************************************************************************
--cliente

TRUNCATE TABLE cliente CASCADE;

INSERT INTO cliente (id_cliente, cpf_cnpj, email, nome)
VALUES 
    (1, '999.000.111-22', 'paula.almeida@outlook.com', 'Paula Almeida'),
    (2, '000.111.222-33', 'sergio.oliveira@gmail.com', 'Sergio Oliveira'),
    (3, '111.222.333-44', 'joao.silva@gmail.br', 'João Silva'),
    (5, '222.333.444-55', 'maria.santos@gmail.com', 'Maria Santos'),
    (6, '333.444.555-66', 'antonio.souza@outlook.com', 'Antonio Souza'),
    (7, '444.555.666-77', 'jose.pereira@gmail.com', 'José Pereira'),
    (8, '555.666.777-88', 'ana.fernandes@outlook.com', 'Ana Fernandes'),
    (9, '666.777.888-99', 'pedro.martins@gmail.com', 'Pedro Martins'),
    (10, '777.888.999-00', 'lucia.rodrigues@outlook.com', 'Lucia Rodrigues'),
    (11, '888.999.000-11', 'carlos.mendes@gmail.com', 'Carlos Mendes')
ON CONFLICT (id_cliente) DO NOTHING;

SELECT id_cliente, cpf_cnpj, email, nome
FROM cliente;

--****************************************************************************************************************************************************************************************************************************
--produto

TRUNCATE TABLE produto CASCADE;

INSERT INTO produto (id_produto, descricao, fornecedor_id_fornecedor) 
VALUES 
    (1, 'Escrivaninha de madeira maciça com gavetas embutidas', 1),
    (2, 'Guarda-roupa com três portas de correr e prateleiras internas', 2),
    (3, 'Mesa de escritório com tampo de vidro temperado e estrutura metálica', 3),
    (4, 'Cadeira de escritório com rodinhas e encosto reclinável', 1),
    (5, 'Estante de madeira com 6 prateleiras', 2),
    (6, 'Sofá de três lugares em couro sintético', 3),
    (7, 'Mesa de jantar com tampo de vidro e 6 cadeiras', 1),
    (8, 'Cama de casal com estrutura de metal', 2),
    (9, 'Armário de cozinha com 3 portas e 1 gaveta', 3),
    (10, 'Cômoda de madeira com 5 gavetas', 1),
    (11, 'Rack para TV até 55 polegadas', 2),
    (12, 'Mesa lateral redonda com tampo de vidro', 3),
    (13, 'Poltrona reclinável com apoio para os pés', 1),
    (14, 'Conjunto de mesa e cadeiras para varanda', 2)
    
ON CONFLICT (id_produto) DO NOTHING;

SELECT id_produto, descricao, fornecedor_id_fornecedor
FROM produto;

--****************************************************************************************************************************************************************************************************************************

--peça
TRUNCATE TABLE peca CASCADE;

INSERT INTO public.peca (id_peca, active, altura, codigo_fabrica, cor, custo, descricao, id_fornecedor, largura, material, material_fabricacao, numero, profundidade, unidade, unidade_medida, volumes, produto_id)
VALUES 
    (1, true, 5, 'COD1', 'Preto', 10, 'Parafuso para cama', 1, 0.5, 'Metal', 'Aço', 111, 0.5, 100, 5, 50, 1),
    (2, true, 75, 'COD2', 'Marrom', 100, 'Perna de cadeira', 2, 5, 'Madeira', 'Carvalho', 222, 5, 1, 54, 4, 2),
    (3, true, 20, 'COD3', 'Prata', 30, 'Dobradiça para armário', 3, 2, 'Metal', 'Aço Inoxidável', 333, 2, 50, 47, 10, 3),
    (4, true, 10, 'COD4', 'Marrom', 30, 'Parafuso da mesa', 4, 1, 'Metal', 'Aço', 456, 1, 100, 58, 1, 3),
    (5, true, 20, 'COD5', 'Preto', 40, 'Pé de cadeira', 2, 5, 'Madeira', 'Carvalho', 567, 5, 4, 65, 4, 4),
    (6, true, 15, 'COD6', 'Branco', 35, 'Dobradiça de armário', 6, 2, 'Metal', 'Ferro', 678, 1, 50, 62, 2, 5),
    (7, true, 8, 'COD7', 'Marrom Escuro', 25, 'Tampo de mesa', 7, 120, 'Madeira', 'Mogno', 789, 80, 2, 40, 1, 6),
    (8, true, 30, 'COD8', 'Prata', 45, 'Suporte de prateleira', 8, 5, 'Metal', 'Alumínio', 890, 2, 100, 65, 4, 7),
    (9, true, 50, 'COD9', 'Azul', 50, 'Estrutura de sofá', 9, 200, 'Madeira', 'Pinho', 901, 90, 2, 25, 1, 7),
    (10, true, 5, 'COD10', 'Dourado', 15, 'Maçaneta de gaveta', 10, 2, 'Metal', 'Bronze', 123, 1, 30, 14, 2, 8),
	(11, true, 10, 'COD11', 'Vermelho', 20, 'Parafuso para mesa', 3, 1.5, 'Metal', 'Aço', 222, 1.5, 100, 5, 50, 9),
    (12, true, 40, 'COD12', 'Amarelo', 60, 'Pé de sofá', 4, 3, 'Madeira', 'Pinho', 333, 10, 4, 65, 4, 10),
    (13, true, 12, 'COD13', 'Verde', 25, 'Dobradiça para porta', 5, 2.5, 'Metal', 'Aço Inoxidável', 444, 2, 50, 47, 10, 2),
    (14, true, 8, 'COD14', 'Branco', 15, 'Parafuso para armário', 6, 0.8, 'Metal', 'Aço', 555, 0.8, 100, 58, 1, 3),
    (15, true, 18, 'COD15', 'Marrom', 50, 'Puxador de gaveta', 7, 6, 'Plástico', 'ABS', 666, 4, 2, 40, 1, 4),
    (16, true, 15, 'COD16', 'Prata', 40, 'Corrediça para gaveta', 8, 4, 'Metal', 'Alumínio', 777, 1, 100, 65, 4, 5),
    (17, true, 8, 'COD17', 'Marrom', 25, 'Tampo de mesa', 9, 120, 'Madeira', 'Mogno', 888, 80, 2, 40, 1, 6),
    (18, true, 25, 'COD18', 'Prata', 35, 'Suporte para prateleira', 10, 4, 'Metal', 'Aço Inoxidável', 999, 2, 50, 62, 2, 7),
    (19, true, 60, 'COD19', 'Azul', 60, 'Encosto de cadeira', 11, 200, 'Madeira', 'Carvalho', 1010, 90, 2, 25, 1, 8),
    (20, true, 5, 'COD20', 'Dourado', 15, 'Dobradiça para gaveta', 12, 1, 'Metal', 'Bronze', 1111, 1, 30, 14, 2, 9)
    ON CONFLICT (id_peca) DO NOTHING;

SELECT id_peca, active, altura, codigo_fabrica, cor, custo, descricao, id_fornecedor, largura, material, material_fabricacao, numero, profundidade, unidade, unidade_medida, volumes, produto_id FROM peca;
--****************************************************************************************************************************************************************************************************************************

TRUNCATE TABLE pecas_estoque CASCADE;

-- olha para pecas cadastradas e insere valores em peca estoque
INSERT INTO public.pecas_estoque (id_peca_estoque, endereco, fornecedor, quantidade_ideal, quantidade_maxima, quantidade_minima, saldo_disponivel, saldo_reservado, id_peca)
SELECT
    p.id_peca AS id_peca_estoque,
    'Endereco ' || p.id_peca AS endereco,
    'Fornecedor ' || p.id_peca AS fornecedor,
    ROUND(RANDOM() * 20 + 10) + 50 AS quantidade_ideal,
    ROUND(RANDOM() * 40 + 20) + 50 AS quantidade_maxima,
    ROUND(RANDOM() * 10) + 50 AS quantidade_minima,
    ROUND(RANDOM() * 10) + 50 AS saldo_disponivel,
    ROUND(RANDOM() * 5) + 50 AS saldo_reservado,
    p.id_peca
FROM peca p;

SELECT id_peca_estoque, endereco, fornecedor, quantidade_ideal, quantidade_maxima, quantidade_minima, saldo_disponivel, saldo_reservado, id_peca
FROM public.pecas_estoque;

--INSERT INTO public.pecas_estoque (endereco, fornecedor, quantidade_ideal, quantidade_maxima, quantidade_minima, saldo_disponivel, saldo_reservado, id_peca)
--VALUES
--    ('Endereco 1', 'Fornecedor 1', 10, 20, 5, 15, 5, 9),
--    ('Endereco 2', 'Fornecedor 2', 12, 25, 8, 18, 6, 8),
--    ('Endereco 3', 'Fornecedor 3', 15, 30, 10, 20, 7, 8),
--    ('Endereco 4', 'Fornecedor 4', 8, 18, 3, 13, 3, 9),
--    ('Endereco 5', 'Fornecedor 5', 20, 40, 15, 25, 10, 8),
--    ('Endereco 6', 'Fornecedor 6', 10, 22, 6, 16, 4, 10),
--    ('Endereco 7', 'Fornecedor 7', 14, 28, 9, 19, 5, 11),
--    ('Endereco 8', 'Fornecedor 8', 18, 35, 12, 22, 8, 16),
--    ('Endereco 9', 'Fornecedor 9', 13, 26, 7, 17, 6, 11),
--    ('Endereco 10', 'Fornecedor 10', 16, 32, 11, 21, 6, 10),
--    ('Endereco 11', 'Fornecedor 11', 13, 27, 9, 19, 6, 13),
--    ('Endereco 12', 'Fornecedor 12', 16, 32, 11, 21, 8, 20),
--    ('Endereco 13', 'Fornecedor 13', 19, 38, 13, 23, 9, 11),
--    ('Endereco 14', 'Fornecedor 14', 14, 28, 10, 18, 7, 18),
--    ('Endereco 15', 'Fornecedor 15', 21, 42, 16, 26, 11, 12),
--    ('Endereco 16', 'Fornecedor 16', 12, 24, 8, 16, 5, 17),
--    ('Endereco 17', 'Fornecedor 17', 16, 32, 10, 22, 7, 11),
--    ('Endereco 18', 'Fornecedor 18', 20, 40, 14, 26, 10, 14),
--    ('Endereco 19', 'Fornecedor 19', 15, 30, 9, 21, 8, 19),
--    ('Endereco 20', 'Fornecedor 20', 18, 36, 12, 24, 9, 15)
--ON CONFLICT (id_peca_estoque) DO NOTHING;

--DROP TABLE IF EXISTS pecas_estoque CASCADE;

--se não funcionar o delete de peca então é porque esta relacionado a chave com pecas_estoque
--ALTER TABLE pecas_estoque
--DROP CONSTRAINT fklh9usdaqxuutbs0atofojxpry,
--ADD CONSTRAINT fklh9usdaqxuutbs0atofojxpry
--FOREIGN KEY (id_peca)  -- Update the column name here
--REFERENCES peca (id_peca);  -- Update the column name here

--****************************************************************************************************************************************************************************************************************************

TRUNCATE TABLE filial CASCADE;

INSERT INTO filial (id_filial, numero_filial, sigla)
VALUES
    (1, 1234, 'Filial Sao Paulo'),
    (2, 5678, 'Filial Rio de Janeiro'),
    (3, 91011, 'Filial Bahia'),
    (4, 1213, 'Filial Minas Gerais'),
    (5, 1415, 'Filial Paraná'),
    (6, 1617, 'Filial Santa Catarina'),
    (7, 1819, 'Filial Rio Grande do Sul'),
    (8, 2021, 'Filial Pernambuco'),
    (9, 2223, 'Filial Ceará'),
    (10, 2425, 'Filial Goiás')
ON CONFLICT DO NOTHING;

SELECT id_filial, numero_filial, sigla
FROM public.filial;
  
--****************************************************************************************************************************************************************************************************************************

TRUNCATE TABLE asteca_motivo CASCADE;

INSERT INTO public.asteca_motivo (id_asteca_motivo, denominacao, data_criacao, data_alteracao)
SELECT
  ROW_NUMBER() OVER () + 0 AS id_asteca_motivo,
  t.denominacao,
  CASE
    WHEN c.data_alteracao IS NULL THEN NOW() - (random() * INTERVAL '365 days')
    ELSE NOW() - (random() * (NOW() - c.data_alteracao))
  END AS data_criacao,
  NOW() - (random() * INTERVAL '365 days') AS data_alteracao
FROM (
  VALUES
    ('MERC. DANIFICADA EM USO'),
    ('MAU USO CONSUMIDOR'),
    ('AVARIA NA MONTAGEM'),
    ('MERCADORIA NÃO FUNCIONA'),
    ('MERCADORIA S/CONDIÇOES DE VENDA'),
    ('CARAC. NÃO ESPECIFICADA PELO VENDEDOR'),
    ('MERC. DANIFICADA POR DEFICIÊNCIA DA EMB. / FALTA ACESSORIOS'),
    ('DEFEITO DE FABRICAÇÃO'),
    ('MERC.  NÃO FUNCIONA CD/DVD'),
    ('DEFEITO NO AUDIO'),
    ('FALTA ACESSORIO/PEÇA NA EMBALAGEM'),
    ('PRODUTO CONSERTADO'),
    ('LOGISTICA'),
    ('MOTIVO CRIADO PELO SISMA'),
    ('PEÇA AVARIADA'),
    ('PRODUTO MOSTRUARIO'),
    ('PEÇA EM SEPARAÇAO'),
    ('MAU USO CONSUMIDOR'),
    ('MONTAGEM E DESMONTAGEM PRODUTOS/ESTOFADOS/PROD.SEM AVARIA'),
    ('VISTORIA'),
    ('PEÇAS PARA PRODUTO MOSTRUARIO'),
    ('PRODUTO DESMONTADO LOJA'),
    ('DESCOSTURADO'),
    ('PASSAR ESTOFADO PRA DENTRO RESIDENCIA'),
    ('PORTA COM VIDRO QUEBRADO'),
    ('TROCA VOLUME'),
    ('PRODUTO DESMONTADO'),
    ('PRODUTO ENTREGUE NA COR ERRADA'),
    ('ENTREGUE FALTANDO VOLUME'),
    ('PRODUTO MONTADO LOJA'),
    ('REPARO'),
    ('PRODUTO SEM DEFEITO')
) AS t(denominacao)
LEFT JOIN public.asteca_motivo c ON c.denominacao = t.denominacao
ON CONFLICT DO NOTHING;


SELECT id_asteca_motivo, data_alteracao, data_criacao, denominacao
FROM public.asteca_motivo;
--****************************************************************************************************************************************************************************************************************************

TRUNCATE TABLE solicitacao_asteca CASCADE;

SELECT *
FROM solicitacao_asteca;

--****************************************************************************************************************************************************************************************************************************

TRUNCATE TABLE item_documento_fiscal CASCADE;

SELECT id_item_doc_fiscal, qtde, valor_venda, id_produto, item_doc_id
FROM public.item_documento_fiscal;


--****************************************************************************************************************************************************************************************************************************

TRUNCATE TABLE documento_fiscal CASCADE;

SELECT id_documento_fiscal, cpf_cnpj, data_emissao, descricao, fornecedor, id_filial_saida, num_doc_fiscal, serie_doc_fiscal, id_cliente
FROM public.documento_fiscal;


--****************************************************************************************************************************************************************************************************************************
--criar docmento fiscal e 2 itens documento fiscal

TRUNCATE TABLE documento_fiscal CASCADE;
TRUNCATE TABLE item_documento_fiscal CASCADE;

SELECT id_documento_fiscal, cpf_cnpj, data_emissao, descricao, fornecedor, id_filial_saida, num_doc_fiscal, serie_doc_fiscal, id_cliente
FROM public.documento_fiscal;

SELECT id_item_doc_fiscal, qtde, valor_venda, id_produto, item_doc_id
FROM public.item_documento_fiscal;

-- Insert 1
INSERT INTO public.documento_fiscal (id_documento_fiscal, id_filial_saida, cpf_cnpj, num_doc_fiscal, serie_doc_fiscal, data_emissao, id_cliente, descricao, fornecedor)
VALUES (1, 1, '12345678900', 1, 'A', '2023-05-31', 1, 'Descrição 1', 'Fornecedor 1');

INSERT INTO public.item_documento_fiscal (id_item_doc_fiscal, qtde, valor_venda, id_produto, item_doc_id)
VALUES (1, 45, 10.0, 1, 1);

INSERT INTO public.item_documento_fiscal (id_item_doc_fiscal, qtde, valor_venda, id_produto, item_doc_id)
VALUES (2, 35, 20.0, 2, 1);

-- Insert 2
INSERT INTO public.documento_fiscal (id_documento_fiscal, id_filial_saida, cpf_cnpj, num_doc_fiscal, serie_doc_fiscal, data_emissao, id_cliente, descricao, fornecedor)
VALUES (2, 2, '98765432100', 2, 'B', '2023-05-31', 2, 'Descrição 2', 'Fornecedor 2');

INSERT INTO public.item_documento_fiscal (id_item_doc_fiscal, qtde, valor_venda, id_produto, item_doc_id)
VALUES (3, 10, 30.0, 3, 2);

INSERT INTO public.item_documento_fiscal (id_item_doc_fiscal, qtde, valor_venda, id_produto, item_doc_id)
VALUES (4, 15, 40.0, 4, 2);

--****************************************************************************************************************************************************************************************************************************
--Perfis
insert into perfil_usuario (id_perfil_usuario,descricao) values (1,'Administrativo');

--Funcionalidades
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (1,'0xf7cc','Peças',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (2,'0xe1b1','Astecas',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (3,'0xf5d3','Estoque',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (4,'0xf89e','Administração',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (5,'0xe1bf','Produtos',1);
insert into funcionalidades (id_funcionalidade,icone,nome,situacao) values (6,'0xf01f4','Fornecedores',1);

--Subfuncionalidades
insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade_id_funcionalidade) 
values (1,'Usuários','/usuarios',1,1);
insert into sub_funcionalidadades (id_subfuncionalidade,nome,rota,situacao,id_funcionalidade_id_funcionalidade) 
values (2,'Perfil de usuário','/perfil-usuario',1,1);

--perfil_usuario_funcionalidade
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

select * from perfil_usuario_funcionalidade puf;

select * from account a;   

select * from perfil_usuario pu; 

SELECT * from item_documento_fiscal;
SELECT * from peca;

SELECT * FROM fornecedor f order by id_fornecedor desc; 


/*



SELECT * FROM peca 

SELECT * FROM peca pc INNER JOIN produto p ON pc.produto_id = p.id_produto WHERE p.id_produto = :prod


SELECT id_peca_estoque, endereco, fornecedor, quantidade_ideal, quantidade_maxima, quantidade_minima, saldo_disponivel, saldo_reservado, id_peca
FROM public.pecas_estoque;

delete table peca

SELECT pe.*, pc.*
FROM public.pecas_estoque pe
INNER JOIN peca pc ON pe.id_peca = pc.id_peca
INNER JOIN produto p ON pc.produto_id = p.id_produto
WHERE p.id_produto = :prod;





SELECT *
FROM item_documento_fiscal idf ;

SELECT *
FROM item_documento_fiscal idf ;

SELECT *
FROM documento_fiscal df ;

SELECT *
FROM produto;

select
	*
from
	documento_fiscal df
inner join item_documento_fiscal idf on
	idf.id_item_doc_fiscal = df.id_documento_fiscal

	
select
	*
from
	documento_fiscal df
inner join item_documento_fiscal idf on
	idf.item_doc_id = df.id_documento_fiscal
	
	
SELECT * FROM documento_fiscal df INNER JOIN item_documento_fiscal idf ON idf.item_doc_id = df.id_documento_fiscal INNER JOIN produto p ON idf.id_produto = p.id_produto WHERE p.id_produto = :prod
*/