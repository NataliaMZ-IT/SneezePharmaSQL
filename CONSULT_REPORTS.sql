USE SneezePharma;
GO

-- Report of Sales per Period
SELECT v.DataVenda, v.idVenda, 
  (i.Quantidade * m.ValorVenda) AS ValorTotalItem,
  CONCAT(c.Nome, ' ', c.Sobrenome) AS NomeCliente,
  c.CPF, m.Nome AS Medicamento, i.Quantidade, m.ValorVenda AS ValorUnidade
FROM Vendas v
JOIN Clientes c ON v.idCliente = c.idCliente
JOIN ItensVendas i ON v.idVenda = i.idVenda
JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento;

SELECT 
  v.DataVenda, v.idVenda,
  SUM(i.Quantidade * m.ValorVenda) AS Valor,
  CONCAT(c.Nome, ' ', c.Sobrenome) AS NomeCliente,
  c.CPF, 
  SUM(i.Quantidade) AS QtdItens,
  COUNT(i.idMedicamento) AS ItensDistintos
FROM Vendas v
JOIN Clientes c ON v.idCliente = c.idCliente
JOIN ItensVendas i ON v.idVenda = i.idVenda
JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
WHERE v.DataVenda = '2025-11-07'
GROUP BY v.idVenda, v.DataVenda, c.Nome, c.Sobrenome, c.CPF;
GO

-- Report of Medicine Most Sold
SELECT m.Nome, c.Nome AS Categoria, i.idVenda, i.Quantidade, m.ValorVenda AS Valor,
  (m.ValorVenda * i.Quantidade) AS ValorTotalNaVenda, v.DataVenda
FROM ItensVendas i
RIGHT JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
LEFT JOIN Vendas v ON i.idVenda = v.idVenda
LEFT JOIN Categorias c ON m.Categoria = c.id;

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
GO

-- Report of Purchases per Supplier
SELECT f.RazaoSocial, c.idCompra, p.Nome, i.Quantidade,
  i.ValorUnitario, i.ValorTotal, c.DataCompra 
FROM Compras c
RIGHT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
LEFT JOIN PrincipiosAtivos p ON i.idPrincipio = p.idPrincipio;

SELECT f.RazaoSocial, 
COUNT(DISTINCT c.idCompra) AS QuantidadeCompras,
COUNT(i.idCompra) AS ItensComprados, 
ISNULL(SUM(i.ValorTotal), 0) AS ValorTotalGasto, 
MAX(c.DataCompra) AS UltimaCompra
FROM Compras c
RIGHT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
GROUP BY f.RazaoSocial;
GO