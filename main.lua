function love.load()
    --love.window.setTitle("Revenge of The Moth") precisa do love 0.90

	powerboat = love.graphics.newImage("images/missileboat/MissileBoat.png")
	carminemine = love.graphics.newImage("images/carminemine/CarmineMine.png")
	fatmissile = love.graphics.newImage("images/tiros/FatMissile.png")
	mediummissile = love.graphics.newImage("images/tiros/MediumMissile.png")
	slimmissile = love.graphics.newImage("images/tiros/SlimMissile.png")
	bigblueplasma = love.graphics.newImage("images/tiros/BigBluePlasma.png")
    bigredplasma = love.graphics.newImage("images/tiros/BigRedPlasma.png")
    mediumgreenplasma = love.graphics.newImage("images/tiros/MediumGreenPlasma.png")
    mediumorangeplasma = love.graphics.newImage("images/tiros/MediumOrangePlasma.png")

    cooldown = 0
	jogador={}
	jogador.X=0
	jogador.Y=0
	jogador.imagem=powerboat
	jogador.veloX=0
	jogador.veloY=0
    jogador.canhaolisth={0,80,30,50}
    jogador.canhaolistv={5,5,35,35}
    jogador.canhao=1
    jogador.hp=100
    jogador.HX=0
    jogador.HY=0
    jogador.altura=59
    jogador.largura=92
    alvo={}
    alvo.X= 400
    alvo.Y=400
    alvo.imagem=carminemine
    alvo.veloX=0
    alvo.veloY=0
    alvo.hp=20
    alvo.HX=0
    alvo.HY=0
    alvo.largura=31
    alvo.altura=31
	shot1={} --propriedades do tiro incluindo posição com o centro da nave
	shot1.imagem=bigredplasma
	shot1.veloX=0
	shot1.veloY=30
    shot1.pow=1
    shot1.HX=0
    shot1.HY=0
    shot1.largura=13 --os outros ainda precisam ter
    shot1.altura=18
    shot2={}
    shot2.imagem=mediumorangeplasma
    shot2.veloX=0
    shot2.veloY=10
    shot2.pow=3
    shot3={}
	shot3.imagem=bigblueplasma
	shot3.veloX=-10
	shot3.veloY=17
    shot3.pow = 2
    shot4={}
	shot4.imagem=mediumgreenplasma
	shot4.veloX=2
	shot4.veloY=15
    shot4.pow = 1
	Pativos={jogador}
    ASativos={}
	ESativos={}
	Eativos={alvo}
	Aativos={}
	ativos={Aativos,Eativos,ESativos,ASativos,Pativos}
    --MPativos={}
    --MASativos={}
    --MESativos={}
    --MEativos={}
    --MAativos={}
    --Mativos={MAativos,MEativos,MESativos,MASativos,MPativos}
    print("teste1")
    --for h,treco in ipairs(Mativos) do --Corrigir processo de criação antes
    --    treco=space_factory(600,800)
    --end
    print("teste2")
end

function love.update(dt)
	if love.keyboard.isDown('right') then jogador.X=jogador.X+5 end -- gerar movimentação de hitbox
	if love.keyboard.isDown('left') then jogador.X=jogador.X-5 end
	if love.keyboard.isDown('down') then jogador.Y=jogador.Y+5 end
	if love.keyboard.isDown('up') then jogador.Y=jogador.Y-5 end
    if love.keyboard.isDown('z') and cooldown == 0 then
        table.insert(ASativos,1,factory(shot1,jogador))
		if jogador.canhao>3 then --alterna os canhões da nave
			jogador.canhao=1
		else
			jogador.canhao=jogador.canhao+1
		end
        cooldown = 1
    end
    if cooldown >= 1 then cooldown = cooldown -1 end
	for h,treco in ipairs(ativos) do --check de escapadas
		for i,coisa in ipairs(treco) do --criar especificidades para as outras listas
			coisa.X=coisa.X+coisa.veloX
			coisa.Y=coisa.Y+coisa.veloY
			if coisa.X>=500 or coisa.Y>=600 or coisa.X<-100 or coisa.Y<=-100 then --adicionar hp depois--
				table.remove(treco,i)  --ainda tá rígido, não vai dar pra aplicar para inimigos sendo destruídos fora de ordem -- tem que coletar lixo, eu só estou tirando de circulação
                coisa = nil
				i= i -1
			end
		end
    end
    for h,treco in ipairs(ASativos) do -- check de impactos de tiros aliados
        for i,coisa in ipairs(Eativos) do
            if colider(treco,coisa) then
                coisa.hp=coisa.hp-treco.pow
                if coisa.hp <= 0 then
                    table.remove(Eativos,i)
                    coisa=nil
                    h=h-1
                end
                table.remove(ASativos,h)
                treco=nil
            end
        end
    end
    for h,treco in ipairs(ESativos) do -- check de impactos de tiros inimigos
        for i,coisa in ipairs(Aativos) do
            if colider(treco,coisa) then
                coisa.hp=coisa.hp-treco.pow
                if coisa.hp <= 0 then
                    table.remove(Aativos,i)
                    coisa=nil
                    h=h-1
                end
                table.remove(ESativos,h)
                treco=nil
            end
        end
	end
