-- Adding procedures and types to database
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

-- Procedure for generating a report on Sales per Period
CREATE PROCEDURE sp_RelatorioVendas
@DataInicio DATE,
@DataFim DATE
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	  v.DataVenda, v.idVenda,
	  SUM(i.Quantidade * m.ValorVenda) AS Valor,
	  CONCAT(c.Nome, ' ', c.Sobrenome) AS NomeCliente, 
	  SUM(i.Quantidade) AS QtdItens,
	  COUNT(i.idMedicamento) AS ItensDistintos
	FROM Vendas v
	JOIN Clientes c ON v.idCliente = c.idCliente
	JOIN ItensVendas i ON v.idVenda = i.idVenda
	JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
	WHERE v.DataVenda BETWEEN @DataInicio AND @DataFim
	GROUP BY v.idVenda, v.DataVenda, c.Nome, c.Sobrenome;
END;
GO

-- Procedure for generating a report on Sales Items per Period
CREATE PROCEDURE sp_RelatorioVendasExpandido
@DataInicio DATE,
@DataFim DATE
AS
BEGIN
	SET NOCOUNT ON;

	SELECT v.DataVenda, v.idVenda, 
	  (i.Quantidade * m.ValorVenda) AS ValorTotalItem,
	  CONCAT(c.Nome, ' ', c.Sobrenome) AS NomeCliente,
	  m.Nome AS Medicamento, i.Quantidade, m.ValorVenda AS ValorUnidade
	FROM Vendas v
	JOIN Clientes c ON v.idCliente = c.idCliente
	JOIN ItensVendas i ON v.idVenda = i.idVenda
	JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
	WHERE v.DataVenda BETWEEN @DataInicio AND @DataFim;
END;
GO

-- Procedure for generating a report on Medicine Most Sold
CREATE PROCEDURE sp_RelatorioMaisVendido
@NumeroMaximo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @NumeroMaximo IS NOT NULL
	BEGIN
		SELECT TOP (@NumeroMaximo) WITH TIES
		  m.Nome, c.Nome AS Categoria,
		  ISNULL(SUM(i.Quantidade), 0) AS QtdVendida, 
		  COUNT(i.idVenda) AS VendasDistintas,
		  ISNULL(SUM(m.ValorVenda * i.Quantidade), 0) AS ValorTotal,
		  MAX(v.DataVenda) AS UltimaVenda
		FROM ItensVendas i
		RIGHT JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
		LEFT JOIN Vendas v ON i.idVenda = v.idVenda
		LEFT JOIN Categorias c ON m.Categoria = c.id
		GROUP BY m.Nome, c.Nome
		ORDER BY QtdVendida DESC;
	END
	ELSE
	BEGIN
	SELECT m.Nome, c.Nome AS Categoria,
		  ISNULL(SUM(i.Quantidade), 0) AS QtdVendida, 
		  COUNT(i.idVenda) AS VendasDistintas,
		  ISNULL(SUM(m.ValorVenda * i.Quantidade), 0) AS ValorTotal,
		  MAX(v.DataVenda) AS UltimaVenda
		FROM ItensVendas i
		RIGHT JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
		LEFT JOIN Vendas v ON i.idVenda = v.idVenda
		LEFT JOIN Categorias c ON m.Categoria = c.id
		GROUP BY m.Nome, c.Nome
		ORDER BY QtdVendida DESC;
	END
END;
GO

-- Procedure for generating a report on All Medicine Sales sorted by Name
CREATE PROCEDURE sp_RelatorioMaisVendidoExpandido
@Medicamento VARCHAR(40) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @Medicamento IS NOT NULL
	BEGIN
		SELECT m.Nome AS Medicamento, c.Nome AS Categoria, i.idVenda, 
		  i.Quantidade, m.ValorVenda AS Valor,
		  (m.ValorVenda * i.Quantidade) AS ValorTotalNaVenda, v.DataVenda
		FROM ItensVendas i
		LEFT JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
		LEFT JOIN Vendas v ON i.idVenda = v.idVenda
		LEFT JOIN Categorias c ON m.Categoria = c.id
		WHERE m.Nome = @Medicamento;
	END
	ELSE
	BEGIN
	SELECT m.Nome AS Medicamento, c.Nome AS Categoria, i.idVenda, 
		  i.Quantidade, m.ValorVenda AS Valor,
		  (m.ValorVenda * i.Quantidade) AS ValorTotalNaVenda, v.DataVenda
		FROM ItensVendas i
		LEFT JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
		LEFT JOIN Vendas v ON i.idVenda = v.idVenda
		LEFT JOIN Categorias c ON m.Categoria = c.id
		ORDER BY m.Nome ASC;
	END
END;
GO

-- Procedure for generating a report on Purchases by Supplier
CREATE PROCEDURE sp_RelatorioFornecedorCompras
@NumeroMaximo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @NumeroMaximo IS NOT NULL
	BEGIN
		SELECT TOP (@NumeroMaximo) WITH TIES
		  f.RazaoSocial AS Fornecedor, 
		  COUNT(DISTINCT c.idCompra) AS QuantidadeCompras,
		  COUNT(i.idCompra) AS ItensComprados,
		  ISNULL(SUM(i.Quantidade), 0) AS QtdTotalItens,
		  ISNULL(SUM(i.ValorTotal), 0) AS ValorTotalGasto, 
		  MAX(c.DataCompra) AS UltimaCompra
		FROM Compras c
		RIGHT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
		LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
		GROUP BY f.RazaoSocial
		ORDER BY QtdTotalItens DESC;
	END
	ELSE
	BEGIN
		SELECT f.RazaoSocial AS Fornecedor, 
		  COUNT(DISTINCT c.idCompra) AS QuantidadeCompras,
		  COUNT(i.idCompra) AS ItensComprados,
		  ISNULL(SUM(i.Quantidade), 0) AS QtdTotalItens,
		  ISNULL(SUM(i.ValorTotal), 0) AS ValorTotalGasto, 
		  MAX(c.DataCompra) AS UltimaCompra
		FROM Compras c
		RIGHT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
		LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
		GROUP BY f.RazaoSocial
		ORDER BY QtdTotalItens DESC;
	END
END;
GO

-- Procedure for generating a report on All Purchases sorted by Supplier
CREATE PROCEDURE sp_RelatorioFornecedorComprasExpandido
@Fornecedor VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @Fornecedor IS NOT NULL
	BEGIN
		SELECT f.RazaoSocial AS Fornecedor, c.idCompra, p.Nome AS PrincipioAtivo, 
		  i.Quantidade, i.ValorUnitario, i.ValorTotal, c.DataCompra 
		FROM Compras c
		LEFT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
		LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
		LEFT JOIN PrincipiosAtivos p ON i.idPrincipio = p.idPrincipio
		WHERE f.RazaoSocial = @Fornecedor;
	END
	ELSE
	BEGIN
		SELECT f.RazaoSocial AS Fornecedor, c.idCompra, p.Nome AS PrincipioAtivo, 
		  i.Quantidade, i.ValorUnitario, i.ValorTotal, c.DataCompra 
		FROM Compras c
		LEFT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
		LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
		LEFT JOIN PrincipiosAtivos p ON i.idPrincipio = p.idPrincipio
		ORDER BY f.RazaoSocial;
	END
END;
GO