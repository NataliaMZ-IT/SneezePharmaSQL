CREATE DATABASE SneezePharma

USE SneezePharma

CREATE TABLE TelefonesClientes(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
idCliente INT NOT NULL,
CodPais VARCHAR(3) NOT NULL,
CodAraea VARCHAR(2) NOT NULL,
Numero VARCHAR(9) NOT NULL
);

CREATE TABLE Clientes(
idCliente INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CPF VARCHAR(11) NOT NULL UNIQUE,
Nome VARCHAR(50) NOT NULL,
Sobrenome VARCHAR(50) NOT NULL,
DataNascimento DATE NOT NULL,
DataCadastro DATE NOT NULL CONSTRAINT DF_DataCadastroCliente DEFAULT CAST(GETDATE() AS DATE),
Situacao INT NOT NULL CONSTRAINT DF_SituacaoClientes DEFAULT 1
);

CREATE TABLE ClientesRestritos(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
idCliente INT NOT NULL UNIQUE
);

CREATE TABLE Vendas(
idVenda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DataVenda DATE NOT NULL CONSTRAINT DF_DataVenda DEFAULT CAST(GETDATE() AS DATE),
idCliente INT NOT NULL
);

CREATE TABLE ItensVendas(
idVenda INT NOT NULL,
idMedicamento INT NOT NULL,
Quantidade INT NOT NULL
);

CREATE TABLE Medicamentos(
idMedicamento INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CDB VARCHAR(13) NOT NULL UNIQUE,
Nome VARCHAR(40) NOT NULL UNIQUE,
Categoria INT NOT NULL,
ValorVenda DECIMAL(6,2) NOT NULL,
DataCadastro DATE NOT NULL CONSTRAINT DF_DataCadastroMedicamento DEFAULT CAST(GETDATE() AS DATE),
Situacao INT NOT NULL CONSTRAINT DF_SituacaoMedicamentos DEFAULT 1
);

CREATE TABLE Producoes(
idProducao INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DataProducao DATE NOT NULL CONSTRAINT DF_DataProducao DEFAULT CAST(GETDATE() AS DATE),
idMedicamento INT NOT NULL,
Quantidade INT NOT NULL
);

CREATE TABLE Ingredientes(
idProducao INT NOT NULL,
idPrincipio INT NOT NULL,
Quantidade INT NOT NULL
);

CREATE TABLE PrincipiosAtivos(
idPrincipio INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nome VARCHAR(20) NOT NULL UNIQUE,
DataCadastro DATE NOT NULL CONSTRAINT DF_DataCadastroPrincipio DEFAULT CAST(GETDATE() AS DATE),
Situacao INT NOT NULL DF_SituacaoPrincipioAtivo DEFAULT 1
);

CREATE TABLE ItensCompras(
idCompra INT NOT NULL,
idPrincipio INT NOT NULL,
Quantidade INT NOT NULL,
ValorUnitario DECIMAL(6,2) NOT NULL
);

CREATE TABLE Compras(
idCompra INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DataCompra DATE NOT NULL CONSTRAINT DF_DataCompra DEFAULT CAST(GETDATE() AS DATE),
idFornecedor INT NOT NULL
);

CREATE TABLE Fornecedores(
idFornecedor INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CNPJ VARCHAR(14) NOT NULL UNIQUE,
RazaoSocial VARCHAR(50) NOT NULL,
Pais VARCHAR(20) NOT NULL,
DataAbertura DATE NOT NULL,
DataCadastro DATE NOT NULL CONSTRAINT DF_DataCadastroFornecedor DEFAULT CAST(GETDATE() AS DATE),
Situacao INT NOT NULL CONSTRAINT DF_SituacaoFornecedores DEFAULT 1
);

CREATE TABLE FornecedoresBloqueados(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
idFornecedor INT NOT NULL UNIQUE
);

CREATE TABLE Categorias(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nome VARCHAR(17) UNIQUE
);

CREATE TABLE SituacaoCliente(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

CREATE TABLE SituacaoPrincipioAtivo(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

CREATE TABLE SituacaoMedicamento(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

CREATE TABLE SituacaoFornecedor(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

ALTER TABLE Clientes
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoCliente(id)

ALTER TABLE TelefonesClientes
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE Vendas
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idVenda) REFERENCES Vendas(idVenda)

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento)

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoMedicamento(id)

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Categoria) REFERENCES Categorias(id)

ALTER TABLE Producoes
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento)

ALTER TABLE Ingredientes
ADD FOREIGN KEY(idProducao) REFERENCES Producoes(idProducao)

ALTER TABLE Ingredientes
ADD FOREIGN KEY(idPrincipio) REFERENCES PrincipiosAtivos(idPrincipio)

