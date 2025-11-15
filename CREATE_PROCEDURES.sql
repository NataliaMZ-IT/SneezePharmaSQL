-- Adding procedures to database
USE SneezePharma;
GO

-- Table types for inserting dependent items (purchase, sale, ingredient, telephone)
CREATE TYPE TYPEItensCompra AS TABLE(
	idPrincipioAtivo INT NOT NULL,
	Quantidade INT NOT NULL,
	ValorUnitario DECIMAL(6,2) NOT NULL
);
GO

CREATE TYPE TYPEItensVenda AS TABLE(
	idMedicamento INT NOT NULL,
	Quantidade INT NOT NULL
);
GO

CREATE TYPE TYPEIngredientes AS TABLE(
	idPrincipioAtivo INT NOT NULL,
	Quantidade INT NOT NULL
);
GO

CREATE TYPE TYPETelephones AS TABLE(
	CodPais VARCHAR(3) NOT NULL,
	CodArea VARCHAR(3) NOT NULL,
	Numero VARCHAR(9) NOT NULL
);
GO

-- Procedure for inserting purchase with items (limit of 3)
CREATE PROCEDURE sp_Compra
@idFornecedor INT,
@Itens TYPEItensCompra READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Limite INT = 3;
	DECLARE @NumeroItens INT;

	SELECT @NumeroItens = COUNT(*) FROM @Itens;

	IF @NumeroItens > @Limite
	BEGIN
		RAISERROR('Você não pode inserir mais do que 3 itens por compra!',16,1);
	END
	ELSE
	BEGIN
		SET NOCOUNT OFF;

		DECLARE @idCompra INT;

		INSERT INTO Compras(idFornecedor) VALUES (@idFornecedor);

		SET @idCompra = SCOPE_IDENTITY();

		INSERT INTO ItensCompras(idCompra, idPrincipio, Quantidade, ValorUnitario)
		SELECT @idCompra, idPrincipioAtivo, Quantidade, ValorUnitario
		FROM @Itens;
	END
END;
GO

-- Procedure for inserting sale with items (limit of 3)
CREATE PROCEDURE sp_Venda
@idCliente INT,
@Itens TYPEItensVenda READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Limite INT = 3;
	DECLARE @NumeroItens INT;

	SELECT @NumeroItens = COUNT(*) FROM @Itens;

	IF @NumeroItens > @Limite
	BEGIN
		RAISERROR('Você não pode inserir mais do que 3 itens por venda!',16,1);
	END
	ELSE
	BEGIN
		SET NOCOUNT OFF;

		DECLARE @idVenda INT;

		INSERT INTO Vendas(idCliente) VALUES (@idCliente)

		SET @idVenda = SCOPE_IDENTITY();

		INSERT INTO ItensVendas(idVenda, idMedicamento, Quantidade)
		SELECT @idVenda, idMedicamento, Quantidade
		FROM @Itens;
	END
END;
GO

-- Procedure for inserting production with ingredients
CREATE PROCEDURE sp_Producao
@idMedicamento INT,
@Quantidade INT,
@Ingredientes TYPEIngredientes READONLY
AS
BEGIN
	DECLARE @idProducao INT;

	INSERT INTO Producoes(idMedicamento, Quantidade) 
	VALUES (@idMedicamento, @Quantidade);

	SET @idProducao = SCOPE_IDENTITY();

	INSERT INTO Ingredientes(idProducao, idPrincipio, Quantidade)
	SELECT @idProducao, idPrincipioAtivo, Quantidade
	FROM @Ingredientes;
END;
GO

-- Procedure for inserting customer account with telephone numbers
CREATE PROCEDURE sp_Cliente
@CPF VARCHAR(11),
@Nome VARCHAR(50),
@Sobrenome VARCHAR(50),
@DataNascimento DATE,
@Telephones TYPETelephones READONLY
AS
BEGIN
	DECLARE @idCliente INT;

	INSERT INTO Clientes(CPF, Nome, Sobrenome, DataNascimento)
	VALUES (@CPF, @Nome, @Sobrenome, @DataNascimento);

	SET @idCliente = SCOPE_IDENTITY();

	INSERT INTO TelefonesClientes(idCliente, CodPais, CodArea, Numero)
	SELECT @idCliente, CodPais, CodArea, Numero
	FROM @Telephones;
END;
GO