USE SneezePharma;
GO

-- Customer Data
SELECT c.DataCadastro, c.idCliente, 
  CONCAT(c.Nome, ' ', c.Sobrenome) AS Nome, 
  c.CPF, c.DataNascimento, sc.Situacao,
  MAX(v.DataVenda) AS UltimaCompra,
  CONCAT(tc.CodPais,' ', tc.CodArea, ' ', tc.Numero) AS Telefone
FROM clientes c
LEFT JOIN TelefonesClientes tc ON c.idCliente = tc.idCliente
LEFT JOIN SituacaoCliente sc ON sc.id = c.Situacao
LEFT JOIN Vendas v ON v.idCliente = c.idCliente
WHERE sc.Situacao = 'Ativo'
GROUP BY c.idCliente, c.Nome, c.Sobrenome, c.CPF, c.DataNascimento, 
  c.DataCadastro, sc.Situacao, tc.CodPais, tc.CodArea, tc.Numero
ORDER BY c.idCliente;
GO

SELECT c.DataCadastro, c.idCliente, 
  CONCAT(c.Nome, ' ', c.Sobrenome) AS Nome, 
  c.CPF, c.DataNascimento, sc.Situacao,
  MAX(v.DataVenda) AS UltimaCompra,
  CONCAT(tc.CodPais,' ', tc.CodArea, ' ', tc.Numero) AS Telefone
FROM clientes c
LEFT JOIN TelefonesClientes tc ON c.idCliente = tc.idCliente
LEFT JOIN SituacaoCliente sc ON sc.id = c.Situacao
LEFT JOIN Vendas v ON v.idCliente = c.idCliente
WHERE sc.Situacao = 'Inativo'
GROUP BY c.idCliente, c.Nome, c.Sobrenome, c.CPF, c.DataNascimento, 
  c.DataCadastro, sc.Situacao, tc.CodPais, tc.CodArea, tc.Numero
ORDER BY c.idCliente;
GO

-- Restricted Customer Data
SELECT c.DataCadastro, c.idCliente, 
CONCAT(c.Nome, ' ',c.Sobrenome) as Nome, c.CPF
FROM ClientesRestritos cr
JOIN Clientes c ON c.idCliente = cr.idCliente
ORDER BY c.idCliente;
GO

-- Supplier Data
SELECT f.DataCadastro, f.idFornecedor, f.RazaoSocial, f.CNPJ,
  f.DataAbertura, f.Pais, sf.Situacao,
  MAX(c.DataCompra) AS UltimoFornecimento
FROM Fornecedores f
JOIN SituacaoFornecedor sf ON sf.id = f.Situacao
LEFT JOIN Compras c ON c.idFornecedor = f.idFornecedor
WHERE sf.Situacao = 'Ativo'
GROUP BY f.idFornecedor, f.CNPJ, f.RazaoSocial, f.DataAbertura, 
  f.DataCadastro, f.Pais, sf.Situacao
ORDER BY f.idFornecedor;
GO

SELECT f.DataCadastro, f.idFornecedor, f.RazaoSocial, f.CNPJ,
  f.DataAbertura, f.Pais, sf.Situacao,
  MAX(c.DataCompra) AS UltimoFornecimento
FROM Fornecedores f
JOIN SituacaoFornecedor sf ON sf.id = f.Situacao
LEFT JOIN Compras c ON c.idFornecedor = f.idFornecedor
WHERE sf.Situacao = 'Inativo'
GROUP BY f.idFornecedor, f.CNPJ, f.RazaoSocial, f.DataAbertura, 
  f.DataCadastro, f.Pais, sf.Situacao
ORDER BY f.idFornecedor;
GO

-- Restricted Supplier Data
SELECT f.DataCadastro, f.idFornecedor, f.RazaoSocial, f.CNPJ
FROM FornecedoresBloqueados fb
JOIN Fornecedores f ON fb.idFornecedor = f.idFornecedor
ORDER BY f.idFornecedor;
GO

-- Medicine Data
SELECT m.DataCadastro, m.idMedicamento, m.Nome, 
  m.CDB, c.Nome AS Categoria,	
  m.ValorVenda AS ValorUnitario, st.Situacao,
  MAX(v.DataVenda) AS DataUltimaVenda