end

function love.draw() --desenho dos objetos - ordem shots,naves,jogador (Aliados, depois inimigos)
	for i,coisa in ipairs(ESativos) do
		love.graphics.draw(coisa.imagem,coisa.X,coisa.Y)
    end
	for i,coisa in ipairs(ASativos) do
		love.graphics.draw(coisa.imagem,coisa.X,coisa.Y)
    end
	for i,coisa in ipairs(Eativos) do
		love.graphics.draw(coisa.imagem,coisa.X,coisa.Y)
    end
	for i,coisa in ipairs(Aativos) do
		love.graphics.draw(coisa.imagem,coisa.X,coisa.Y)
    end
	for i,coisa in ipairs(Pativos) do
		love.graphics.draw(coisa.imagem,coisa.X,coisa.Y)
    end
end

function love.keypressed(key,unicode)
    if key=="escape" then --Depois descobrir o código do esc
		print("I will be baaaaccccckkkkkk!!!! Craper!!!")
        love.event.quit()
    end
	if key=="x" then
		table.insert(ASativos,1,factory(shot3,jogador))
		if jogador.canhao>3 then --alterna os canhões da nave
			jogador.canhao=1
		else
			jogador.canhao=jogador.canhao+1
		end
	end
end


function factory(pedido,ref)
	entrega={}
	entrega.X=ref.X+ref.canhaolisth[ref.canhao]
	entrega.Y=ref.Y+ref.canhaolistv[ref.canhao]
	entrega.veloX=pedido.veloX + ref.veloX --A nave do jogador ainda não tem velocidade, ele teleporta
	entrega.veloY=pedido.veloY + ref.veloY
    if ref.canhaolisth[ref.canhao] > 40 then --Achar eixo central e dividir no meio
        entrega.veloX = -entrega.veloX
    end
    entrega.pow= pedido.pow
    entrega.HX=ref.HX+ref.canhaolisth[ref.canhao]
    entrega.HY=ref.HY+ref.canhaolistv[ref.canhao]
    entrega.largura=pedido.largura
    entrega.altura=pedido.altura
	entrega.imagem=pedido.imagem
	return(entrega)
end

-- Tentativa de space por check de quadrados

function colider (azarado,ferrado)
    if  azarado.HX > ferrado.HX+ferrado.largura or azarado.HX > ferrado.HX+ferrado.altura or ferrado.HX > azarado.HX+ azarado.largura or ferrado.HX > azarado.HX+ azarado.altura then --checar melhor a lógica disso
        return(false)
    elseif true then
        return(true)
    end
end



-- Tentativa de space por matriz de check

function space_factory(horizontal,vertical) --tá ENORME em termos de processo ele não processa
    linha={}
    pedido={}
    y=0
    z=0
    while z<horizontal do
        table.insert(linha,0)
    end
    while y<vertical do
        table.insert(pedido,copiadora_lista(linha))
    end
    return(pedido)
end



function space_mark(pedido,ref)
end

function space_check(space1,space2)
end

function space_cleaner(pedido) --check como fazer direito
    for h,treco in ipairs(pedido) do
		for i,coisa in ipairs(treco) do
            print("lixo")
        end
    end
end

function copiadora_lista (lista)
    return (lista)
end
