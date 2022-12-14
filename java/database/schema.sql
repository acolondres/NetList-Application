BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS lists;
DROP TABLE IF EXISTS retailers;
DROP TABLE IF EXISTS user_list;
DROP TABLE IF EXISTS group_user;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS category_item;

CREATE TABLE users (
	user_id SERIAL,
	username varchar(50) NOT NULL UNIQUE,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50),
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

CREATE TABLE groups (
    group_id SERIAL,
    group_name varchar(100) NOT NULL UNIQUE,
    group_key varchar(8),
    owner_id integer NOT NULL,
    CONSTRAINT PK_group PRIMARY KEY (group_id),
    CONSTRAINT FK_group_owner FOREIGN KEY (owner_id) REFERENCES users (user_id)
);

CREATE TABLE category (
    category_id SERIAL,
    category_name varchar(100) NOT NULL UNIQUE,
    CONSTRAINT PK_category PRIMARY KEY (category_id)
);


CREATE TABLE group_user (
    group_user_id SERIAL,
    group_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    CONSTRAINT PK_group_user PRIMARY KEY (group_user_id),
    CONSTRAINT FK_group_user_group FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE CASCADE,
    CONSTRAINT FK_group_user_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE retailers(
                          retailer_id SERIAL,
                          name varchar(50) NOT NULL,
                          CONSTRAINT PK_retailer PRIMARY KEY (retailer_id)
);


CREATE TABLE lists(
    list_id SERIAL,
    owner_id INTEGER,
    name varchar(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    retailer_id INTEGER,
    group_id INTEGER,
    CONSTRAINT PK_list PRIMARY KEY (list_id),
    CONSTRAINT FK_list_user FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT FK_list_retailer FOREIGN KEY (retailer_id) REFERENCES retailers(retailer_id) ON DELETE CASCADE,
    CONSTRAINT FK_list_group_id FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);

CREATE TABLE items(
                      item_id SERIAL,
                      name varchar(50) NOT NULL,
                      description varchar(50),
                      category_id INTEGER,
                      list_id INTEGER,
                      quantity INTEGER NOT NULL DEFAULT 1,
                      item_note varchar(50),
                      is_purchased BOOLEAN NOT NULL DEFAULT FALSE,
                      created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                      user_id INTEGER,
                      CONSTRAINT PK_item PRIMARY KEY (item_id),
                      CONSTRAINT FK_list_item_list FOREIGN KEY (list_id) REFERENCES lists(list_id) ON DELETE CASCADE,
                      CONSTRAINT FK_list_item_user_id FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                      CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE

);

CREATE TABLE user_list(
    user_id INTEGER NOT NULL,
    list_id INTEGER NOT NULL,
    CONSTRAINT PK_user_list PRIMARY KEY (user_id, list_id),
    CONSTRAINT FK_user_list_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT FK_user_list_list FOREIGN KEY (list_id) REFERENCES lists(list_id) ON DELETE CASCADE
);

CREATE TABLE category_item(
    category_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    CONSTRAINT PK_category_item PRIMARY KEY (category_id, item_id),
    CONSTRAINT FK_category_item_category FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE,
    CONSTRAINT FK_category_item_item FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE
);

COMMIT TRANSACTION;