FROM Medicamentos m
LEFT JOIN SituacaoMedicamento st ON m.Situacao = st.id
LEFT JOIN Categorias c ON c.id = m.Categoria
LEFT JOIN ItensVendas iv ON iv.idMedicamento = m.idMedicamento
LEFT JOIN Vendas v ON v.idVenda = iv.idVenda
WHERE st.Situacao = 'Ativo'
GROUP BY m.idMedicamento, m.Nome, m.ValorVenda, m.DataCadastro, 
  st.Situacao, c.Nome, m.CDB
ORDER BY m.idMedicamento;
GO

SELECT m.DataCadastro, m.idMedicamento, m.Nome, 
  m.CDB, c.Nome AS Categoria,	
  m.ValorVenda AS ValorUnitario, st.Situacao,
  MAX(v.DataVenda) AS DataUltimaVenda
FROM Medicamentos m
LEFT JOIN SituacaoMedicamento st ON m.Situacao = st.id
LEFT JOIN Categorias c ON c.id = m.Categoria
LEFT JOIN ItensVendas iv ON iv.idMedicamento = m.idMedicamento
LEFT JOIN Vendas v ON v.idVenda = iv.idVenda
WHERE st.Situacao = 'Inativo'
GROUP BY m.idMedicamento, m.Nome, m.ValorVenda, m.DataCadastro, 
  st.Situacao, c.Nome, m.CDB
ORDER BY m.idMedicamento;
GO

-- Ingredient Data
SELECT pa.DataCadastro, pa.idPrincipio, pa.Nome, sp.Situacao,
  MAX(c.DataCompra) AS UltimoFornecimento
FROM PrincipiosAtivos pa
JOIN SituacaoPrincipioAtivo sp ON pa.Situacao = sp.id
LEFT JOIN ItensCompras ic ON ic.idPrincipio = pa.idPrincipio
LEFT JOIN Compras c ON c.idCompra = ic.idCompra
WHERE sp.Situacao = 'Ativo'
GROUP BY pa.idPrincipio, pa.Nome, pa.DataCadastro, sp.Situacao
ORDER BY pa.idPrincipio;
GO

SELECT pa.DataCadastro, pa.idPrincipio, pa.Nome, sp.Situacao,
  MAX(c.DataCompra) AS UltimoFornecimento
FROM PrincipiosAtivos pa
JOIN SituacaoPrincipioAtivo sp ON pa.Situacao = sp.id
LEFT JOIN ItensCompras ic ON ic.idPrincipio = pa.idPrincipio
LEFT JOIN Compras c ON c.idCompra = ic.idCompra
WHERE sp.Situacao = 'Inativo'
GROUP BY pa.idPrincipio, pa.Nome, pa.DataCadastro, sp.Situacao
ORDER BY pa.idPrincipio;
GO

-- Sales Data
SELECT v.DataVenda, v.idVenda,
  CONCAT(c.nome, ' ', c.Sobrenome) AS NomeCliente, c.CPF,
  m.Nome AS Medicamento, iv.Quantidade,
  m.ValorVenda AS ValorUnitario, (iv.Quantidade * m.ValorVenda) AS ValorTotalItem
FROM Vendas v
JOIN Clientes c ON c.idCliente = v.idCliente
JOIN ItensVendas iv ON iv.idVenda = v.idVenda
JOIN Medicamentos m ON m.idMedicamento = iv.idMedicamento
ORDER BY v.DataVenda DESC;
GO

-- Purchases Data
SELECT  c.DataCompra, c.idCompra, f.RazaoSocial, f.CNPJ,
  pa.Nome AS PrincipioAtivo,
  it.Quantidade, it.ValorUnitario, it.ValorTotal AS ValorTotalItem
FROM Compras c
JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
JOIN ItensCompras it ON c.idCompra = it.idCompra
JOIN PrincipiosAtivos pa ON pa.idPrincipio = it.idPrincipio
ORDER BY c.DataCompra DESC;
GO

-- Production Data
SELECT p.DataProducao, p.idProducao, m.Nome AS Medicamento, m.ValorVenda,
  p.Quantidade, (p.Quantidade * m.ValorVenda) AS ValorDeVendaProduzido,
  pa.Nome AS PrincipioAtivo, i.Quantidade AS QtdPrincipioAtivo
FROM Producoes p
LEFT JOIN Medicamentos m ON m.idMedicamento = p.idMedicamento
LEFT JOIN Ingredientes i ON i.idProducao = p.idProducao
LEFT JOIN PrincipiosAtivos pa ON pa.idPrincipio = i.idPrincipio
ORDER BY p.DataProducao DESC;
GO