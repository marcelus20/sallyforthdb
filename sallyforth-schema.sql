DROP SCHEMA IF EXISTS sallyforth;
CREATE SCHEMA sallyforth;
USE sallyforth;

CREATE TABLE recordable(
	id int(11) not null,
    name varchar(70) not null
);

CREATE TABLE taxonomy(
	taxonomy_id int(11) not null,
    taxonomy_type SET('vulnerable', 'item', 'spell')
);

CREATE TABLE vulnerable(
	vulnerable_id int(11) not null,
    vulnerable_type set('monster', 'npc', 'player') not null
);

CREATE TABLE skills(
	vulnerable_id int(11) not null,
    level int(5) not null default(1),
    hitpoint int(5) not null default(150),
    manapoint int(7) not null default(45),
    capacity int(4) not null default(180),
    magiclevel int(3) not null default(0),
    swordfighting int(3) not null default(10),
    axefighting int(3) not null default(10),
    clubfighting int(3) not null default(10),
    fishing int(3) not null default(10)
);

CREATE TABLE healthy(
	vulnerable_id int(11) not null,
	current_hitpoint int(5) not null default(150),
	current_manapoint int(5) not null default(45),
    stamina double not null default(40.0)
);

CREATE TABLE monsters(
	vulnerable_id int(11) not null,
    respawn_time int(3)
);

CREATE TABLE npcs(
	vulnerable_id int(11) not null,
    profession enum('merchant', 'loremaster', 'banker', 'king', 'professor', 'scientist')
);

CREATE TABLE players(
	vulnerable_id int(11) not null,
    vocation enum('knight', 'sorcerer', 'paladin', 'druid')
);

##SPELLS TABLE

CREATE TABLE spells(
	spell_id int(11) not null,
    mana_to_spend int(7) not null default(20)
);

## THE SPELL EFFECT 1 TO 1
CREATE TABLE effect(
	spell_id int(11) not null,
    effect_name varchar(25) not null,
    effect_efficiency int(3) not null,
    effect_description varchar(500)
);


##ITEM RELATION
CREATE TABLE item(
	item_id int(11) not null,
    weight int(3) not null,
    item_type enum('equipment', 'consumable', 'accessory')
);


##TABLES OF ACCESSORIES
CREATE TABLE effectiveness(
	item_id int(11) not null,
    item_effect int(2)
);


##TABLES OF POTIONS OR LIQUIDS
CREATE TABLE healability(
	item_id int(11) not null,
    manapoints_to_heal int(7),
    hitpoints_to_heal int(5)
);

##TABLE OF EQUIPMENTS
CREATE TABLE physicality(
	item_id int(11) not null,
    defense int(5)
);
##table of equipments that are just weapons
CREATE TABLE weapons(
	physicality_id int(11) not null,
    attack int(7)
);


###junction tables
CREATE TABLE spells_learned(
	spell_id int(11) not null,
    vulnerable_id int(11) not null
);

CREATE TABLE associations(
	association_id int(11),
	item_id int(11) not null,
    vulnerable_id int(11) not null,
    association_type enum('purchase', 'sell', 'drop', 'possess')
);



##FK CONSTRAINTS ASSIGNMENT
ALTER TABLE recordable
ADD CONSTRAINT recordablepk
primary key (id, name),
MODIFY id int(11) auto_increment;

ALTER TABLE taxonomy
ADD CONSTRAINT taxonomyfk
foreign key (taxonomy_id) references recordable(id);

ALTER TABLE vulnerable
ADD CONSTRAINT vulnerablefk
foreign key (vulnerable_id) references taxonomy(taxonomy_id);

ALTER TABLE skills
ADD CONSTRAINT skillsfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);

ALTER TABLE healthy
ADD CONSTRAINT healthyfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);

ALTER TABLE monsters
ADD CONSTRAINT monstersfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);

ALTER TABLE npcs
ADD CONSTRAINT npcsfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);

ALTER TABLE players
ADD CONSTRAINT playersfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);

ALTER TABLE spells
ADD CONSTRAINT spellsfk
foreign key (spell_id) references taxonomy(taxonomy_id);

ALTER TABLE effect
ADD CONSTRAINT effectfk
foreign key (spell_id) references spells(spell_id);

ALTER TABLE item
ADD CONSTRAINT itemfk
foreign key (item_id) references taxonomy(taxonomy_id);

ALTER TABLE effectiveness
ADD CONSTRAINT effectivenessfk
foreign key (item_id) references item(item_id);

ALTER TABLE healability
ADD CONSTRAINT healabilityfk
foreign key (item_id) references item(item_id);

ALTER TABLE physicality
ADD CONSTRAINT phisicalityfk
foreign key (item_id) references item(item_id);

ALTER TABLE weapons
ADD CONSTRAINT weaponfk
foreign key(physicality_id) references physicality(item_id);

ALTER TABLE spells_learned
ADD CONSTRAINT spells_learned_spell_idfk
foreign key (spell_id) references item(item_id),
ADD CONSTRAINT spells_learned_vulnerable_idfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);


ALTER TABLE associations
ADD CONSTRAINT association_item_idfk
foreign key (item_id) references item(item_id),
ADD CONSTRAINT association_vulnerable_idfk
foreign key (vulnerable_id) references vulnerable(vulnerable_id);



##PK CONSTRAINT ASSIGNMENTS

ALTER TABLE taxonomy
ADD CONSTRAINT taxonomypk
primary key (taxonomy_id);

