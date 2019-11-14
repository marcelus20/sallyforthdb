

DELIMITER //
CREATE PROCEDURE insert_player(IN id INT, IN name_ text, IN vocation text)
begin
	INSERT INTO recordable (name) VALUE (name_);
    INSERT INTO taxonomy VALUE (id, 'vulnerable');
    INSERT INTO vulnerable VALUE (id, 'player');
    INSERT INTO skills (vulnerable_id) VALUE (id);
    INSERT INTO healthy (vulnerable_id) VALUE (id);
    INSERT INTO players VALUE (id, vocation);
end //
DELIMITER ;

CREATE VIEW see_players AS 
SELECT r.id 'PLAYER ID',
 r.name 'PLAYER NAME',
 t.taxonomy_type 'GROUP',
 v.vulnerable_type 'SUB GROUP',
 s.level 'LEVEL' ,
 s.hitpoint 'HP',
 s.manapoint 'MP',
 s.capacity 'CAPACITY',
 s.magiclevel 'MAGIC LEVEL' ,
 s.swordfighting 'SWORD FIGHTING',
 s.axefighting 'AXE FIGHTING' ,
 s.clubfighting 'CLUB FIGHTING',
 s.fishing 'FISHING',
 h.current_hitpoint 'CURRENT HP' ,
 h.current_manapoint 'CURRENT MP',
 h.stamina 'STAMINA' 
 FROM recordable r 
	JOIN taxonomy t ON t.taxonomy_id = r.id 
    JOIN vulnerable v ON t.taxonomy_id = v.vulnerable_id
    JOIN skills s ON s.vulnerable_id = v.vulnerable_id
    JOIN healthy h ON h.vulnerable_id = v.vulnerable_id;

##@TODO = MAKE TRIGGERS TO AUTO GENERATE THE IDS.
CALL insert_player(1,'King Arthur', 'sorcerer');
CALL insert_player(2,'Kendran Eliorath', 'knight');
CALL insert_player(3,'Judith Warrs', 'sorcerer');
CALL insert_player(4,'Dimmus Borgirs', 'sorcerer');
CALL insert_player(5,'Bendran Helliot', 'paladin');
CALL insert_player(6,'Murdoc Mantova', 'knight');
CALL insert_player(7,'Pitter Tarazz', 'paladin');
CALL insert_player(8,'Julius Fandoble', 'druid');
CALL insert_player(9,'Almighty Fernandus', 'druid');


SELECT * FROM see_players;
