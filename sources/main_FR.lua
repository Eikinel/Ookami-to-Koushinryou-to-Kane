require("AnAL")

function love.load()
   -- FONTS --
   animeFont50 = love.graphics.setNewFont("res/font/animeace2_reg.ttf", 50)
   animeFont30 = love.graphics.setNewFont("res/font/animeace2_reg.ttf", 30)
   animeFont20 = love.graphics.setNewFont("res/font/animeace2_reg.ttf", 20)
   animeFont12 = love.graphics.setNewFont("res/font/animeace2_reg.ttf", 12)

   -- IMAGES --
   start_background = love.graphics.newImage("res/img/background_start.png");
   main_background = love.graphics.newImage("res/img/background.png");
   bourse_background = love.graphics.newImage("res/img/background_bourse.png");
   inventory_background = love.graphics.newImage("res/img/background_inventory.png");
   lose_background = love.graphics.newImage("res/img/background_lose.png");
   win_background = love.graphics.newImage("res/img/background_win.png");
   lima = love.graphics.newImage("res/img/lima.png");
   arrow = love.graphics.newImage("res/img/arrow.png");
   woodsign = love.graphics.newImage("res/img/woodsign.png");
   speed_x1 = love.graphics.newImage("res/img/speed_x1.png");
   speed_x2 = love.graphics.newImage("res/img/speed_x2.png");
   speed_x3 = love.graphics.newImage("res/img/speed_x3.png");
   pause_menu = love.graphics.newImage("res/img/pause_menu.png");
   bourse = love.graphics.newImage("res/img/bourse.png");
   glow = love.graphics.newImage("res/img/glow_sprites.png");
   anim_glow = newAnimation(glow, 241, 242, 0.09, 0)
   anim_glow:setMode("bounce")
   
   --SOUNDS --
   opening = love.audio.newSource("res/sound/opening.mp3")
   foule = love.audio.newSource("res/sound/foule.mp3")
   arigato = {love.audio.newSource("res/sound/arigato.mp3", "static"), love.audio.newSource("res/sound/arigato2.mp3", "static"), love.audio.newSource("res/sound/arigato3.mp3", "static"), love.audio.newSource("res/sound/arigato4.mp3", "static")}
   money = love.audio.newSource("res/sound/money.mp3", "static")
   lose = love.audio.newSource("res/sound/lose.mp3", "static")
   win = love.audio.newSource("res/sound/win.mp3", "static")

   money:setVolume(0.6)

   -- ITEMS PRICES --
   
   item1 = {15, 15}
   item2 = {30, 30}
   item3 = {80, 80}
   item4 = {100, 100}
   item5 = {300, 300}
   item1.b_min = 5
   item1.b_max = 20
   item2.b_min = 15
   item2.b_max = 40
   item3.b_min = 50
   item3.b_max = 100
   item4.b_min = 100
   item4.b_max = 200
   item5.b_min = 300
   item5.b_max = 400
   item1.taxe = 8 / 100
   item2.taxe = 13 / 100
   item3.taxe = 18 / 100
   item4.taxe = 15 / 100
   item5.taxe = 22 / 100
   item1.dt_nobuy = 1
   item2.dt_nobuy = 1
   item3.dt_nobuy = 1
   item4.dt_nobuy = 1
   item5.dt_nobuy = 1
   
   -- ITEMS VALUES FOR GRAPH ONLY --

   item1.b_add = 2
   item2.b_add = 5
   item3.b_add = 10
   item4.b_add = 20
   item5.b_add = 50
   item1.x = {150, 150}
   item2.x = {150, 150}
   item3.x = {150, 150}
   item4.x = {150, 150}
   item5.x = {150, 150}
   item1.y = {600, 600}
   item2.y = {600, 600}
   item3.y = {600, 600}
   item4.y = {600, 600}
   item5.y = {600, 600}

   -- INVENTORY --

   argent = 100
   item1.inventory = 0
   item2.inventory = 0
   item3.inventory = 0
   item4.inventory = 0
   item5.inventory = 0
   item1.total = 0
   item2.total = 0
   item3.total = 0
   item4.total = 0
   item5.total = 0
   
   -- OTHERS --

   states = {false, false, false, false, false, false, false, false, false, true, false}
   last_state = 1
   is_paused = false
   i = 2
   dtotal = 0   
   love.keyboard.setKeyRepeat = false
end

function love.update(dt)

   anim_glow:update(dt)
   if not is_paused then
      if (checkState() < 8) then
	 checkLoseOrWin()
	 i = 2
	 dtotal = dtotal + dt
	 if (item1.dt_nobuy > 0.8) then item1.dt_nobuy = item1.dt_nobuy - (dt / 10) end
      end

      if (dtotal >= 0.1) then
	 dtotal = dtotal - 0.1
	 while (item1[i]) do
	    i = i + 1
	 end
	 
	 if (i > 1026) then
	    while (i > 2) do
	       item1[i] = nil
	       item1.x[i] = nil
	       item1.y[i] = nil
	       
	       item2[i] = nil
	       item2.x[i] = nil
	       item2.y[i] = nil
	       
	       item3[i] = nil
	       item3.x[i] = nil
	       item3.y[i] = nil
	       
	       item4[i] = nil
	       item4.x[i] = nil
	       item4.y[i] = nil

	       item5[i] = nil
	       item5.x[i] = nil
	       item5.y[i] = nil
	       
	       i = i - 1
	    end
	 end
	 
	 item1[i] = math.abs(math.random(item1[i - 1] - (item1.inventory / 50) * item1.dt_nobuy - 1, item1[i - 1] + 1))
	 adjustPrice(item1[i], item1)
	 item1.x[i] = item1.x[i - 1] + 1
	 
	 item2[i] = math.abs(math.random(item2[i - 1] - (item2.inventory / 30) * item2.dt_nobuy - 2, item2[i - 1] + 2))
	 adjustPrice(item2[i], item2)
	 item2.x[i] = item2.x[i - 1] + 1
	 
	 item3[i] = math.abs(math.random(item3[i - 1] - (item3.inventory / 20) * item2.dt_nobuy - 3, item3[i - 1] + 3))
	 adjustPrice(item3[i], item3)
	 item3.x[i] = item3.x[i - 1] + 1
	 
	 item4[i] = math.abs(math.random(item4[i - 1] - (item4.inventory / 10) * item2.dt_nobuy - 4, item4[i - 1] + 4))
	 adjustPrice(item4[i], item4)
	 item4.x[i] = item4.x[i - 1] + 1
	 
	 item5[i] = math.abs(math.random(item5[i - 1] - (item5.inventory / 5) * item2.dt_nobuy - 5, item5[i - 1] + 5))
	 adjustPrice(item5[i], item5)
	 item5.x[i] = item5.x[i - 1] + 1
      end
   end
end

function love.mousepressed(x, y, button)
   if (button == "l") then

      -- Si on est en pause --
      if is_paused then
	 if ((x >= 530 and y >= 300) and (x <= 740 and y <= 330)) then is_paused = false
	 elseif ((x >= 500 and y >= 400) and (x <= 775 and y <= 430)) then
	    love.load()
	    setStatesFalse(1)
	    is_paused = false
	 elseif ((x >= 560 and y >= 500) and (x <= 705 and y <= 530)) then love.event.quit() end
	 	 
	 -- Si on est à l'écran de départ --
      elseif (states[1] == true) then
	 if ((x >= 610 and y >= 60) and (x <= 700 and y <= 80)) then setStatesFalse(2)
	 elseif ((x >= 605 and y >= 90) and (x <= 690 and y <= 110)) then setStatesFalse(3)
	 elseif ((x >= 595 and y >= 120) and (x <= 710 and y <= 140)) then setStatesFalse(4)
	 elseif ((x >= 575 and y >= 150) and (x <= 720 and y <= 170)) then setStatesFalse(5)
	 elseif ((x >= 605 and y >= 180) and (x <= 690 and y <= 200)) then setStatesFalse(6)
	 elseif ((x >= 1050 and y >= 20) and (x <= 1233 and y <= 180)) then setStatesFalse(7) end

	 -- Si on est dans l'inventaire --
      elseif (states[7] == true) then
	 if ((x >= 20 and y >= 620) and (x <= 230 and y <= 716)) then setStatesFalse(last_state) end
	 
	 -- Si on a perdu ou gagné --
      elseif (states[8] == true or states[9] == true) then
	 if ((x >= 500 and y >= 400) and (x <= 775 and y <= 430)) then
	    love.load()
	    setStatesFalse(1)
	 elseif ((x >= 570 and y >= 460) and (x <= 715 and y <= 490)) then love.event.quit() end
	 
	 -- Si on est au menu principal
      elseif (states[10] == true) then
	 if ((x >= 400 and y >= 350) and (x <= 840 and y <= 380)) then setStatesFalse(1)
	 elseif ((x >= 390 and y >= 450) and (x <= 855 and y <= 480)) then dofile("main.lua")
	 elseif ((x >= 550 and y >= 550) and (x <= 695 and y <= 580)) then love.event.quit() end
	 	 
	 -- Si on est dans les cours de la bourse --
      else
	 if ((x >= 20 and y >= 620) and (x <= 230 and y <= 716)) then setStatesFalse(1)
	 elseif ((x >= 360 and y >= 630) and (x <= 450 and y <= 645)) then buyItem(checkItem(), 1)
	 elseif ((x >= 360 and y >= 660) and (x <= 450 and y <= 675)) then buyItem(checkItem(), 5)
	 elseif ((x >= 360 and y >= 690) and (x <= 450 and y <= 705)) then buyItem(checkItem(), 10)
	 elseif ((x >= 880 and y >= 630) and (x <= 970 and y <= 645)) then sellItem(checkItem(), 1)
	 elseif ((x >= 880 and y >= 660) and (x <= 970 and y <= 675)) then sellItem(checkItem(), 5)
	 elseif ((x >= 880 and y >= 690) and (x <= 970 and y <= 705)) then sellItem(checkItem(), 10)
	 elseif ((x >= 1050 and y >= 20) and (x <= 1233 and y <= 180)) then setStatesFalse(7) end
      end
   end
end

function love.keypressed(key, isrepeat)
   if ((love.keyboard.isDown("escape") or love.keyboard.isDown("p")) and states[10] == false and not is_paused) then
      is_paused = true
      love.graphics.setColor(150, 150, 150)

   elseif ((love.keyboard.isDown("escape") or love.keyboard.isDown("p")) and states[10] == false and is_paused) then
      is_paused = false
      love.graphics.setColor(255, 255, 255)
   end
end

function love.draw()
  
   if (states[10] == false) then
      love.audio.stop(opening)
      love.audio.play(foule)
      writeGraph(0)
   end
   
   if (states[1] == true) then
      love.graphics.draw(main_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(bourse, 1050, 20)
      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.setFont(animeFont20)

      setColorOrNot(610, 60, 700, 80)
      love.graphics.print("Clou", 620, 60)
      
      setColorOrNot(605, 90, 690, 110)
      love.graphics.print("Poivre", 610, 90)
      
      setColorOrNot(595, 120, 710, 140)
      love.graphics.print("Armure", 605, 120)
      
      setColorOrNot(575, 150, 720, 170)
      love.graphics.print("Fourrure", 585, 150)
      
      setColorOrNot(605, 180, 690, 200)
      love.graphics.print("Pyrite", 605, 180)

      if not is_paused then
	 love.graphics.setColor(255, 255, 255)
      end
   end
   
   if (states[2] == true) then
      love.graphics.draw(bourse_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(bourse, 1050, 20)
      love.graphics.draw(arrow, 20, 620)
      love.graphics.draw(woodsign, 350, 620)
      love.graphics.draw(woodsign, 700, 620)      
      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.print("Cours de la bourse du clou", 370, 60)
      love.graphics.setFont(animeFont12)
      love.graphics.print("Taxe à la vente :", 550, 110)
      love.graphics.print(round(item1.taxe * 100, 2), 690, 110)
      love.graphics.print("%", 730, 110)
      buySellSigns(item1)      
      axesGraph(item1)
      writeGraph(item1)
   end

   if (states[3] == true) then
      love.graphics.draw(bourse_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(bourse, 1050, 20)
      love.graphics.draw(arrow, 20, 620)
      love.graphics.draw(woodsign, 350, 620)
      love.graphics.draw(woodsign, 700, 620)
      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.print("Cours de la bourse du poivre", 365, 60)
      love.graphics.setFont(animeFont12)
      love.graphics.print("Taxe à la vente :", 550, 110)
      love.graphics.print(round(item2.taxe * 100, 2), 690, 110)
      love.graphics.print("%", 730, 110)
      buySellSigns(item2)
      axesGraph(item2)
      writeGraph(item2)
   end

   if (states[4] == true) then
      love.graphics.draw(bourse_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(bourse, 1050, 20)
      love.graphics.draw(arrow, 20, 620)
      love.graphics.draw(woodsign, 350, 620)
      love.graphics.draw(woodsign, 700, 620)
      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.print("Cours de la bourse de l'armure", 350, 60)
      love.graphics.setFont(animeFont12)
      love.graphics.print("Taxe à la vente :", 550, 110)
      love.graphics.print(round(item3.taxe * 100, 2), 690, 110)
      love.graphics.print("%", 730, 110)
      buySellSigns(item3)
      axesGraph(item3)
      writeGraph(item3)
   end

   if (states[5] == true) then
      love.graphics.draw(bourse_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(bourse, 1050, 20)
      love.graphics.draw(arrow, 20, 620)
      love.graphics.draw(woodsign, 350, 620)
      love.graphics.draw(woodsign, 700, 620)
      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.print("Cours de la bourse de la fourrure", 320, 60)
      love.graphics.setFont(animeFont12)
      love.graphics.print("Taxe à la vente :", 550, 110)
      love.graphics.print(round(item4.taxe * 100, 2), 690, 110)
      love.graphics.print("%", 730, 110)
      buySellSigns(item4)
      axesGraph(item4)
      writeGraph(item4)
   end

   if (states[6] == true) then
      love.graphics.draw(bourse_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(bourse, 1050, 20)
      love.graphics.draw(arrow, 20, 620)
      love.graphics.draw(woodsign, 350, 620)
      love.graphics.draw(woodsign, 700, 620)
      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.print("Cours de la bourse de la pyrite", 350, 60)
      love.graphics.setFont(animeFont12)
      love.graphics.print("Taxe à la vente :", 550, 110)
      love.graphics.print(round(item5.taxe * 100, 2), 690, 110)
      love.graphics.print("%", 730, 110)
      buySellSigns(item5)
      axesGraph(item5)
      writeGraph(item5)
   end

   if (states[7] == true) then
      love.graphics.draw(inventory_background, 0, 0)
      love.graphics.draw(lima, 20, 20)
      love.graphics.draw(arrow, 20, 620)
      love.graphics.draw(woodsign, 180, 200)
      love.graphics.draw(woodsign, 510, 200)
      love.graphics.draw(woodsign, 840, 200)
      love.graphics.draw(woodsign, 340, 400)
      love.graphics.draw(woodsign, 690, 400)

      love.graphics.setFont(animeFont30)
      love.graphics.print(round(argent, 2), 160, 60)
      love.graphics.print("Inventaire", 550, 60)
      
      love.graphics.setFont(animeFont20)
      love.graphics.print("Clou", 280, 170)
      love.graphics.print("Poivre", 610, 170)
      love.graphics.print("Armure", 940, 170)
      love.graphics.print("Fourrure", 420, 370)
      love.graphics.print("Pyrite", 790, 370)
      
      -- Clou --

      love.graphics.setFont(animeFont12)
      love.graphics.print("Dans l'inventaire :", 200, 220)
      love.graphics.print(item1.inventory, 350, 220)
      love.graphics.print("Prix à la revente :", 200, 260)
      love.graphics.print(round(item1[lastItem()] * item1.inventory - (item1[lastItem()] * item1.inventory * item1.taxe), 2) , 350, 260)
      love.graphics.print("Prix de tous les achats :", 200, 300)
      love.graphics.print(round(item1.total, 2), 410, 300)
      
      -- Poivre --

      love.graphics.setFont(animeFont12)
      love.graphics.print("Dans l'inventaire :", 530, 220)
      love.graphics.print(item2.inventory, 680, 220)
      love.graphics.print("Prix à la revente :", 530, 260)
      love.graphics.print(round(item2[lastItem()] * item2.inventory - (item2[lastItem()] * item2.inventory * item2.taxe), 2), 680, 260)
      love.graphics.print("Prix de tous les achats :", 530, 300)
      love.graphics.print(round(item2.total, 2), 740, 300)
      
      -- Armure --
      
      love.graphics.setFont(animeFont12)
      love.graphics.print("Dans l'inventaire :", 860, 220)
      love.graphics.print(item3.inventory, 1010, 220)
      love.graphics.print("Prix à la revente :", 860, 260)
      love.graphics.print(round(item3[lastItem()] * item3.inventory - (item3[lastItem()] * item3.inventory * item3.taxe), 2), 1010, 260)
      love.graphics.print("Prix de tous les achats :", 860, 300)
      love.graphics.print(round(item3.total, 2), 1070, 300)
      
      -- Fourrure --

      love.graphics.setFont(animeFont12)
      love.graphics.print("Dans l'inventaire :", 360, 420)
      love.graphics.print(item4.inventory, 510, 420)
      love.graphics.print("Prix à la revente :", 360, 460)
      love.graphics.print(round(item4[lastItem()] * item4.inventory - (item4[lastItem()] * item4.inventory * item4.taxe), 2), 510, 460)
      love.graphics.print("Prix de tous les achats :", 360, 500)
      love.graphics.print(round(item4.total, 2), 570, 500)
      
      -- Pyrite --

      love.graphics.setFont(animeFont12)
      love.graphics.print("Dans l'inventaire :", 710, 420)
      love.graphics.print(item5.inventory, 860, 420)
      love.graphics.print("Prix à la revente :", 710, 460)
      love.graphics.print(round(item5[lastItem()] * item5.inventory - (item5[lastItem()] * item5.inventory * item5.taxe), 2), 860, 460)
      love.graphics.print("Prix de tous les achats :", 710, 500)
      love.graphics.print(round(item5.total, 2), 920, 500)

      if not is_paused then
	 love.graphics.setColor(255, 255, 255)
      end
   end

   if (states[8] == true) then
      love.audio.stop(foule)
      love.graphics.draw(lose_background, 0, 0)
      love.graphics.setFont(animeFont50)
      love.graphics.print("Oh, non !", 500, 200)
      love.graphics.setFont(animeFont30)
      love.graphics.print("Vous avez fait faillite !", 420, 280)
      love.graphics.setFont(animeFont12)
      love.graphics.print("Vous aviez peu d'argent et plus de marchandise", 455, 330)

      love.graphics.setFont(animeFont30)
      setColorOrNot(500, 400, 775, 430)
      love.graphics.print("Recommencer", 500, 400)

      setColorOrNot(570, 460, 715, 490)
      love.graphics.print("Quitter", 570, 460)
      love.graphics.setColor(255, 255, 255)
   end
   
   if (states[9] == true) then
      love.audio.stop(foule)
      love.graphics.draw(win_background, 0, 0)
      love.graphics.setFont(animeFont50)
      love.graphics.print("Bien joué !", 460, 130)
      love.graphics.setFont(animeFont30)
      love.graphics.print("Vous avez gagné assez d'argent", 350, 230)
      love.graphics.print("pour acheter votre propre magasin !", 300, 280)
      love.graphics.setFont(animeFont12)
      love.graphics.print("\"Le temps, c'est de l'argent\" - Craft Lawrence", 470, 330)

      love.graphics.setFont(animeFont30)
      setColorOrNot(500, 400, 775, 430)
      love.graphics.print("Recommencer", 500, 400)

      setColorOrNot(570, 460, 715, 490)
      love.graphics.print("Quitter", 570, 460)
      love.graphics.setColor(255, 255, 255)
   end
   
   if (states[10] == true) then
      local j = 200
      
      love.audio.play(opening)
      love.graphics.draw(start_background, 0, 0)
      anim_glow:draw(700, 100)
      love.graphics.setFont(animeFont30)
      setColorOrNot(400, 350, 840, 380)
      love.graphics.print("Commencer une partie", 400, 350)
      setColorOrNot(390, 450, 855, 480)
      love.graphics.print("Changer vers l'anglais", 390, 450)
      setColorOrNot(550, 550, 695, 580)
      love.graphics.print("Quitter", 550, 550)
      love.graphics.setColor(255, 255, 255)
   end

   if is_paused then
      love.graphics.draw(pause_menu, 350, 50)
      love.graphics.setFont(animeFont50)
      love.graphics.setColor(255, 255, 255)
      love.graphics.print("Pause", 540, 120)
      love.graphics.line(425, 210, 850, 210)
      
      love.graphics.setFont(animeFont30)
      setColorOrNotPaused(530, 300, 740, 330)
      love.graphics.print("Reprendre", 530, 300)

      setColorOrNotPaused(500, 400, 775, 430)
      love.graphics.print("Recommencer", 500, 400)

      setColorOrNotPaused(560, 500, 705, 530)
      love.graphics.print("Quitter", 560, 500)
      
      love.graphics.setColor(150, 150, 150)
   end
end

function round(num, dec)
   local mult = 10^(dec or 0)
   return math.floor(num * mult + 0.5) / mult
end

function setColorOrNot(x1, y1, x2, y2)
   local x_mouse, y_mouse = love.mouse.getPosition()

   if is_paused then love.graphics.setColor(150, 150, 150)
   elseif ((x_mouse >= x1 and y_mouse >= y1) and (x_mouse <= x2 and y_mouse <= y2)) then
      love.graphics.setColor(60, 209, 230)
   else love.graphics.setColor(255, 255, 255)
   end
end

function setColorOrNotPaused(x1, y1, x2, y2)
   local x_mouse, y_mouse = love.mouse.getPosition()

   if ((x_mouse >= x1 and y_mouse >= y1) and (x_mouse <= x2 and y_mouse <= y2)) then
      love.graphics.setColor(60, 209, 230)
   else love.graphics.setColor(255, 255, 255) end
end

function setStatesFalse(nbr)
   local j = 1

   while (j <= 11) do
      if (states[j] == true) then last_state = j end
      states[j] = false
      j = j + 1
   end
   states[nbr] = true
end

function axesGraph(nb_item)
   local a = 0
   local b = 0
   local x = 150
   local y = 600

   love.graphics.setFont(animeFont12)
   while (a <= 24) do
      love.graphics.print(a, x, y)
      a = a + 1
      x = x + ((bourse_background:getWidth() - 250) / 24)
      if (a <= 24) then
	 love.graphics.line(x, y, x, y - 10)
      end
   end

   love.graphics.line(150, 595, 1200 , 595)
   x = 100
   y = 600
   while (b <= nb_item.b_max) do
      love.graphics.print(b, x, y)
      b = b + nb_item.b_add
      y = y - ((bourse_background:getHeight() - 300) / (nb_item.b_max / nb_item.b_add))
      if (b <= nb_item.b_max) then
	 love.graphics.line((x + 55), y, (x + 55) - 10, y)
      end
   end
   
   love.graphics.line(150, 180, 150, 600)
   love.graphics.print("Thorenis/Kg (argent)", 80, 155)
   love.graphics.print("Heures", 1150, 620)
end

function writeGraph(nb_item)
   local j = 2
   -- Pire code, vraiment très très sale. A changer absolument. --

   item1.y[i - 1] = 600 - ((400 / item1.b_max) * item1[i - 1])
   item1.y[i] =     600 - ((400 / item1.b_max) * item1[i])
   item2.y[i - 1] = 600 - ((400 / item2.b_max) * item2[i - 1])
   item2.y[i] =     600 - ((400 / item2.b_max) * item2[i])
   item3.y[i - 1] = 600 - ((400 / item3.b_max) * item3[i - 1])
   item3.y[i] =     600 - ((400 / item3.b_max) * item3[i])
   item4.y[i - 1] = 600 - ((400 / item4.b_max) * item4[i - 1])
   item4.y[i] =     600 - ((400 / item4.b_max) * item4[i])
   item5.y[i - 1] = 600 - ((400 / item5.b_max) * item5[i - 1])
   item5.y[i] =     600 - ((400 / item5.b_max) * item5[i])

   if (nb_item == 0) then
   else
      while (nb_item[j]) do
	 love.graphics.line(nb_item.x[j - 1], nb_item.y[j - 1], nb_item.x[j], nb_item.y[j])
	 j = j + 1
      end
   end
   
   item1.x[i - 1] = item1.x[i]
   item1[i - 1] = item1[i]
   item2.x[i - 1] = item2.x[i]
   item2[i - 1] = item2[i]
   item3.x[i - 1] = item3.x[i]
   item3[i - 1] = item3[i]
   item4.x[i - 1] = item4.x[i]
   item4[i - 1] = item4[i]
   item5.x[i - 1] = item5.x[i]
   item5[i - 1] = item5[i]
end

function buySellSigns(nb_item)
   
   love.graphics.setFont(animeFont12)

   if is_paused then love.graphics.setColor(75, 75, 75)
   elseif (argent - nb_item[lastItem()] >= 0) then setColorOrNot(360, 630, 450, 645)
   else love.graphics.setColor(150, 150, 150) end
   love.graphics.print("Achat x1", 360, 630)

   if is_paused then love.graphics.setColor(75, 75, 75)
   elseif (argent - (nb_item[lastItem()] * 5) >= 0) then setColorOrNot(360, 660, 450, 675)
   else love.graphics.setColor(150, 150, 150) end
   love.graphics.print("Achat x5", 360, 660)

   if is_paused then love.graphics.setColor(75, 75, 75)
   elseif (argent - (nb_item[lastItem()] * 10) >= 0) then setColorOrNot(360, 690, 450, 705)
   else love.graphics.setColor(150, 150, 150) end
   love.graphics.print("Achat x10", 360, 690)

   if is_paused then love.graphics.setColor(75, 75, 75)
   elseif (nb_item.inventory > 0) then setColorOrNot(880, 630, 970, 645)
   else love.graphics.setColor(150, 150, 150) end
   love.graphics.print("Vente x1", 880, 630)

   if is_paused then love.graphics.setColor(75, 75, 75)
   elseif (nb_item.inventory > 4) then setColorOrNot(880, 660, 970, 675)
   else love.graphics.setColor(150, 150, 150) end
   love.graphics.print("Vente x5", 880, 660)

   if is_paused then love.graphics.setColor(75, 75, 75)
   elseif (nb_item.inventory > 9) then setColorOrNot(880, 690, 970, 705)
   else love.graphics.setColor(150, 150, 150) end
   love.graphics.print("Vente x10", 880, 690)

   if not is_paused then love.graphics.setColor(255, 255, 255)
   else love.graphics.setColor(150, 150, 150) end
end

function lastItem()
   local j = 1

   while (item1[j]) do
      j = j + 1
   end

   j = j - 1
   return j
end

function checkState()
   local j = 1

   while (states[j] == false) do
      j = j + 1
   end

   return j
end

function checkItem()
   local j = checkState() - 1
   
   if (j == 1) then return item1
   elseif (j == 2) then return item2
   elseif (j == 3) then return item3
   elseif (j == 4) then return item4
   elseif (j == 5) then return item5 end
end

function buyItem(nb_item, many)
   if (argent - (nb_item[lastItem()] * many) >= 0) then
      argent = argent - (nb_item[lastItem()] * many)
      nb_item.inventory = nb_item.inventory + many
      nb_item.total = nb_item.total + (nb_item[lastItem()] * many)
      item1.dt_nobuy = 1.5
      item2.dt_nobuy = 1.5
      item3.dt_nobuy = 1.5
      item4.dt_nobuy = 1.5
      item5.dt_nobuy = 1.5
      love.audio.play(money)
      love.audio.play(arigato[math.random(4)])
   end	    
end

function sellItem(nb_item, many)
   if (nb_item.inventory >= many) then
      argent = argent + (nb_item[lastItem()] * many) - (nb_item[lastItem()] * many * nb_item.taxe)
      nb_item.inventory = nb_item.inventory - many
      love.audio.play(money)
   end	    
end

function adjustPrice(item_price, nb_item)
   if (nb_item == item1) then
      if (item_price > item1.b_max) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1] - 1, nb_item[lastItem()])
      elseif (item_price < item1.b_min) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1], nb_item[lastItem()] + 1) end

   elseif (nb_item == item2) then
      if (item_price > item2.b_max) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1] - 2, nb_item[lastItem()])
      elseif (item_price < item2.b_min) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1], nb_item[lastItem()] + 2) end

   elseif (nb_item == item3) then
      if (item_price > item3.b_max) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1] - 3, nb_item[lastItem()])
      elseif (item_price < item3.b_min) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1], nb_item[lastItem()] + 3) end

   elseif (nb_item == item4) then
      if (item_price > item4.b_max) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1] - 4, nb_item[lastItem()])
      elseif (item_price < item4.b_min) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1], nb_item[lastItem()] + 4) end

   elseif (nb_item == item5) then
      if (item_price > item5.b_max) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1] - 5, nb_item[lastItem()])
      elseif (item_price < item5.b_min) then nb_item[lastItem()] = math.random(nb_item[lastItem() - 1], nb_item[lastItem()] + 5) end
   end
end

function checkLoseOrWin()
   if (argent < 50 and item1.inventory == 0 and item2.inventory == 0 and item3.inventory == 0 and item4.inventory == 0 and item5.inventory == 0) then
      love.audio.play(lose)
      setStatesFalse(8)

   elseif (argent >= 4000) then
      love.audio.play(win)
      setStatesFalse(9)
   end
end
