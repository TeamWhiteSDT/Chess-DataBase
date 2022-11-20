/** 
 * @file schema.sql
 * @date 20.11.2022
 *
 * Schema of online chess data base
 */

USE chess_db;

-- Player entiry

CREATE TABLE player_table (
    id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(20) NOT NULL DEFAULT 'Player',
    picture         BLOB
);

-- Friend List entity

CREATE TABLE friend_list_table (
    id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    player_1_id     INT UNSIGNED,
    player_2_id     INT UNSIGNED,

    FOREIGN KEY (player_1_id) REFERENCES player_table (id),
    FOREIGN KEY (player_2_id) REFERENCES player_table (id),
);

-- Game entity

/*
 * Game status enumeration:
 *      Planned     0
 *      Active      1
 *      Suspended   2
 *      Black Win   3
 *      White Win   4
 *      Draw        5
 */

CREATE TABLE game_table (
    id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    w_player_id     INT UNSIGNED,
    b_player_id     INT UNSIGNED,
    status          TINYINT UNSIGNED DEFAULT 0,

    FOREIGN KEY (w_player_id) REFERENCES player_table (id),
    FOREIGN KEY (b_player_id) REFERENCES player_table (id),

    CONSTRAINT status_range CHECK(status <= 5)
);

-- Chess piece move entity

/*
 * Chess piece type enumeration:
 *      Pawn        0
 *      Bishop      1
 *      Knight      2
 *      Rook        3
 *      Queen       4
 *      King        5
 */

 /*
  * Position notation:
  *     Linear notation
  *     a1 = 0,  a2 = 1,  ...,  a8 = 7,
  *     b1 = 8,  b2 = 9,  ...,  b8 = 5,
  *     ...
  *     h1 = 56, h2 = 57, ...,  h8 = 64
  */

CREATE TABLE move_table (
    id              BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    game_id         INT UNSIGNED,
    player_id       INT UNSIGNED,
    piece           TINYINT UNSIGNED,
    from_position   SMALLINT UNSIGNED NOT NULL,
    to_position     SMALLINT UNSIGNED NOT NULL,
    number          SMALLINT UNSIGNED NOT NULL, /* Number of move in the game */
    time_from_start INT UNSIGNED DEFAULT 0, /* Time from game started in seconds */

    FOREIGN KEY (game_id) REFERENCES game_table (id),
    FOREIGN KEY (player_id) REFERENCES player_table (id),

    CONSTRAINT position_range CHECK(from_position < 64),
    CONSTRAINT position_range CHECK(to_position < 64),
    CONSTRAINT piece CHECK(to_position <= 5)
);
