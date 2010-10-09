----------------------------------------------------------------------------------
-- Map File                                                                     --
--                                                                              --
-- In dieser Datei stehen die entsprechenden externen NPC's, Trigger und        --
-- anderer Dinge.                                                               --
--                                                                              --
----------------------------------------------------------------------------------
--  Copyright 2008 - 2010 by Invertika Project                                  --
--                                                                              --
--  This file is part of Invertika.                                             --
--                                                                              --
--  Invertika is free software; you can redistribute it and/or modify it        --
--  under the terms of the GNU General  Public License as published by the Free --
--  Software Foundation; either version 2 of the License, or any later version. --
----------------------------------------------------------------------------------

require "scripts/lua/npclib"
require "scripts/ivklibs/invertika"
---require "scripts/ivklibs/trap"

dofile("data/scripts/ivklibs/warp.lua")

atinit(function()
 create_inter_map_warp_trigger(19003, 19003, 19003, 19003) --- Intermap warp
 create_npc("Zelan", 58, 132 * TILESIZE + 16, 21 * TILESIZE + 16, zelan_talk, nil) --- Zelan
 mana.trigger_create(20 * TILESIZE, 20 * TILESIZE, 22 * TILESIZE, 22 * TILESIZE, "trap_trigger_skorpions", 0, true) --- Trigger Trap

  create_npc("Test NPC", 200, 50 * TILESIZE + 16, 19 * TILESIZE + 16, npc1_talk, npclib.walkaround_small)
  create_npc("Teleporter", 201, 51 * TILESIZE + 16, 25 * TILESIZE + 16, npc4_talk, npclib.walkaround_wide)
  create_npc("Scorpion Tamer", 126, 45 * TILESIZE + 16, 25 * TILESIZE + 16, npc5_talk, nil)
  create_npc("Guard", 122, 58 * TILESIZE + 16, 15 * TILESIZE + 16, npc6_talk, npc6_update)
  create_npc("Fire Demon", 202, 58 * TILESIZE + 16, 35 * TILESIZE + 16, firedemon_talk, firedemon_update)
  create_npc("Post Box", 158, 45 * TILESIZE + 16, 22 * TILESIZE + 16, post_talk)
  create_npc("Fireworker", 158, 43 * TILESIZE, 23 * TILESIZE, fireworker_talk, npclib.walkaround_small)
  create_npc("Axe Trainer", 126, 65 * TILESIZE, 18 * TILESIZE, axetrainer_talk, nil)
  create_npc("Int NPC", 126, 68 * TILESIZE, 20 * TILESIZE, int_test_talk, nil)
  create_npc("String NPC", 126, 65 * TILESIZE, 20 * TILESIZE, string_test_talk, nil)
  create_npc("Plague NPC", 126, 70 * TILESIZE, 20 * TILESIZE, plague_talk, nil)
  create_npc("Jumping Bug NPC", 126, 75 * TILESIZE, 20 * TILESIZE, jump_status_talk, nil)
  create_npc("Monster spawn", 126, 80 * TILESIZE, 20 * TILESIZE, monster_spawn_talk, nil)
  create_npc("Emotional Palm", 127, 68 * TILESIZE, 25 * TILESIZE, emote_talk, emote_update)
  create_npc("Sitter", 201, 51 * TILESIZE + 16, 25 * TILESIZE + 16, nil, sitter_update)
  create_npc("Spinner", 201, 51 * TILESIZE + 16, 30 * TILESIZE + 16, nil, spinner_update)
  create_npc("Healer", 119, 54 * TILESIZE + 16, 32 * TILESIZE + 16, healer_talk, nil)


  mana.trigger_create(56 * TILESIZE, 32 * TILESIZE, 64, 64, "patrol_waypoint", 1, true)
  mana.trigger_create(63 * TILESIZE, 32 * TILESIZE, 64, 64, "patrol_waypoint", 2, true)

  mana.item_drop(58 * TILESIZE, 26 * TILESIZE, 654, 1);
  mana.item_drop(58 * TILESIZE, 27 * TILESIZE, 510, 10);
  mana.item_drop(58 * TILESIZE, 27 * TILESIZE, 521, 1);

  schedule_every(1 * HOURS + 30 * MINUTES, function()
    print("One and a half hour has passed on map 1-1")
  end)
end)

