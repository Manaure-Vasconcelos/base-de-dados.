-- Seleciona a base de dados
use base_de_dados;
-- Mostra as tabelas da base de dadose
show tables;
-- Descreve as colunas da tabela
describe users;
-- Inserir registros na base de dados
insert into users 
(first_name, last_name, email, password_hash) values
("Helena", "A.", "1@email.com", "3_hash"),
("Joana", "B.", "2@email.com", "4_hash"),
("Rosana", "C.", "3@email.com", "5_hash");

/*----------------------------------------------------------*/

-- Seleciona colunas
select 
u.email uemail, u.id uid, u.first_name ufirst_name
from users as u;

/*----------------------------------------------------------*/

-- where filtra registros
-- operadores de comparação = < <= > >= <> !=
-- operadores lógicos and e or
select * from users
where 
created_at < '2020-12-15 23:33:41'
and first_name = 'Luiz' 
and password_hash = 'a_hash';

/*----------------------------------------------------------*/

-- between seleciona um range
select * from users
where 
created_at between 
'2020-06-12 00:00:00' 
and '2020-09-04 23:59:59'
and id between 163 and 210;

/*----------------------------------------------------------*/

-- in seleciona elementos entre os valores enviados
select * from users
where id in (110,115,120,125,130,1000,12200,1212545)
and first_name in ('Luiz', 'Keelie');

/*----------------------------------------------------------*/

-- Seleciona users.id, profiles.id, profiles.bio
-- profiles.description, users.first_name
-- da tabela users e da tabela profiles
-- onde o id do usuário for o mesmo que
-- o user_id de profiles
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name 
FROM users as u, profiles as p
WHERE u.id = p.user_id;

/*----------------------------------------------------------*/

-- Seleciona users.id, profiles.id, profiles.bio
-- profiles.description, users.first_name
-- da tabela users
-- unindo com a tabela profiles
-- quando a condição u.id = p.user_id for satisfeita
-- onde users.first_name terminar com "a"
-- ordena por users.first_name decrescente
-- limita 5 registros
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name
FROM users as u
INNER JOIN profiles p
ON u.id = p.user_id
WHERE u.first_name LIKE '%a'
ORDER BY u.first_name DESC
LIMIT 5;

/*----------------------------------------------------------*/

-- Seleciona users.id, profiles.id, profiles.bio
-- profiles.description, users.first_name
-- da tabela users (todos os registros da tabela da esquerda)
-- unindo com a tabela profiles (tabela da direita é opcional)
-- quando a condição u.id = p.user_id for satisfeita
-- onde users.first_name terminar com "a"
-- ordena por users.first_name decrescente
-- limita 5 registros
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name
FROM users as u
LEFT JOIN profiles p
ON u.id = p.user_id
WHERE u.first_name LIKE '%a'
ORDER BY u.first_name DESC
LIMIT 5;

/*----------------------------------------------------------*/

-- Seleciona users.id, profiles.id, profiles.bio
-- profiles.description, users.first_name
-- da tabela users (tabela da esquerda é opcional)
-- unindo com a tabela profiles (todos os registros da tabela da direita)
-- quando a condição u.id = p.user_id for satisfeita
-- onde users.first_name terminar com "a"
-- ordena por users.first_name decrescente
-- limita 5 registros
SELECT u.id as uid, p.id as pid,
p.bio, u.first_name
FROM users as u
RIGHT JOIN profiles p
ON u.id = p.user_id
WHERE u.first_name LIKE '%a'
ORDER BY u.first_name DESC
LIMIT 5;

/*----------------------------------------------------------*/

-- Configura um salário aleatório para users
update users set salary = round(rand() * 10000, 2);

select salary from users where 
salary BETWEEN 1000 and 1500
order by salary asc;

/*----------------------------------------------------------*/

INSERT INTO users_roles (user_id, role_id)
VALUES
(518, 4);

SELECT user_id, role_id  from users_roles WHERE
user_id = 518 and role_id = 4;

select 
id, 
(select id from roles order by rand() limit 1) as qualquer 
from users;

insert into users_roles (user_id, role_id)
select 
id, 
(select id from roles order by rand() limit 1) as qualquer 
from users;

/*----------------------------------------------------------*/

-- Atualiza registros com joins
select u.first_name, p.bio from users u
join profiles as p
on p.user_id = u.id
where u.first_name = 'Katelyn';

update users as u
join profiles as p
on p.user_id = u.id
set p.bio =  CONCAT(p.bio, ' atualizado') 
where u.first_name = 'Katelyn';

/*----------------------------------------------------------*/

-- Apaga registros com joins
select u.first_name, p.bio from users u
left join profiles as p
on p.user_id = u.id
where u.first_name = 'Katelyn';

delete p, u from users u
left join profiles as p
on p.user_id = u.id
where u.first_name = 'Katelyn';

/*----------------------------------------------------------*/

-- Group by - Agrupa valores
SELECT first_name, COUNT(id) as total FROM users
GROUP BY first_name
ORDER BY total DESC;

select u.first_name, COUNT(u.id) as total from users u
left join profiles as p
on p.user_id = u.id
WHERE u.id IN (617, 539, 537, 611)
GROUP BY first_name
ORDER BY total DESC
LIMIT 5;

/*----------------------------------------------------------*/

SELECT 
max(salary) as max_salary,
min(salary) as min_salary,
avg(salary) as avg_salary,
sum(salary) as sum_salary,
count(salary) as count_salary
FROM users;

select 
u.first_name,
max(u.salary) as max_salary,
min(u.salary) as min_salary,
avg(u.salary) as avg_salary,
sum(u.salary) as sum_salary,
COUNT(u.id) as total
from users u
left join profiles as p
on p.user_id = u.id
GROUP BY u.first_name
ORDER BY total DESC;

/*----------------------------------------------------------*/

SELECT pedidos.order_item_name produto,
  qtd.meta_value qtd,
  cor.meta_value cor,
  tamanho.meta_value tamanho,
  total.meta_value total
FROM wp_wc.wp_woocommerce_order_items pedidos
  LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta qtd 
    ON pedidos.order_item_id = qtd.order_item_id
    AND qtd.meta_key = '_qty'
  LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta cor 
    ON pedidos.order_item_id = cor.order_item_id
    AND cor.meta_key = 'pa_cor-da-camiseta'
  LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta tamanho 
    ON pedidos.order_item_id = tamanho.order_item_id
    AND tamanho.meta_key = 'pa_tamanho'
  LEFT JOIN wp_wc.wp_woocommerce_order_itemmeta 
    total ON pedidos.order_item_id = total.order_item_id
    AND (
      total.meta_key = '_line_total'
      OR total.meta_key = 'cost'
    )
WHERE pedidos.order_id = 123