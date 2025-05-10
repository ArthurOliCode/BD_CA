DROP DATABASE IF EXISTS supermercado;
CREATE DATABASE supermercado;
USE supermercado;

CREATE TABLE Usuario (
	IDCliente INT NOT NULL AUTO_INCREMENT,
	cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(80) NOT NULL,
    cidade VARCHAR(80),
    telefone varchar(11) NOT NULL,
    cep CHAR(9) NOT NULL,
    datanascimento DATE,
    email VARCHAR(180),
    PRIMARY KEY(IDCliente)
);

CREATE TABLE Produto (
    ID_Produto INT NOT NULL auto_increment,
    Nome VARCHAR(100) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    Estoque INT NOT NULL,
    PRIMARY KEY (ID_Produto)
);

CREATE TABLE Venda (
    ID_Venda INT NOT NULL auto_increment,
    VendaData DATE NOT NULL,
    IDCliente INT NOT NULL,
    ID_Funcionario INT NOT NULL,
    PRIMARY KEY (ID_Venda),
	FOREIGN KEY (IDCliente) references Usuario(IDCliente)
);

CREATE TABLE Item_Venda (
    ID_Venda INT NOT NULL,
    ID_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    ID_Item INT NOT NULL auto_increment,
    SubTotal DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (ID_Item),
    FOREIGN KEY (ID_Venda) REFERENCES Venda(ID_Venda),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);