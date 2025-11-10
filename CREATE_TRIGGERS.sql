-- Adding triggers to database
USE SneezePharma;
GO

-- Triggers that impede deletion of registers from tables
CREATE TRIGGER TG_BLOQUEAR_DELETE_CATEGORIAS ON Categorias
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_CLIENTES ON Clientes
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_COMPRAS ON Compras
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_FORNECEDORES ON Fornecedores
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_INGREDIENTES ON Ingredientes
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_ITENSCOMPRAS ON ItensCompras
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_ITENSVENDAS ON ItensVendas
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_MEDICAMENTOS ON Medicamentos
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_PRINCIPIOSATIVOS ON PrincipiosAtivos
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_PRODUCOES ON Producoes
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_SITUACAOCLIENTE ON SituacaoCliente
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_SITUACAOFORNECEDOR ON SituacaoFornecedor
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_SITUACAOMEDICAMENTO ON SituacaoMedicamento
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_SITUACAOPRINCIPIOATIVO ON SituacaoPrincipioAtivo
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_TELEFONESCLIENTES ON TelefonesClientes
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER TG_BLOQUEAR_DELETE_VENDAS ON Vendas
FOR DELETE
AS
BEGIN
    RAISERROR ('Não é possível fazer a exclusão de dados nessa tabela!', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

-- Triggers that block transactions with 'Inactive' agents
CREATE TRIGGER TG_BLOQUEAR_VENDA_CLIENTE_INATIVO ON Vendas
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE TRIGGER TG_BLOQUEAR_COMPRA_FORNECEDOR_INATIVO ON Compras
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE TRIGGER TG_BLOQUEAR_VENDA_MEDICAMENTO_INATIVO ON ItensVendas
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE TRIGGER TG_BLOQUEAR_PRODUCAO_MEDICAMENTO_INATIVO ON Producoes
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE TRIGGER TG_BLOQUEAR_INGREDIENTE_PRINCIPIOATIVO_INATIVO ON Ingredientes
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE TRIGGER TG_BLOQUEAR_COMPRA_PRINCIPIOATIVO_INATIVO ON ItensCompras
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

-- Triggers that block transactions with 'Restriced' agents
CREATE TRIGGER TG_BLOQUEAR_VENDA_PARA_CLIENTE_RESTRITO ON Vendas
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

CREATE TRIGGER TG_BLOQUEAR_COMPRA_PARA_FORNECEDOR_BLOQUEADO ON Compras
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

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

-- Trigger that blocks sale if medicine hasn't been produced
CREATE TRIGGER TG_BLOQUEAR_COMPRA_SEM_PRODUCAO ON ItensVendas
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM inserted i
        LEFT JOIN Producoes p ON p.idMedicamento = i.idMedicamento
        WHERE p.idMedicamento IS NULL
    )
    BEGIN
        RAISERROR('Esse medicamento ainda não foi produzido!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger that blocks production if ingredient hasn't been bought
CREATE TRIGGER TB_BLOQUEAR_PRODUCAO_SEM_INGREDIENTE ON Ingredientes
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS(
        SELECT 1
        FROM inserted i
        LEFT JOIN ItensCompras ic ON ic.idPrincipio = i.idPrincipio
        WHERE ic.idPrincipio IS NULL
    )
    BEGIN
        RAISERROR('Esse ingrediente ainda não foi comprado!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger that limits items to 3 per order
CREATE TRIGGER TG_LIMITE_ITENS_POR_VENDA ON ItensVendas
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM ItensVendas iv
        WHERE iv.idVenda IN (SELECT DISTINCT idVenda FROM inserted)
        GROUP BY iv.idVenda
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR('Cada venda pode conter no máximo 3 itens.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TG_LIMITE_ITENS_POR_COMPRA ON ItensCompras
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM ItensCompras ic
        WHERE ic.idCompra IN (SELECT DISTINCT idCompra FROM inserted)
        GROUP BY ic.idCompra
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR('Cada compra pode conter no máximo 3 itens.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
