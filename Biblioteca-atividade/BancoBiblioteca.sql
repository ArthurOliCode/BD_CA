Drop database if exists biblioteca;
Create DATABASE if not exists biblioteca;
USE biblioteca;

CREATE table Alunos (
cpf VARCHAR(14) not null unique,
IDCliente int not null auto_increment, 
nome VARCHAR(100) not null,
cidade VARCHAR(100) not null,
telefone VARCHAR(11) not null,
cep VARCHAR(9) not null,
dataNascimento DATE,
email varchar(180) not null,
primary key (IDCliente)
);

CREATE table Livros (
titulo VARCHAR(180) not null,
IDLivro int not null auto_increment,
Estoque int not null,
primary key (IDLivro)

);

CREATE table Empréstimos (
IDEmprestimo int not null auto_increment,
-- Chaves estrangeiras
IDCliente int not null,
IDLivro int not null,
-- Adicionando uma coluna para a data de aluguel de empréstimos
dataDevolucao DATETIME DEFAULT NULL,
dataAluguel DATETIME DEFAULT NOW(),
foreign key (IDCliente) references Alunos(IDCliente),
foreign key (IDLivro) references Livros(IDLivro),
primary key (IDEmprestimo)
);


CREATE table Autores (
IDAutor int not null auto_increment,
nome VARCHAR(100) not null,
primary key (IDAutor)
);

CREATE table Livro_Autor (
IDLivro int not null,
IDAutor int not null,
foreign key (IDLivro) references Livros(IDLivro),
foreign key (IDAutor) references Autores(IDAutor)
);

-- Adicionando uma coluna para disponibilidade de livros

ALTER TABLE Livros ADD COLUMN disponibilidade VARCHAR(12) DEFAULT 'disponível';

-- Validando os dados de devolução do empréstimo
ALTER TABLE Empréstimos ADD CONSTRAINT devolucaoValida CHECK (dataDevolucao >= dataAluguel);
-- Validando o estoque para empréstimos
ALTER TABLE Livros ADD CONSTRAINT estoqueValido CHECK (Estoque >= 0);

-- Trigger para atualização de estoque no caso de empréstimo 
DELIMITER $$
CREATE TRIGGER atualiza_EstoqueEmprestimo BEFORE INSERT ON Empréstimos 
FOR EACH ROW 
	BEGIN
		DECLARE estoque_atual INT;
        select Estoque INTO estoque_atual FROM Livros WHERE IDLivro = NEW.IDLivro;
        
        IF estoque_atual <= 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não foi possível emprestar: estoque insuficiente';
		ELSE
			UPDATE Livros SET Estoque = Estoque - 1 WHERE IDLivro = NEW.IDLivro;
		END IF;
	END$$
DELIMITER ;
-- Trigger para a devolução de empréstimo
DELIMITER $$
CREATE TRIGGER atualiza_EstoqueDevolucao AFTER UPDATE ON Empréstimos 
FOR EACH ROW BEGIN 
	IF OLD.dataDevolucao IS NULL AND NEW.dataDevolucao IS NOT NULL THEN 
		UPDATE Livros SET Estoque = Estoque + 1 WHERE IDLivro = NEW.IDLivro;
        END IF;
END$$
DELIMITER ;

-- inserção de dados na tabela Alunos, Livros e Autores.

-- Inserir 20 Autores (escritores brasileiros ou com obras brasileiras relevantes)
INSERT INTO Autores (nome) VALUES
('Machado de Assis'),
('Clarice Lispector'),
('Jorge Amado'),
('Carlos Drummond de Andrade'),
('Cecília Meireles'),
('Ariano Suassuna'),
('Graciliano Ramos'),
('Monteiro Lobato'),
('Lygia Fagundes Telles'),
('Rubem Fonseca'),
('Nélida Piñon'),
('Erico Veríssimo'),
('Manuel Bandeira'),
('Mário de Andrade'),
('Oswald de Andrade'),
('Rachel de Queiroz'),
('Fernando Sabino'),
('Paulo Coelho'),
('Zélia Gattai'),
('Moacyr Scliar');

