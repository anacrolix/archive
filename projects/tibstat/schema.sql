CREATE TABLE death (stamp text not null, victim not null, killer not null, lasthit not null, isplayer not null, level integer not null, unique(stamp, victim, killer));
CREATE TABLE online (name not null, stamp not null, unique (name, stamp));
CREATE TABLE player(name unique not null, level, vocation, guild, account_status, created, residence, sex, last_login, world, deletion, former_names);
CREATE TABLE world (name not null unique);
CREATE INDEX idx_death_stamp ON death (stamp COLLATE stamp_collation DESC);
CREATE INDEX idx_online_stamp ON online (stamp COLLATE stamp_collation DESC);
CREATE INDEX idx_unique_death ON death (stamp COLLATE stamp_collation DESC, victim);