ALTER TABLE vulnerable
ADD CONSTRAINT vulnerablepk
primary key (vulnerable_id);

ALTER TABLE skills
ADD CONSTRAINT skillspk
primary key (vulnerable_id);

ALTER TABLE healthy
ADD CONSTRAINT healthypk
primary key (vulnerable_id);

ALTER TABLE monsters
ADD CONSTRAINT monsterspk
primary key (vulnerable_id);

ALTER TABLE npcs
ADD CONSTRAINT npcspk
primary key (vulnerable_id);

ALTER TABLE players
ADD CONSTRAINT playerspk
primary key (vulnerable_id);

ALTER TABLE spells
ADD CONSTRAINT spellspk
primary key (spell_id);

ALTER TABLE effect
ADD CONSTRAINT effectpk
primary key (spell_id);

ALTER TABLE item
ADD CONSTRAINT itempk
primary key (item_id);

ALTER TABLE effectiveness
ADD CONSTRAINT effectivenesspk
primary key (item_id);

ALTER TABLE healability
ADD CONSTRAINT healabilitypk
primary key (item_id);

ALTER TABLE physicality
ADD CONSTRAINT phisicalitypk
primary key (item_id);

ALTER TABLE weapons
ADD CONSTRAINT weaponpk
primary key (physicality_id);

ALTER TABLE spells_learned
ADD CONSTRAINT spells_learnedpk
primary key (spell_id, vulnerable_id);


ALTER TABLE associations
ADD CONSTRAINT associationpk
primary key (association_id, item_id, vulnerable_id),
MODIFY association_id int (11) auto_increment not null;



##INDEX CREATING
CREATE INDEX records_name ON recordable (name);




##CREATION OF A FUNCTION THAT MAPS AN ITEM NAME IT ITS ID
DROP FUNCTION IF EXISTS get_id;
DELIMITER //
CREATE FUNCTION get_id(name_ TEXT) RETURNS int READS sql data
BEGIN
	RETURN (SELECT id FROM recordable WHERE name = name_);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_taxonomy;
##CREATION OF A PROCEDURE THAT GENERATES A TAXONOMY AND RETURNS THE ID
DELIMITER //
CREATE PROCEDURE insert_taxonomy(IN name_ text, IN type text, OUT id int)
BEGIN
	DECLARE id_ INT(11) DEFAULT(0);
	INSERT INTO recordable (name) VALUE (name_);
    set id_ = get_id(name_);
    INSERT INTO taxonomy VALUE (id_, type);
    SET id = id_;
END //
DELIMITER ;


##CREATION OF A PROCEDURE THAT ADDS A NEW PLAYER TO THE SYSTEM WHEN RECENTLY CREATED
DROP PROCEDURE IF EXISTS insert_player;
DELIMITER //
CREATE PROCEDURE insert_player(IN name_ text, IN vocation text)
begin
	CALL insert_taxonomy(name_, 'vulnerable', @id);
    INSERT INTO vulnerable VALUE (@id, 'player');
    INSERT INTO skills (vulnerable_id) VALUE (@id);
    INSERT INTO healthy (vulnerable_id) VALUE (@id);
    INSERT INTO players VALUE (@id, vocation);
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_item;
DELIMITER //
CREATE PROCEDURE insert_item(IN name_ text , IN weight INT, IN item_type TEXT, OUT id int)
BEGIN
	CALL insert_taxonomy(name_, 'item', @id);
    INSERT INTO item VALUE (@id, weight, item_type);
    SET id = @id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_consumable;
DELIMITER //
CREATE PROCEDURE insert_consumable(IN name_ text, IN weight INT, IN manapoints_to_heal TEXT, IN hitpoints_to_heal TEXT)
BEGIN
	CALL insert_item(name_, weight, 'consumable', @id);
    INSERT INTO healability VALUE (@id, manapoints_to_heal, hitpoints_to_heal);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_equipment;
DELIMITER //
CREATE PROCEDURE insert_equipment(IN name_ text, IN weight INT, IN defense TEXT, OUT id INT)
BEGIN
	CALL insert_item(name_, weight, 'equipment', @id);
    INSERT INTO physicality VALUE (@id, defense);
    SET id = @id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_equipment_weapon;
DELIMITER //
CREATE PROCEDURE insert_equipment_weapon(IN name_ text, IN weight INT, IN attack TEXT, IN defense TEXT)
BEGIN
    CALL insert_equipment(name_, weight, defense, @id);
    
    INSERT INTO weapons VALUE (@id, attack);
END //
DELIMITER ;

DROP VIEW IF EXISTS see_players;
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




DROP VIEW IF EXISTS see_equipment;
CREATE VIEW see_equipment AS
SELECT 
	r.id 'ID',
    r.name 'NAME',
    #t.taxonomy_type 'GROUP',
    #i.item_type 'SUB GROUP',
    i.weight 'WEIGHT',
    p.defense 'DEFENSE' 
    FROM recordable r 
		JOIN taxonomy t ON r.id = t.taxonomy_id
        JOIN item i ON i.item_id = r.id
        JOIN physicality p ON p.item_id = r.id;

DROP VIEW IF EXISTS see_weapons;
CREATE VIEW see_weapons AS
SELECT 
	s.id 'ID',
    s.name 'NAME',
    s.weight 'WEIGHT',
    s.defense 'DEFENSE',
    w.attack 'ATTACK' 
    FROM see_equipment s JOIN weapons w ON w.physicality_id = s.ID;