function zelan_talk(npc, ch)
    do_message(npc, ch, "Wo du bist? Im Vacare. Jeder neue kommt hier her bevor es raus geht in die große Welt. Also pass auf dich auf.")
	do_npc_close(npc, ch)
end


--- Falle auslösen
function trap_trigger_skorpions(ch, id)
  trap(ch, 21*TILESIZE, 21*TILESIZE,TILESIZE,TILESIZE,10)--- Bibliotheksfunktion
end

--- Bibliotheksfunktion
function trap(ch, x, y, width, height, monsterid)
  if (mana.being_type(ch) ~= TYPE_MONSTER) then --- Nur Player löst Falle aus
   local x1 = x - width/2
   local y1 = y - height/2
   local x2 = x + width/2
   local y2 = y + height/2
   local currentTime = os.time(t)
   local lastTime = get_quest_var(ch, "trap_last_activated")

   if (lastTime == nil) or (lastTime == "") then
     mana.chr_set_quest(ch, "trap_last_activated", currentTime)      
     print("trap case1: trap triggered for first time")
   elseif math.floor(currentTime-lastTime) > 20 then
     mana.chr_set_quest(ch, "trap_last_activated", currentTime)      
     --local spawned_monster = mana.monster_create(monsterid, x, y)
     --mana.being_say(spawned_monster,"Du bist in einen Hinterhalt geraten!")
     print("trap case2: create monster")
   else
     print("trap case3: be patient")
     --- nichts passiert
   end

 end
end

---Testfunktionen
count = 0
emo_state = EMOTE_SURPRISE

function emote_talk(npc, ch)
  if emo_state     == EMOTE_SURPRISE then
    state = "confused"
  elseif emo_state == EMOTE_SAD then
    state = "sad"
  elseif emo_state == EMOTE_HAPPY then
    state = "happy"
  end
  do_message(npc, ch, string.format("The emotional palm seems %s.", state))
  v = do_choice(npc, ch,
    "Stupid palm, you are ugly and everyone hates you!",
    "You are such a nice palm, let me give you a hug.",
    "Are you a cocos nucifera or a syagrus romanzoffiana?")

  if (v     == 1) then
    emo_state = EMOTE_SAD
  elseif (v == 2) then
    emo_state = EMOTE_HAPPY
  elseif (v == 3) then
    emo_state = EMOTE_SURPRISE
  end
  do_npc_close(npc, ch)
end

function emote_update(npc)
  emo_count = emo_count + 1
  if emo_count > 50 then
    emo_count = 0
    mana.effect_create(emo_state, npc)
  end
end


function int_test_talk(npc, ch)
    do_message(npc, ch, "Enter a number (50-100)")
    number = do_ask_integer(npc, ch, 50, 100, 75)
    do_message(npc, ch, string.format("You have entered %d ", number))
    do_npc_close(npc, ch)
end

function string_test_talk(npc, ch)
    do_message(npc, ch, "Enter a string")
    input = do_ask_string(npc, ch)
    do_message(npc, ch, string.format("You have entered '%s' Nice choice ! ", input))
    do_npc_close(npc, ch)
end

function patrol_waypoint(obj, id)
	if (mana.being_type(obj) ~= TYPE_MONSTER) then
		if (id == 1) then
			mana.chatmessage(obj, "you've reached patrol point 1")
			mana.being_say(obj, "I have reached patrol point 1")
		elseif (id == 2) then
			mana.chatmessage(obj, "you've reached patrol point 2")
			mana.being_say(obj, "I have reached patrol point 2")
		end
	end
end