-- Inserir 20 Livros (clássicos da literatura brasileira)
INSERT INTO Livros (titulo, Estoque) VALUES
('Dom Casmurro', FLOOR(RAND() * 10) + 1),
('Memórias Póstumas de Brás Cubas', FLOOR(RAND() * 10) + 1),
('O Cortiço', FLOOR(RAND() * 10) + 1),
('Capitães da Areia', FLOOR(RAND() * 10) + 1),
('Gabriela, Cravo e Canela', FLOOR(RAND() * 10) + 1),
('Vidas Secas', FLOOR(RAND() * 10) + 1),
('A Hora da Estrela', FLOOR(RAND() * 10) + 1),
('Sagarana', FLOOR(RAND() * 10) + 1),
('Grande Sertão: Veredas', FLOOR(RAND() * 10) + 1),
('O Quinze', FLOOR(RAND() * 10) + 1),
('Macunaíma', FLOOR(RAND() * 10) + 1),
('O Alienista', FLOOR(RAND() * 10) + 1),
('O Pagador de Promessas', FLOOR(RAND() * 10) + 1),
('A Paixão Segundo G.H.', FLOOR(RAND() * 10) + 1),
('O Tempo e o Vento', FLOOR(RAND() * 10) + 1),
('O Auto da Compadecida', FLOOR(RAND() * 10) + 1),
('Reinações de Narizinho', FLOOR(RAND() * 10) + 1),
('As Meninas', FLOOR(RAND() * 10) + 1),
('O Encontro Marcado', FLOOR(RAND() * 10) + 1),
('Dona Flor e Seus Dois Maridos', FLOOR(RAND() * 10) + 1);

-- Inserir 20 Alunos (dados fictícios com padrões brasileiros)
INSERT INTO Alunos (cpf, nome, cidade, telefone, cep, dataNascimento, email) VALUES
('111.222.333-44', 'Fernanda Silva', 'São Paulo', '11987654321', '01311-200', '1995-03-15', 'fernandasilva@email.com'),
('222.333.444-55', 'Ricardo Oliveira', 'Rio de Janeiro', '21987654321', '20040-030', '1998-07-22', 'ricardo.oliveira@email.com'),
('333.444.555-66', 'Juliana Santos', 'Belo Horizonte', '31987654321', '30190-001', '1993-11-05', 'julianasantos@email.com'),
('444.555.666-77', 'Carlos Pereira', 'Porto Alegre', '51987654321', '90010-150', '1997-01-30', 'carlos.pereira@email.com'),
('555.666.777-88', 'Amanda Costa', 'Salvador', '71987654321', '40026-010', '1996-09-12', 'amanda.costa@email.com'),
('666.777.888-99', 'Rodrigo Almeida', 'Brasília', '61987654321', '70070-100', '1994-12-08', 'rodrigo.almeida@email.com'),
('777.888.999-00', 'Patrícia Lima', 'Curitiba', '41987654321', '80010-030', '1999-04-18', 'patricia.lima@email.com'),
('888.999.000-11', 'Marcos Souza', 'Fortaleza', '85987654321', '60010-150', '1992-08-25', 'marcossouza@email.com'),
('999.000.111-22', 'Isabela Martins', 'Recife', '81987654321', '50030-230', '1991-06-14', 'isabelamartins@email.com'),
('000.111.222-33', 'Felipe Rocha', 'Manaus', '92987654321', '69005-040', '1998-02-28', 'felipe.rocha@email.com'),
('123.456.789-00', 'Larissa Mendes', 'Florianópolis', '48987654321', '88010-400', '1997-10-11', 'larissam@email.com'),
('234.567.890-11', 'Bruno Carvalho', 'Vitória', '27987654321', '29010-060', '1993-05-17', 'brunocarvalho@email.com'),
('345.678.901-22', 'Carolina Dias', 'Natal', '84987654321', '59014-500', '1996-03-03', 'carol.dias@email.com'),
('456.789.012-33', 'Gustavo Barbosa', 'João Pessoa', '83987654321', '58013-020', '1990-07-19', 'gustavo.barbosa@email.com'),
('567.890.123-44', 'Mariana Ribeiro', 'Maceió', '82987654321', '57010-020', '1995-12-24', 'mariribeiro@email.com'),
('678.901.234-55', 'Rafael Gomes', 'Teresina', '86987654321', '64001-350', '1999-09-07', 'rafagomes@email.com'),
('789.012.345-66', 'Beatriz Correia', 'Belém', '91987654321', '66010-010', '1994-01-15', 'beatrizcorreia@email.com'),
('890.123.456-77', 'Lucas Nascimento', 'Campo Grande', '67987654321', '79002-141', '1997-08-31', 'lucas.nasc@email.com'),
('901.234.567-88', 'Vanessa Castro', 'Goiânia', '62987654321', '74010-010', '1992-04-26', 'vanessa.castro@email.com'),
('012.345.678-99', 'Diego Fernandes', 'Aracaju', '79987654321', '49010-020', '1996-11-09', 'diego.fernandes@email.com');

