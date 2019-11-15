#####fake data generation


###INSERTING PLAYERS
CALL insert_player('King Arthur', 'sorcerer');
CALL insert_player('Kendran Eliorath', 'knight');
CALL insert_player('Judith Warrs', 'sorcerer');
CALL insert_player('Dimmus Borgirs', 'sorcerer');
CALL insert_player('Bendran Helliot', 'paladin');
CALL insert_player('Murdoc Mantova', 'knight');
CALL insert_player('Pitter Tarazz', 'paladin');
CALL insert_player('Julius Fandoble', 'druid');
CALL insert_player('Almighty Fernandus', 'druid');


###inserting equipments
CALL insert_equipment('Royal Helment','56', '29', @id);
CALL insert_equipment('Elven Legs','30', '12', @id);
CALL insert_equipment('Medusa Shield','12', '33', @id);
CALL insert_equipment('Crown Armor','140', '70', @id);
CALL insert_equipment('Demon Shield','70', '50', @id);


##inserting weapons
CALL insert_equipment_weapon('Fire Sword','56', '35', '23');
CALL insert_equipment_weapon('Sword','78', '16', '10');
CALL insert_equipment_weapon('Knight Axe','48', '36', '15');
CALL insert_equipment_weapon('Giant Sword','110', '45', '27');
CALL insert_equipment_weapon('War Hamer','70', '41', '9');






SELECT * FROM see_players;
SELECT * FROM see_equipment;
SELECT * FROM see_weapons;