function npc1_talk(npc, ch)
  on_remove(ch, function() print "Player has left the map." end);
  do_message(npc, ch, "Hello! I am the testing NPC.")
  local rights = mana.chr_get_rights(ch);

  if (rights >= 128) then
    do_message(npc, ch, "Oh mighty server administrator, how can I avoid your wrath?")
  elseif (rights >= 8) then
    do_message(npc, ch, "How can I be of assistance, sir gamemaster?")
  elseif (rights >= 4) then
    do_message(npc, ch, "What feature would you like to debug, developer?")
  elseif (rights >= 2) then
    do_message(npc, ch, "How can I assist you in your testing duties?")
  elseif (rights >= 1) then
    do_message(npc, ch, "What do you want, lowly player?")
  else
    do_message(npc, ch, "...aren't you supposed to be banned??")
  end

  local v = do_choice(npc, ch, "Guns! Lots of guns!",
                               "A Christmas party!",
                               "To buy.",
                               "To sell only the items you want to buy.",
                               "To sell whatever I want.",
                               "To make a donation.",
                               "Slowly count from one to ten.",
                               "Tablepush Test")
  if v == 1 then
    do_message(npc, ch, "Sorry, this is a heroic-fantasy game, I do not have any gun.")
  elseif v == 2 then
    local n1, n2 = mana.chr_inv_count(ch, 524, 511)
    if n1 == 0 or n2 ~= 0 then
      do_message(npc, ch, "Yeah right...")
    else
      do_message(npc, ch, "I can't help you with the party. But I see you have a fancy hat. I could change it into Santa's hat. Not much of a party, but it would get you going.")
      v = do_choice(npc, ch, "Please do.", "No way! Fancy hats are classier.")
      if v == 1 then
        mana.chr_inv_change(ch, 524, -1, 511, 1)
      end
    end
  elseif v == 3 then

    -- "To buy."
    local buycase = mana.npc_trade(npc, ch, false, { {533, 10, 20}, {535, 10, 30}, {537, 10, 50} })
    if buycase == 0 then
      do_message(npc, ch, "What do you want to buy?")
    elseif buycase == 1 then
      do_message(npc, ch, "I've got no items to sell.")
    else
      do_message(npc, ch, "Hmm, something went wrong... Ask a scripter to fix the buying mode!")
    end

  elseif v == 4 then

    -- "To sell only the items you want to buy."
    local sellcase = mana.npc_trade(npc, ch, true, { {533, 10, 20}, {535, 10, 30}, {511, 10, 200}, {524, 10, 300}, {508, 10, 500}, {537, 10, 25} })
    if sellcase == 0 then
      do_message(npc, ch, "Here we go:")
    elseif sellcase == 1 then
      do_message(npc, ch, "I'm not interested by your items.")
    else
      do_message(npc, ch, "Hmm, something went wrong... Ask a scripter to fix me!")
    end

  elseif v == 5 then

    -- "To sell whatever I want."
    local sellcase = mana.npc_trade(npc, ch, true)
    if sellcase == 0 then
      do_message(npc, ch, "Ok, what do you want to sell:")
    elseif sellcase == 1 then
      do_message(npc, ch, "I'm not interested by any of your items.")
    else
      do_message(npc, ch, "Hmm, something went wrong... Ask a scripter to fix this!")
    end

  elseif v == 6 then
    if mana.chr_money_change(ch, -100) then
      do_message(npc, ch, string.format("Thank you for you patronage! You are left with %d gil.", mana.chr_money(ch)))
      local g = tonumber(get_quest_var(ch, "001_donation"))
      if not g then g = 0 end
      g = g + 100
      mana.chr_set_quest(ch, "001_donation", g)
      do_message(npc, ch, string.format("As of today, you have donated %d gil.", g))
    else
      do_message(npc, ch, "I would feel bad taking money from someone that poor.")
    end
  elseif v == 7 then
    mana.being_say(npc, "As you wish...")
    schedule_in(2, function() mana.being_say(npc, "One") end)
    schedule_in(4, function() mana.being_say(npc, "Two") end)
    schedule_in(6, function() mana.being_say(npc, "Three") end)
    schedule_in(8, function() mana.being_say(npc, "Four") end)
    schedule_in(10, function() mana.being_say(npc, "Five") end)
    schedule_in(12, function() mana.being_say(npc, "Six") end)
    schedule_in(14, function() mana.being_say(npc, "Seven") end)
    schedule_in(16, function() mana.being_say(npc, "Eight") end)
    schedule_in(18, function() mana.being_say(npc, "Nine") end)
    schedule_in(20, function() mana.being_say(npc, "Ten") end)
  elseif v == 8 then
    function printTable (t)
      for k,v in pairs(t) do
        print (k, ":", v)
      end
    end
    local t1, t2, t3, t4, t5 = mana.test_tableget();
    print("---------------");
    print ("Table 1:");
    printTable (t1)
    print ("Table 2:");
    printTable (t2)
    print ("Table 3:");
    printTable (t3)
    print ("Table 4:");
    printTable (t4)
    print ("Table 5:");
    printTable (t5)
    print("---------------");
  end
  do_message(npc, ch, "See you later!")
  do_npc_close(npc, ch)
