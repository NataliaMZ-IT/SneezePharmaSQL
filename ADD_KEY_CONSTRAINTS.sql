USE SneezePharma;
GO

-- Adding relations (foreign keys)
ALTER TABLE Clientes
   ADD FOREIGN KEY (Situacao) REFERENCES SituacaoCliente(id);

ALTER TABLE TelefonesClientes
   ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE ClientesRestritos
   ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE Fornecedores
   ADD FOREIGN KEY (Situacao) REFERENCES SituacaoFornecedor(id);

ALTER TABLE FornecedoresBloqueados
   ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor);

ALTER TABLE Medicamentos
   ADD FOREIGN KEY (Situacao) REFERENCES SituacaoMedicamento(id),
   FOREIGN KEY (Categoria) REFERENCES Categorias(id);

ALTER TABLE PrincipiosAtivos
   ADD FOREIGN KEY(Situacao) REFERENCES SituacaoPrincipioAtivo(id);

ALTER TABLE Vendas
   ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE Compras
   ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor);

ALTER TABLE Producoes
   ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);

ALTER TABLE ItensVendas
   ADD FOREIGN KEY (idVenda) REFERENCES Vendas(idVenda),
   FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);

ALTER TABLE ItensCompras
   ADD FOREIGN KEY (idPrincipio) REFERENCES PrincipiosAtivos(idPrincipio),
   FOREIGN KEY (idCompra) REFERENCES Compras(idCompra);

ALTER TABLE Ingredientes
   ADD FOREIGN KEY(idProducao) REFERENCES Producoes(idProducao),
   FOREIGN KEY(idPrincipio) REFERENCES PrincipiosAtivos(idPrincipio);

-- Adding composite primary keys
ALTER TABLE ItensVendas
   ADD CONSTRAINT PK_ItensVenda PRIMARY KEY (idVenda, idMedicamento);

ALTER TABLE ItensCompras
   ADD CONSTRAINT PK_ItensCompras PRIMARY KEY (idCompra, idPrincipio);

ALTER TABLE Ingredientes
   ADD CONSTRAINT PK_Ingredientes PRIMARY KEY (idProducao, idPrincipio);
GO