ALTER TABLE PrincipiosAtivos
ADD FOREIGN KEY(Situacao) REFERENCES SituacaoPrincipioAtivo(id)

ALTER TABLE ItensCompras
ADD FOREIGN KEY (idPrincipio) REFERENCES PrincipiosAtivos(idPrincipio)

ALTER TABLE ItensCompras
ADD FOREIGN KEY (idCompra) REFERENCES Compras(idCompra)

ALTER TABLE Compras
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)

ALTER TABLE Fornecedores
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoFornecedor(id)

ALTER TABLE FornecedoresBloqueados
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)

ALTER TABLE ItensVendas
ADD CONSTRAINT PK_ItensVenda PRIMARY KEY (idVenda, idMedicamento)

ALTER TABLE ItensCompras
ADD CONSTRAINT PK_ItensCompras PRIMARY KEY (idCompra, idPrincipio)

ALTER TABLE Ingredientes
ADD CONSTRAINT PK_Ingredientes PRIMARY KEY (idProducao, idPrincipio)


CREATE TRIGGER TG_BLOQUEAR_VENDA_CLIENTE_INATIVO
ON Vendas
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Clientes c ON i.idCliente = c.idCliente
        INNER JOIN SituacaoCliente sc on sc.id = c.Situacao
        WHERE sc.Situacao = 'Inativo'
    )
    BEGIN
        RAISERROR('Esse cliente está inativo!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_VENDA_PARA_CLIENTE_RESTRITO
ON Vendas
FOR INSERT
AS
BEGIN
	IF EXISTS(
	SELECT 1
	FROM inserted i
	INNER JOIN ClientesRestritos cr on i.idCliente = cr.idCliente
	)
	BEGIN
	    RAISERROR('Esse cliente está bloqueado!', 16, 1);
        ROLLBACK TRANSACTION;
	END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_VENDA_MEDICAMENTO_INATIVO
ON ItensVendas
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
        INNER JOIN SituacaoCliente sc on sc.id = m.Situacao
        WHERE sc.Situacao = 'Inativo'
    )
    BEGIN
        RAISERROR('Esse medicamento está inativo!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_LIMITE_ITENS_POR_VENDA
ON ItensVendas
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT i.idVenda
        FROM inserted i
        JOIN ItensVendas iv ON iv.idVenda = i.idVenda
        GROUP BY i.idVenda
        HAVING COUNT(iv.idMedicamento) > 3
    )
    BEGIN
        RAISERROR('Cada venda pode conter no máximo 3 itens.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_COMPRA_FORNECEDOR_INATIVO
ON Compras
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Fornecedores f ON i.idFornecedor = f.idFornecedor
        INNER JOIN SituacaoCliente sc on sc.id = f.Situacao
        WHERE sc.Situacao = 'Inativo'
    )
    BEGIN
        RAISERROR('Esse fornecedor está inativo!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_COMPRA_PARA_FORNECEDOR_BLOQUEADO
ON Compras
FOR INSERT
AS
BEGIN
	IF EXISTS(
	SELECT 1
	FROM inserted i
	INNER JOIN FornecedoresBloqueados fb on i.idFornecedor = fb.idFornecedor
	)
	BEGIN
	    RAISERROR('Esse fornecedor está bloqueado!', 16, 1);
        ROLLBACK TRANSACTION;
	END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_COMPRA_PRINCIPIOATIVO_INATIVO
ON ItensCompras
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN PrincipiosAtivos p ON i.idPrincipio = p.idPrincipio
        INNER JOIN SituacaoCliente sc on sc.id = p.Situacao
        WHERE sc.Situacao = 'Inativo'
    )
    BEGIN
        RAISERROR('Esse princípio ativo está inativo!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_LIMITE_ITENS_POR_COMPRA
ON ItensCompras
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT i.idCompra
        FROM inserted i
        JOIN ItensCompras c ON c.idCompra = i.idCompra
        GROUP BY i.idCompra
        HAVING COUNT(c.idPrincipio) > 3
    )
    BEGIN
        RAISERROR('Cada compra pode conter no máximo 3 itens.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_PRODUCAO_MEDICAMENTO_INATIVO
ON Producoes
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
        INNER JOIN SituacaoCliente sc on sc.id = m.Situacao
        WHERE sc.Situacao = 'Inativo'
    )
    BEGIN
        RAISERROR('Esse medicamento está inativo!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_BLOQUEAR_INGREDIENTE_PRINCIPIOATIVO_INATIVO
ON Ingredientes
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN PrincipiosAtivos p ON i.idPrincipio = p.idPrincipio
        INNER JOIN SituacaoCliente sc on sc.id = p.Situacao
        WHERE sc.Situacao = 'Inativo'
    )
    BEGIN
        RAISERROR('Esse princípio ativo está inativo!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO