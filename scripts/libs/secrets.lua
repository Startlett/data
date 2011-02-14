----------------------------------------------------------------------------------
-- Secrets-Modul - Funktionen fuer Geheimnisse                                  --
--                                                                              --
-- Dieses Modul stellt Grundfunktionen für Geheimnisse (hinter Geheimgängen)    --
-- zur Verfuegung                                                               --
--                                                                              --
----------------------------------------------------------------------------------
--  Copyright 2010 The Invertika Development Team                               --
--                                                                              --
--  This file is part of Invertika.                                             --
--                                                                              --
--  Invertika is free software; you can redistribute it and/or modify it        --
--  under the terms of the GNU General  Public License as published by the Free --
--  Software Foundation; either version 2 of the License, or any later version. --
----------------------------------------------------------------------------------

module("secrets", package.seeall)

-- Einige Konstanten
local QUEST_VAR_PREFIX = "secret"

-- Hier werden alle Geheimnisse gespeichert, secrets[schild] = text
local secrets = {}

-- Erzeugt ein Geheimnis (am besten hinter einem Geheimgang o.ä., da es unsichtbar ist)
-- Position in TILES, nicht in Pixel
function create_secret(xpos, ypos, secretid, itemid, amount, moneyamount)
    mana.trigger_create(xpos*TILESIZE, ypos*TILESIZE, TILESIZE, TILESIZE, "secret_activate", secretid, true)
    secrets[secretid] = {}
    secrets[secretid][0] = itemid
    secrets[secretid][1] = amount
    secrets[secretid][2] = itemname
    secrets[secretid][3] = moneyamount
end

function secret_activate(being, secretid)
    -- Teste auf Spieler
    if mana.being_type(being) == TYPE_CHARACTER then
        -- Teste auf bereits gefunden
        local quest_var_name = get_quest_var_name(secretid)
        if mana.get_quest_var(being, quest_var_name) ~= nil then
            -- Geheimnis ausgeben
            mana.chr_set_quest(being, quest_var_name, 1)
            distribute_reward(being, secretid)
        end
    end
end

function get_quest_var_name(secretid)
    return QUEST_VAR_PREFIX .. tonumber(secretid)
end

function distribute_reward(being, secretid)
    mana.chatmessage(being, "Du hast ein Geheimnis gefunden!")
    if (secrets[secretid][3] ~= nil) and (secrets[secretid][2] ~= 0) then
        invertika.add_money(being, secrets[secretid][3])
    end
    if if (secrets[secretid][0] ~= nil) and (secrets[secretid][1] ~= nil) and (secrets[secretid][1] ~= 0) and (secrets[secretid][2] ~= nil) then
        invertika.add_items(being, secrets[secretid][0], secrets[secretid][1], secrets[secretid][2])
    end
end