end

function npc4_talk(npc, ch)
  do_message(npc, ch, "You are currently on map "..mana.get_map_id()..". Where do you want to go?")
  local v = do_choice(npc, ch, "Map 1", "Map 3","Map 3, but a warpable place.")
  if v >= 1 and v <= 3 then
    do_message(npc, ch, "Are you really sure?")
    local w = do_choice(npc, ch, "Yes, I am.", "I still have a few things to do around here.")
    if w == 1 then
      if v == 1 then
        mana.chr_warp(ch, nil, 60 * TILESIZE, 50 * TILESIZE)
      elseif v == 2 then
        mana.chr_warp(ch, 3, 25 * TILESIZE, 25 * TILESIZE)
      else
        mana.chr_warp(ch, 3, 70 * TILESIZE, 60 * TILESIZE)
      end
    end
  end
  do_npc_close(npc, ch)
end

function npc5_talk(npc, ch)
  do_message(npc, ch, "I am the scorpion tamer. Do you want me to spawn some scorpions?")
  local answer = do_choice(npc, ch, "Yes", "No")
  if answer == 1 then
    local x = mana.posX(npc)
    local y = mana.posY(npc)
    m1 = mana.monster_create(1, x + TILESIZE, y + TILESIZE)
    m2 = mana.monster_create(1, x - TILESIZE, y + TILESIZE)
    m3 = mana.monster_create(1, x + TILESIZE, y - TILESIZE)
    m4 = mana.monster_create(1, x - TILESIZE, y - TILESIZE)

    on_death(m1, function() mana.being_say(npc, "NOOO!") end)
    on_death(m2, function() mana.being_say(npc, "Please stop this violence!") end)
    on_death(m3, function() mana.being_say(npc, "Stop slaughtering my scorpions!") end)
    on_death(m4, function() mana.being_say(npc, "Leave my scorpions alone!") end)
    on_death(m4, function() mana.being_say(m4, "AAARGH!") end)

  end
  do_npc_close(npc, ch)
end

local guard_position = 1

function npc6_talk(npc, ch)
  do_message(npc, ch, "I'm moving....")
  do_npc_close(npc, ch)

  if guard_position == 1 then
    mana.being_walk(npc, 61 * TILESIZE + 16, 15 * TILESIZE + 16, 2.5)
    guard_position = 2
  else
    mana.being_walk(npc, 55 * TILESIZE + 16, 15 * TILESIZE + 16, 2.5)
    guard_position = 1
  end
end

function npc6_update(npc)
  local r = math.random(0, 100)
  if (r == 0) then
    mana.being_say(npc, "*humhumhum*")
  end
  if (r == 1) then
    mana.being_say(npc, "guarding the city gate is so much fun *sigh*")
  end
  if (r == 2) then
    mana.being_say(npc, "can't someone order me to walk to the other side of the gate?")
  end
end


function firedemon_talk(npc, ch)
  do_message(npc, ch, "Burn, puny mortals! BURN! BUUUURN!!!")
  do_npc_close(npc, ch)
end

local firedemon_timer = 0;

function firedemon_update(npc)
	firedemon_timer = firedemon_timer + 1
	if (firedemon_timer == 5) then
	  firedemon_timer = 0
	  local victims = mana.get_beings_in_circle(mana.posX(npc), mana.posY(npc), 64)
	  local i = 1;
	  while (victims[i]) do
	    mana.being_damage(victims[i], 20, 10, 32000, DAMAGE_MAGICAL, ELEMENT_FIRE)
		i = i + 1
	  end
	end

	npclib.walkaround_map(npc)
end

