CREATE VIEW `maatjesproject mensen` AS
select 'maatje' as `Type`,
CASE
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) IS NULL THEN 'Onbekend'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 0 AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <= 17 THEN '0-17'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 17 AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <=35 THEN '17-35'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 35 AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <=55 THEN '35-55'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 55 THEN '55+'
END AS leeftijdsgroep,
CASE
	WHEN gender.label IS null or gender.label = '' THEN 'Onbekend'
    ELSE gender.label
END as gender,
CASE
  WHEN `status_17` is null then 'Onbekend'
  WHEN `status_17` = '' then 'Onbekend'
  ELSE `status_17`
END as `status`,
case civicrm_value_inschrijving_buddy_1.als_gezin_buddy_2
when 1 then 'Ja'
else 'Nee'
END AS `doet als gezin mee`
from civicrm_contact
LEFT JOIN civicrm_option_value gender on civicrm_contact.gender_id = gender.value
AND gender.option_group_id = 3
inner join `civicrm_value_inschrijving_buddy_1` on `civicrm_value_inschrijving_buddy_1`.entity_id = civicrm_contact.id
where contact_sub_type like '%Buddy%' and is_deleted = '0'

union
select 'statushouder' as `Type`,
CASE
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) IS NULL THEN 'Onbekend'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 0 AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <= 17 THEN '0-17'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 17 AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <=35 THEN '17-35'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 35 AND TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) <=55 THEN '35-55'
  WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) > 55 THEN '55+'
END AS leeftijdsgroep,
CASE
	WHEN gender.label IS null or gender.label = '' THEN 'Onbekend'
    ELSE gender.label
END as gender,
CASE
  WHEN `status_35` is null then 'Onbekend'
  WHEN `status_35` = '' then 'Onbekend'
  ELSE `status_35`
END as `status`,
case
	WHEN `gezinsleden_count`.`count` > 0 THEN 'Ja'
    ELSE 'Nee'
END as `gezin doet mee`
from civicrm_contact
inner join `civicrm_value_inschrijving_maatjesproject_statushouder__2` ON `civicrm_value_inschrijving_maatjesproject_statushouder__2`.entity_id = civicrm_contact.id
LEFT JOIN civicrm_option_value gender on civicrm_contact.gender_id = gender.value AND gender.option_group_id = 3
left join
  (select count(id) as count, gezinslid
    from
      (select civicrm_relationship.contact_id_a as gezinslid, civicrm_relationship.id from civicrm_relationship where civicrm_relationship.relationship_type_id IN (1, 2)
       union select civicrm_relationship.contact_id_b gezinslid, civicrm_relationship.id from civicrm_relationship where civicrm_relationship.relationship_type_id IN (1, 2)
      ) as gezinsleden
    group by gezinslid
  ) as gezinsleden_count on gezinsleden_count.gezinslid = civicrm_contact.id

where contact_sub_type like '%statushouder%' and is_deleted = '0'
and `status_35` != 'Niet in maatjes project';