/** 
 * @file schema.sql
 * @date 20.11.2022
 *
 * Schema of online chess data base
 */

USE chess_db;

-- Player entiry

CREATE TABLE IF NOT EXISTS player_table (
    `id`            INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `name`          VARCHAR(20) NOT NULL DEFAULT 'Player',
    `rating`        INT NOT NULL DEFAULT 0,
    `picture`       BLOB
);

-- Friend List entity

CREATE TABLE IF NOT EXISTS friend_list_table (
    `id`            INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `player_id`     INT UNSIGNED,
    `friend_id`     INT UNSIGNED,

    FOREIGN KEY (`player_id`)
        REFERENCES `player_table` (`id`)
        ON DELETE CASCADE,
    FOREIGN KEY (`friend_id`)
        REFERENCES `player_table` (`id`)
        ON DELETE CASCADE
);

-- Game entity

/*
 * Game state enumeration:
 *      Planned     0
 *      Active      1
 *      Suspended   2
 *      White Win   3
 *      Black Win   4
 *      Draw        5
 */

CREATE TABLE IF NOT EXISTS `game_table` (
    `id`            INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `w_player_id`   INT UNSIGNED,
    `b_player_id`   INT UNSIGNED,
    `game_state`    TINYINT UNSIGNED DEFAULT 0,

    FOREIGN KEY (`w_player_id`)
        REFERENCES `player_table` (`id`)
        ON DELETE CASCADE,
    FOREIGN KEY (`b_player_id`)
        REFERENCES `player_table` (`id`)
        ON DELETE CASCADE,

    CONSTRAINT `game_state_range` CHECK(`game_state` <= 5)
);

-- Chess piece move entity

CREATE TABLE IF NOT EXISTS `move_table` (
    `id`                BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `game_id`           INT UNSIGNED,
    `player_id`         INT UNSIGNED,
    `fen`               VARCHAR(128),
    `time_from_start`   INT UNSIGNED DEFAULT 0, /* Time from game started in seconds */

    FOREIGN KEY (`game_id`)
        REFERENCES `game_table` (`id`)
        ON DELETE CASCADE,
    FOREIGN KEY (`player_id`)
        REFERENCES `player_table` (`id`)
        ON DELETE CASCADE
);
