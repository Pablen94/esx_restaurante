SET @job_name = 'restaurante';
SET @society_name = 'society_restaurante';
SET @job_Name_Caps = 'Restaurante';







INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  (@job_name, 0, 'barman', 'Bartender', 1450, '{}', '{}'),
  (@job_name, 1, 'seguridad', 'Seguridad', 1450, '{}', '{}'),
  (@job_name, 2, 'logistica', 'Logistico', 3500, '{}', '{}'),
  (@job_name, 3, 'cocinero', 'Cocinero', 5000, '{}', '{}'),
  (@job_name, 4, 'boss', 'Dueño', 5000, '{}', '{}')
;
