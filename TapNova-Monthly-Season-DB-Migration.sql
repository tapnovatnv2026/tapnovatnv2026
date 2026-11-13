-- TapNova monthly season feature schema extension.
-- Back up D1 before running. This migration adds columns only; it does not delete or reset player data.
PRAGMA foreign_keys = ON;

ALTER TABLE missions ADD COLUMN event_type TEXT NOT NULL DEFAULT 'tap';
ALTER TABLE characters ADD COLUMN unlock_cost_energy INTEGER NOT NULL DEFAULT 0;
ALTER TABLE shop_items ADD COLUMN price_energy INTEGER NOT NULL DEFAULT 0;

-- Preserve the original Season 01 character Energy prices.
UPDATE characters SET unlock_cost_energy = CASE id
  WHEN 'nova_pilot' THEN 1000
  WHEN 'luna_guardian' THEN 2500
  WHEN 'meteor_rider' THEN 5000
  ELSE unlock_cost_energy END
WHERE season_id='moon-rush-01';

-- Season 02 character prices are separate from Season 01.
UPDATE characters SET unlock_cost_energy = CASE id
  WHEN 'starfall_nova' THEN 1500
  WHEN 'starfall_luna' THEN 3000
  WHEN 'starfall_comet' THEN 6000
  ELSE unlock_cost_energy END
WHERE season_id='starfall-02';

-- Map Season 02 mission event sources. Period remains in mission_type (daily/weekly/season).
UPDATE missions SET event_type = CASE id
  WHEN 's02_daily_tap' THEN 'tap'
  WHEN 's02_daily_spin' THEN 'spin'
  WHEN 's02_daily_pack' THEN 'sticker_pack_open'
  WHEN 's02_weekly_tap' THEN 'tap'
  WHEN 's02_weekly_spin' THEN 'spin'
  WHEN 's02_season_stickers' THEN 'unique_stickers'
  ELSE event_type END
WHERE season_id='starfall-02';

-- Map known Season 01 mission identifiers to the existing event log.
UPDATE missions SET event_type = CASE id
  WHEN 'daily_tap_5' THEN 'tap'
  WHEN 'daily_spin_1' THEN 'spin'
  WHEN 'daily_loot_1' THEN 'lootbox'
  WHEN 'weekly_tap_100' THEN 'tap'
  WHEN 'weekly_spin_10' THEN 'spin'
  WHEN 'season_sticker_5' THEN 'unique_stickers'
  ELSE event_type END
WHERE season_id='moon-rush-01';
