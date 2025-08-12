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
