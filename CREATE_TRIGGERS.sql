-- Adding triggers to database
USE SneezePharma;
GO

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