function post_talk(npc, ch)
  do_message(npc, ch, "Hello " .. mana.being_get_name(ch))
  local strength = mana.being_get_attribute(ch, ATTR_STRENGTH)
  do_message(npc, ch, "You have " .. tostring(strength) .. " strength")
  do_message(npc, ch, "What would you like to do?")
  local answer = do_choice(npc, ch, "View Mail", "Send Mail", "Nothing")
  if answer == 1 then
    local sender, post = getpost(ch)
    if sender == "" then
      do_message(npc, ch, "No Post right now, sorry")
    else
      do_message(npc, ch, tostring(sender) .. " sent you " .. tostring(post))
    end
  end
  if answer == 2 then
    do_post(npc, ch)
  end
  do_npc_close(npc, ch)
end

function fireworker_talk(npc, ch)
  do_message(npc, ch, "Do you want some fireworks?")
  local answer = do_choice(npc, ch, "Wheee! Fireworks", "Nah, thanks.")
  if answer == 1 then
    local x = mana.posX(npc)
    local y = mana.posY(npc)
      for c = 0, 25 do
        schedule_in (c, function()
          mana.effect_create(c, x + math.random(-200, 200), y + math.random(-200, 200))
        end)
      end
  end
  do_npc_close(npc, ch)
end

function axetrainer_talk(npc, ch)
  do_message(npc, ch, "I am the axe trainer. Do you want to get better at using axes?")
  local answer = do_choice(npc, ch, "Please train me, master.", "I am good enough with axes.")
  if answer == 1 then
    local newexp = mana.chr_get_exp(ch, SKILL_WEAPON_AXE) + 100
    local nextlevel = mana.exp_for_level(mana.being_get_attribute(ch, SKILL_WEAPON_AXE) + 1)
    mana.chr_give_exp(ch, SKILL_WEAPON_AXE, 100)
    local message = "I gave you 100 axe exp."
    if newexp > nextlevel then
      message = message.." This should be enough to reach the next level."
    else
      message = message.." You will still need "..tostring(nextlevel - newexp).." exp to reach the next level."
    end
    message = message.." I should really stop doing this when the server goes live."
    do_message(npc, ch, message)
  end
  do_npc_close(npc, ch)
end

function plague_talk(npc, ch)
  do_message(npc, ch, "I don't feel so good...")
  do_npc_close(npc, ch)
  mana.being_apply_status(ch, 1, 6000) -- Give plauge for 6000 ticks (I.E. 10 minutes)
end

function jump_status_talk(npc, ch)
  mana.being_apply_status(ch, 2, 6000) -- Give jumping bug
  do_message(npc, ch, "Now you have the jumping bug")
  do_npc_close(npc, ch)
end

function monster_spawn_talk(npc, ch)
  local x = mana.posX(npc)
  local y = mana.posY(npc)
  monster = mana.monster_create(1, x + TILESIZE, y + TILESIZE)
  mana.monster_load_script(monster, "testmonster.lua")
end

function sitter_update(npc)
  if mana.being_get_action(npc) == ACTION_SIT then
    if math.random(30) == 1 then
      mana.being_set_action(npc, ACTION_STAND)
    end
  else -- walking or standing
    if math.random(60) == 1 then
      mana.being_set_action(npc, ACTION_SIT)
    else
      npclib.walkaround_small(npc)
    end
  end
end

local spinner_timer = 0

function spinner_update(npc)
  spinner_timer = spinner_timer + 1
  if spinner_timer == 10 then
    spinner_timer = 0

    direction = mana.being_get_direction(npc)
    if direction == DIRECTION_UP then
      direction = DIRECTION_RIGHT
    elseif direction == DIRECTION_DOWN then
      direction = DIRECTION_LEFT
    elseif direction == DIRECTION_LEFT then
      direction = DIRECTION_UP
    elseif direction == DIRECTION_RIGHT then
      direction = DIRECTION_DOWN
    else
      direction = DIRECTION_DOWN -- set inital direction
    end

    mana.being_set_direction(npc, direction)
  end
end


function healer_talk(npc, ch)
	do_message(npc, ch, "Do you need healing?")
	local c = do_choice(npc, ch, "Heal me fully", "Heal 100 HP", "Don't heal me")
	if c == 1 then
		mana.being_heal(ch)
	elseif c == 2 then
		mana.being_heal(ch, 100)
	end
	
	do_npc_close(npc, ch)
end