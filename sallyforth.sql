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

##inserting liquids
CALL insert_consumable('Health Potion','2', 100, 0);
CALL insert_consumable('Strong Health Potion', 4, 500, 0);
CALL insert_consumable('Mana Potion', 3,'500', '12');
CALL insert_consumable('Flask of Poison','2', '0', '-100');
CALL insert_consumable('Cup of Water','1', 0, 0);
CALL insert_consumable('Flask of Blood','4', '0', '0');

CALL insert_npc('Josh', 'merchant');
CALL insert_npc('Eva', 'banker');
CALL insert_npc('Hero', 'loremaster');
CALL insert_npc('Rachel', 'professor');
CALL insert_npc('Lira', 'scientist');
CALL insert_npc('Sallyus, The King', 'king');

CALL insert_monster('Goblin', 3, 10);
CALL insert_monster('Demon', 1, 200);
CALL insert_monster('Juggernault', 2, 500);
CALL insert_monster('Dragon', 2, 120);
CALL insert_monster('Basilisk', 4, 33);
CALL insert_monster('Scarab', 1, 24);




SELECT * FROM see_players;
SELECT * FROM see_equipment;
SELECT * FROM see_weapons;
SELECT * FROM see_consumables;
SELECT * FROM see_npcs;
SELECT * FROM see_monsters;