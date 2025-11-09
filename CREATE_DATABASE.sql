-- Creating the database for SneezePharma
CREATE DATABASE SneezePharma;
GO

USE SneezePharma;

-- Creating tables
CREATE TABLE TelefonesClientes(
    id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idCliente INT NOT NULL,
    CodPais VARCHAR(3) NOT NULL,
    CodArea VARCHAR(2) NOT NULL,
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
    Situacao INT NOT NULL CONSTRAINT DF_SituacaoPrincipioAtivo DEFAULT 1
);

CREATE TABLE ItensCompras(
    idCompra INT NOT NULL,
    idPrincipio INT NOT NULL,
    Quantidade INT NOT NULL,
    ValorUnitario DECIMAL(6,2) NOT NULL,
    ValorTotal AS (ValorUnitario * Quantidade)
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
GO