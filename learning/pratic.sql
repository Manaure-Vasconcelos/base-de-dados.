-- Inserindo usuario.

INSERT INTO users (first_name, last_name, email, password_hash) VALUES ("John", "sousa", "sousa@gmail.com", 135564);

-- Inserindo profile aos users.

INSERT INTO profiles (bio, user_id) 
SELECT CONCACT("OK", u.first_name), u.id FROM users AS u
WHERE id BETWEEN 106 AND 114;

-- Inserindo uma permisão para os users.

INSERT INTO users_roles (user_id, role_id)
SELECT id, (SELECT id FROM roles r ORDER BY RAND() LIMIT 1) FROM users u WHERE id BETWEEN 106 AND 114;

-- Listar e ordenar.

SELECT id, first_name FROM users u 
WHERE id BETWEEN 106 AND 114
ORDER BY id DESC;

-- Atualiza um users

UPDATE users SET first_name = 'INSERT NAME 1' WHERE id = 106;

-- Removendo uma permissão.

DELETE FROM users_roles 
WHERE user_id = (SELECT id  FROM users WHERE id = 106) 
AND role_id = (SELECT id FROM roles WHERE id = 2);

-- Removendo um usuário que tem a permissão "PUT"

delete u
from users u
inner join users_roles ur on u.id = ur.user_id 
inner join roles r on ur.role_id = r.id
where r.name  = 'PUT' and u.id = 624;

-- Selecionando usuários com perfís e permissões (obrigatório)

SELECT u.id as uid, u.first_name, r.name, p.bio 
from users u
inner join users_roles ur on u.id = ur.user_id 
inner join roles r on ur.role_id = r.id
inner join profiles p on p.user_id = u.id;

-- Selecionando usuários com perfís e permissões (opcional)

SELECT u.id as uid, u.first_name, r.name, p.bio 
from users u
left join users_roles ur on u.id = ur.user_id 
left join roles r on ur.role_id = r.id
left join profiles p on p.user_id = u.id;

-- Selecionando usuários com perfís e permissões ordenando por salário
SELECT u.id as uid, u.first_name, r.name, p.bio, u.salary 
from users u
left join users_roles ur on u.id = ur.user_id 
left join roles r on ur.role_id = r.id
left join profiles p on p.user_id = u.id
order by u.salary ASC;