USE SneezePharma;
GO

-- Inserting data into independent tables
INSERT INTO SituacaoCliente VALUES ('Ativo'),('Inativo');
INSERT INTO SituacaoFornecedor VALUES ('Ativo'),('Inativo');
INSERT INTO SituacaoMedicamento VALUES ('Ativo'),('Inativo');
INSERT INTO SituacaoPrincipioAtivo VALUES ('Ativo'),('Inativo');

INSERT INTO Categorias VALUES ('Analgésico'),('Anti-inflamatório'),('Antibiótico'),('Vitamina');

-- Inserting data into dependent tables
INSERT INTO Fornecedores(CNPJ,RazaoSocial,Pais,DataAbertura) VALUES
('12855570000142','FornecePharma','Brazil','1986-12-18'),
('31043895000175','PFizer','Brazil','1975-03-30'),
('31919422000199','QuimicaTech','Brazil','1994-12-19'),
('07145398000101','ProdutosPharma','Brazil','2002-04-15');

UPDATE Fornecedores
SET Situacao = 2
Where idFornecedor = 3;

INSERT INTO FornecedoresBloqueados VALUES (4);
GO

INSERT INTO Clientes(CPF,Nome,Sobrenome,DataNascimento) VALUES
('41157420036','Susanna','Regina','1968-11-28'),
('91608597091','Roberto','Carlinhos','1955-09-01'),
('87965490099','Chris','Martinez','2004-12-20'),
('19483339022','Georgina','Gargagli','1960-02-29');

UPDATE Clientes
SET Situacao = 2
WHERE idCliente = 3;

INSERT INTO ClientesRestritos VALUES (4);
GO

INSERT INTO Medicamentos(CDB,Nome,Categoria,ValorVenda) VALUES
('7891234200004','Ampicilina',3,15.90),
('7891234267504','Dorflex',1,20.00),
('7891234200384','Redoxon',4,14.55),
('7891234270855','Advil',2,32.45),
('7891234197733','Lexacil',1,12.85);

UPDATE Medicamentos
SET Situacao = 2
WHERE idMedicamento = 5
GO

INSERT INTO PrincipiosAtivos(Nome) VALUES ('Penicilina'),('Ibuprofeno'),('Dipirona'),('Ascorbato de Cálcio'),('Bromoprida');

UPDATE PrincipiosAtivos
SET Situacao = 2
WHERE idPrincipio = 5;
GO

INSERT INTO TelefonesClientes VALUES 
(1,'055','16','998321078'),
(3,'055','16','978325463'),
(1,'055','11','908123313');

INSERT INTO Compras(idFornecedor) VALUES (1),(2),(2);

INSERT INTO ItensCompras VALUES
(1,1,300,1.99),
(3,4,800,0.20),
(2,2,500,0.30),
(2,3,500,0.25);

INSERT INTO Vendas(idCliente) VALUES (1),(1),(2);

INSERT INTO ItensVendas VALUES 
(1,2,1),
(3,1,2),
(2,2,1),
(2,3,3);

INSERT INTO Producoes(idMedicamento,Quantidade) VALUES (3,200),(2,100),(1,50);

INSERT INTO Ingredientes VALUES 
(3,1,100),
(1,4,50),
(2,1,30),
(2,2,300);
GO