-- Inserir empréstimos e devoluções
INSERT INTO Empréstimos (IDCliente, IDLivro, dataAluguel, dataDevolucao) VALUES
-- Empréstimos ativos (sem devolução)
(1, 3, '2023-08-01 10:00:00', NULL),
(3, 7, '2023-08-02 11:30:00', NULL),
(5, 12, '2023-08-03 09:15:00', NULL),
(7, 5, '2023-08-04 14:20:00', NULL),
(9, 18, '2023-08-05 16:45:00', NULL),

-- Empréstimos devolvidos no prazo
(2, 1, '2023-07-10 09:00:00', '2023-07-17 10:00:00'),
(4, 2, '2023-07-11 10:30:00', '2023-07-18 11:00:00'),
(6, 4, '2023-07-12 11:45:00', '2023-07-19 09:30:00'),
(8, 6, '2023-07-13 14:00:00', '2023-07-20 15:15:00'),
(10, 8, '2023-07-14 15:20:00', '2023-07-21 16:40:00'),

-- Empréstimos com atraso na devolução
(11, 9, '2023-07-01 08:30:00', '2023-07-20 10:00:00'),
(13, 10, '2023-07-02 10:00:00', '2023-07-22 11:30:00'),
(15, 11, '2023-07-03 11:15:00', '2023-07-25 14:00:00'),
(17, 13, '2023-07-04 14:30:00', '2023-07-26 15:45:00'),
(19, 14, '2023-07-05 16:00:00', '2023-07-28 17:20:00'),

-- Empréstimos recentes
(12, 15, '2023-08-10 09:30:00', NULL),
(14, 16, '2023-08-11 10:45:00', NULL),
(16, 17, '2023-08-12 11:20:00', NULL),
(18, 19, '2023-08-13 14:10:00', NULL),
(20, 20, '2023-08-14 15:30:00', NULL);

-- Associar livros e autores (relacionamentos não repetidos)
INSERT INTO Livro_Autor (IDLivro, IDAutor) VALUES
(1, 1), (2, 1), (3, 7), (4, 3), (5, 3),
(6, 7), (7, 2), (8, 11), (9, 11), (10, 16),
(11, 14), (12, 1), (13, 6), (14, 2), (15, 12),
(16, 6), (17, 8), (18, 9), (19, 17), (20, 3);

-- Adicionar associações extras para alguns livros
INSERT INTO Livro_Autor (IDLivro, IDAutor) VALUES
(1, 4), (5, 19), (9, 15), (12, 18), (20, 10);

-- Atualizar disponibilidade dos livros baseado no estoque atual
-- UPDATE Livros SET disponibilidade = IF(Estoque > 0, 'disponível', 'indisponível');

-- Demonstração dos dados inseridos pelo insert

-- Dados contidos na tabela Alunos
SELECT * from Alunos;

-- Dados contidos na tabela Livros
SELECT * from Livros;

-- Dados inseridos na tabela de Autores
SELECT * from Autores;

-- Demonstração das relações contidas em Livro_Autor
SELECT * from Livro_Autor;
