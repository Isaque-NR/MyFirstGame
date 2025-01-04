
// Project: CRASH 
// Created: 2024-09-06

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "CRASH" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 120, 0 ) 
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// VARIAVEIS DE CONTROLE DO JOGO
veloX as float = 200 // velocidade do crash 
veloY as float = -350 // força do pulo 
pulo = 1 // variavel de controle para saber se o crash esta no chao e pode saltar 
tema=LoadMusic("Tema Crash.wav") // musica tema
playmusic(tema,1) // tocando a musica durante o jogo
morreu=LoadSound("morreu.wav") // som de morte
comeu=LoadSound("comeu.wav") // som quando come maça 
ganhou =LoadSound("ganhou.wav") // musica que venceu
perdeu=Loadsound("perdeu.wav")  // musica quando perde o jogo
modo$="parado" // variavel em forma de texto definindo o modo em que o crash se encontra para usar as animações 
fase=0 // variavel para controlar qual fase esta para organizar as movimetações dos gambas

// BACKGROUND
cenario = CreateSprite(LoadImage("cenario.png"))
// sprites para nao deixarem as outras cairem e limitar a tela
 // chao 
chao=CreateSprite(0)
SetSpriteSize(chao,1024,20)
SetSpritePosition(chao,0,740)
SetSpritePhysicsOn(chao,1)
SetSpriteColorAlpha(chao,0)
//parede esquerda
paredee=CreateSprite(0)
SetSpriteSize(paredee,15,768)
SetSpritePhysicsOn(paredee,1)
SetSpriteColorAlpha(paredee,0)
SetSpritePhysicsFriction(paredee,0)
 // parede direita
pareded=CreateSprite(0)
SetSpriteSize(pareded,15,768)
SetSpritePosition(pareded,1009,0)
SetSpritePhysicsOn(pareded,1)
SetSpriteColorAlpha(pareded,0)
SetSpritePhysicsFriction(pareded,0)
//gravidade
SetPhysicsGravity (0,300)

// CARREGANDO AS SPRITE QUE SERAO UTILIZADOS AO LONGO DO JOGO

// SPRITES DA MOVIMENTAÇÃO DO CRASH
parado=CreateSprite(LoadImage("parado.png" ))  // sprite do crash parado
SetSpriteAnimation( parado,70,70,6 ) 
PlaySprite(parado)
SetSpriteSize(parado,120,120)
SetSpriteColorAlpha(parado,255) // visivel por ser a posicao inicical
SetSpriteDepth(parado,0)

correndo=CreateSprite(LoadImage("correndo.png"))
SetSpriteAnimation( correndo,71,83,15 ) 
PlaySprite(correndo)
SetSpriteSize(correndo,130,130)
SetSpriteColorAlpha(correndo,0)  // deixando invisivel na tela para depois chama-la e dar cor 
SetSpriteDepth(correndo,0)

pulando=CreateSprite(LoadImage("pulando.png"))
SetSpriteAnimation( pulando,74,71,8) 
PlaySprite(pulando)
SetSpriteSize(pulando,130,130)
SetSpriteColorAlpha(pulando,0)
SetSpriteDepth(pulando,0)

morto=CreateSprite(LoadImage("morto.png")) // sprite que aparece quando ele morre
SetSpriteAnimation(morto,76,73,4)
playsprite(morto)
SetSpriteSize(morto,130,130)
SetSpriteColorAlpha(morto,0)
SetSpriteDepth(morto,0) // define a profundidade que a sprite vai ficar na tela, parametro 0 para ele ficar na frente de todos

dancando=CreateSprite(LoadImage("dancando.png")) // sprite dele dancando que aparece quando o jogador termina o jogo 
SetSpriteAnimation(dancando,70,60,22)
setspritesize(dancando,110,110)
playsprite(dancando)
SetSpriteColorAlpha(dancando,0)
SetSpriteDepth(dancando,0) 

crash=CreateSprite(0) //sprite  da colisao do crash
SetSpriteColorAlpha(crash,0)
setspritesize(crash,50,85)
SetSpriteShape(crash,1) // definindo a forma da colisao, parametro 1 circulo, achei a melhor forma para se usar
SetSpritePhysicsOn (crash,2) // ligando a fisica na sprite para ter as colisoes e movimentações com a fisica 
SetSpritePhysicsCanRotate(crash,0) // funcao para nao deixar a sprite rodar 
SetSpritePhysicsFriction(crash,80) // funcao para ter friccao na sprite para ela nao sair deslizando quando o jogador para de se movimentar 
SetSpritePosition(crash,9999,9999) // colocando fora da tela para nao aparecer o crash no menu

 // SPRITES DOS OBJETOS E INIMGOS DAS FASES 
dim manga[5] // cinco mangas iguais mas diferentes pois cada manga leva a uma fase 
dim box[5] // definindo como vetores pois durante as fases sao utilizados caixas e inimigos iguais com as mesmas caracteristicas 
dim gamba[5]
dim direcaog[5] // variavel que define se o gamba vai andar pra esquerda ou pra direita 
for i=0 to 5
manga[i] = CreateSprite(LoadImage("manga.png"))
SetSpriteColorAlpha(manga[i],0)
SetSpritePhysicsOn(manga[i],2)
SetSpriteShape(manga[i],3)
SetSpritePhysicsCanRotate(manga[i],0)
box[i] = CreateSprite(LoadImage("box.png")) //  caixas para serem usadas durantes as fases 
SetSpritePhysicsOn(box[i],3)
SetSpritePhysicsFriction(box[i],0)
SetSpriteSize(box[i],100,100)
SetSpriteColorAlpha(box[i],0)
gamba[i]=CreateSprite(LoadImage("gamba.png"))
SetSpriteAnimation(gamba[i],215,186,4)
PlaySprite(gamba[i],4)
SetSpriteSize(gamba[i],150,150)
SetSpriteColorAlpha(gamba[i],0)
SetSpritephysicsOn(gamba[i],2)
SetSpriteShape(gamba[i],3) // parametro 3 poligono que se adapta melhor a forma que o gamba tem, logo a colisao é mais precisa
SetSpritePosition(gamba[i],1111,1111) // colocando fora da tela para eles nao aparecerem no menu, coloquei longe da sprite do crash para nao houver uma colisao fora da tela 
SetSpritePhysicsCanRotate(gamba[i],0)
SetSpritePhysicsFriction(gamba[i],0)
SetSpriteFlip(gamba[i],255,0)
direcaog[i]=1 // -1 para esquerda e 1 pra direita
next i

// SPRITES DOS TEXTOS QUE APARECEM NO JOGO 
titulo=CreateSprite(loadimage("titulo.png")) 
SetSpriteSize(titulo,700,300)
SetSpritePosition(titulo,140,10)
jogar=CreateSprite(LoadImage("play.png")) 
SetSpritePosition(jogar,350,370)
sair=CreateSprite(LoadImage("sair.png")) 
SetSpritePosition(sair,370,550)
gameover=CreateSprite(LoadImage("gameover.png"))
SetSpriteColorAlpha(gameover,0)
txt=CreateSprite(LoadImage("txt.png")) // texto tutorail
SetSpritePosition(txt,1600,1500)
txt2=CreateSprite(LoadImage("txt2.png")) // texto movimentaçã0 
SetSpriteColorAlpha(txt2,0)
txt3=CreateSprite(LoadImage("txt3.png")) // texto quando termina o jogo
SetSpriteColorAlpha(txt3,0)
nvl= CreateSprite(LoadImage("nivel.png"))
SetSpriteColorAlpha(nvl,0)
um= CreateSprite(LoadImage("1.png"))
SetSpriteColorAlpha(um,0)
dois= CreateSprite(LoadImage("2.png"))
SetSpriteColorAlpha(dois,0)
tres= CreateSprite(LoadImage("3.png"))
SetSpriteColorAlpha(tres,0)
quatro= CreateSprite(LoadImage("4.png"))
SetSpriteColorAlpha(quatro,0)
cinco= CreateSprite(LoadImage("5.png"))
SetSpriteColorAlpha(cinco,0)
//SetPhysicsDebugOn()
do
ClearScreen()

// MOVIMENTAÇAO  DO CRASH 
if GetRawKeyState(37)=1 // <--
	 SetSpriteFlip(parado,255,0) // invertendo as sprites para a esquerda
	 SetSpriteFlip(correndo,220,0)
	 SetSpriteFlip(pulando,255,0)
	 SetSpritePhysicsVelocity(crash,-veloX,GetSpritePhysicsVelocityY(crash)) // aplicando força para ele andar pra esquerda
		if  pulo=1 // ta no chao / definindo o modo que ele esta dependendo se ele ta no ar ou no chao 
	       modo$="correndo" 
		   elseif pulo=0 // ta no ar
		      modo$="pulando"
        endif
 elseif GetRawKeyState(39)=1 // --> 
	SetSpriteFlip(parado,0,0) // desinvertendo as sprites 
    SetSpriteFlip(correndo,0,0)
    SetSpriteFlip(pulando,0,0)
    SetSpritePhysicsVelocity(crash,veloX,GetSpritePhysicsVelocityY(crash)) // aplicando força para direita 
       if  pulo=1
	      modo$="correndo"
		     elseif  pulo=0 
			    modo$="pulando"
	   endif
else 
   if  pulo=1
      modo$="parado"
   endif 
   SetSpritePhysicsVelocity(crash,0,GetSpritePhysicsVelocityY(crash)) // para o movimento horizontal se nada for apertado
endif	  

if GetRawKeyState(32) =1 and pulo = 1 // realizando o pulo do crash
	modo$="pulando"
    SetSpritePhysicsVelocity(crash,GetSpritePhysicsVelocityX(crash),veloY) // aplicando força no eixo Y 
    pulo = 0 		  	  
endif
// verificando se pode pular ou nao
if GetSpritePhysicsVelocityY(crash) = 0 //  verificando se o crash esta no chao
   pulo =1 //  pode pular ta chao 
      else 
         pulo = 0 // ta no ar nao pode pular
endif		

// COLOCANDO ANIMAOCAO DE ACORDO COM A MOVIMENTAÇAO
if modo$ = "parado"
   SetSpriteColorAlpha(parado,255) 
   SetSpriteColorAlpha(correndo,0)
   SetSpriteColorAlpha(pulando,0)
      elseif modo$="correndo"
	     SetSpriteColorAlpha(parado,0) // OBS: nao sei pq mas as vezes tem pequenos bugs visuais quando ele esta correndo e aparece a sprite dele pulando piscando
	     SetSpriteColorAlpha(correndo,255)
	     SetSpriteColorAlpha(pulando,0)
	        elseif modo$="pulando" 
		       SetSpriteColorAlpha(parado,0)
	           SetSpriteColorAlpha(correndo,0)
	           SetSpriteColorAlpha(pulando,255)
endif
 // COLOCANDO AS SPRITES DE ANIMAÇÃO SEMPRE NA DE COLISAO
SetSpritePosition(parado,GetSpriteX(crash)-40,GetSpriteY(crash)-28) // parametros variaveis pois cada sprite de animação tem uma posição que fica melhor(maiscentrada) no circulo da colisao
SetSpritePosition(correndo,GetSpriteX(crash)-40,GetSpriteY(crash)-25)
SetSpritePosition(pulando,GetSpriteX(crash)-45,GetSpriteY(crash)-30)
				  
// MENU
if GetRawMouseLeftPressed ( )=1 
    if GetSpriteHitTest(sair,GetPointerX( ),GetPointerY( )) // verificando na hora do clique esta na sprite SAIR 
		   end //fecha o jogo
	endif
endif
if GetRawMouseLeftPressed( )=1// pegar o clique do mouse 
    if GetSpriteHitTest(jogar,GetPointerX( ),GetPointerY( ))  // verificando se  na hora do clique esta na sprite JOGAR
			// inicializa o jogo na fase 0 (tutorial)
			SetSpriteColorAlpha(parado,255)
			SetSpriteColorAlpha(titulo,0)
			SetSpritePosition(jogar,9999,9999) // mandando para fora do jogo para nao ter a posibilidade de reiniciar a posicao do crash com um miss click
			SetSpriteScale(sair,0.5,0.5)
			SetSpritePosition(sair,850,40)
			SetSpritePosition(manga[0],880,680) 
			SetSpriteColorAlpha(manga[0],255)
			SetSpritePosition(crash,0,660)
			SetSpritePosition(txt,200,10)
			SetSpriteColorAlpha(txt2,255)
			SetSpritePosition(txt2,150,200)
	endif
endif
if GetSpriteCollision(crash,manga[0]) // muda pra FASE 1 
	fase=1
	playsound(comeu)
   	SetSpriteColorAlpha(txt,0)
    SetSpriteColorAlpha(txt2,0)
    SetSpriteColorAlpha(nvl,255)
    SetSpritePosition(nvl,10,25)
    SetSpriteColorAlpha(um,255)
	SetSpritePosition(um,180,25)
    SetSpritePosition(crash,0,660)
    SetSpritePosition(gamba[0],400,590)
    SetSpriteColorAlpha(gamba[0],255)
	   for i=0 to 3
	     SetSpriteColorAlpha(box[i],255) // tirando a invisibilidade das caixas
	  next i 
    SetSpritePosition(box[0],250,640)
	SetSpritePosition(box[1],600,640)
	SetSpritePosition(box[2],600,540)
    SetSpritePosition(box[3],600,440)
    SetSpritePosition(manga[0],9999,9999) // mandando para fora da tela para nao ter chances de alguma forma ecostar nela de novo
    SetSpriteColorAlpha(manga[1],255)
	SetSpritePosition(manga[1],870,690) // manga do nivel um 

endif
// MOVENTAÇÃO DOS GAMBAS DE ACORDO COM A FASE 
if fase = 1 
   if  GetSpriteX(gamba[0]) >= 463 // estabelcendo limite da direita
	    direcaog[0]=-1 // andando para direita
	    SetSpriteFlip(gamba[0],0,0)
	       elseif GetSpriteX(gamba[0]) <= 340 // estabelcendo limite da esquerda
		      SetSpriteFlip(gamba[0],255,0)
			  direcaog[0]=1 // andando para esquerda
   endif
   SetSpritePhysicsVelocity(gamba[0],150 * direcaog[0], GetSpriteY(gamba[0])) // clolocando velocidade de acordo com a direcao no gamba 
endif
if GetSpriteCollision(crash,manga[1])  // FASE 2
	  fase=2
	  playsound(comeu)
	  SetSpritePosition(manga[1],9999,9999)
	  SetSpritePosition(manga[2],940,620)
	  SetSpriteColorAlpha(manga[2],255)
      SetSpritePosition(crash,0,660)
	  SetSpriteColorAlpha(um,0)
	  SetSpriteColorAlpha(dois,255)
	  SetSpritePosition(dois,190,27) 
 	  SetSpritePosition(box[0],130,640)  // setando as posições das caixas 
	  SetSpritePosition(box[1],480,640)
	  SetSpritePosition(box[2],920,640)
	  SetSpritePosition(box[3],9999,9999)
	  SetSpritePosition(gamba[0],320,590)
	  SetSpritePosition(gamba[1],720,590)
      SetSpriteColorAlpha(gamba[1],255)
endif
if fase = 2
    if  GetSpriteX(gamba[0]) >= 340 
	     direcaog[0]=-1 
	     SetSpriteFlip(gamba[0],0,0)
	         elseif GetSpriteX(gamba[0]) <= 221
		          SetSpriteFlip(gamba[0],255,0)
			      direcaog[0]=1 
	endif
   if  GetSpriteX(gamba[1]) >= 780
        direcaog[1]=-1 
	    SetSpriteFlip(gamba[1],0,0)
	       elseif GetSpriteX(gamba[1]) <= 570
			    SetSpriteFlip(gamba[1],255,0)
				direcaog[1]=1
   endif
   SetSpritePhysicsVelocity(gamba[0],150 * direcaog[0], GetSpriteY(gamba[0]))
   SetSpritePhysicsVelocity(gamba[1],200 * direcaog[1], GetSpriteY(gamba[1]))
endif
if GetSpriteCollision(crash,manga[2])  // FASE 3
	  fase=3
	  playsound(comeu)
	  SetSpritePosition(crash,0,660)
	  SetSpriteColorAlpha(dois,0)
	  SetSpriteColorAlpha(tres,255)
	  SetSpritePosition(tres,180,25)
      SetSpritePosition(manga[2],9999,9999)
      SetSpritePosition(manga[3],20,150)
      SetSpritePosition(box[0],10,200)
      SetSpritePosition(box[1],330,370)
      SetSpritePosition(box[2],430,370)
      SetSpritePosition(box[3],530,370)
      SetSpritePosition(box[4],900,540)
	  SetSpriteColorAlpha(box[4],255)
	  SetSpritePosition(box[5],900,640)
      SetSpriteColorAlpha(box[5],255)
      SetSpritePosition(gamba[0],200,590)
      SetSpritePosition(gamba[1],520,590)
      SetSpritePosition(gamba[2],320,220)
      SetSpriteColorAlpha(gamba[2],255)
	  SetSpriteColorAlpha(manga[3],255)
endif
if fase=3
	 if  GetSpriteX(gamba[0]) >= 420
	    direcaog[0]=-1 // andando para direita
	    SetSpriteFlip(gamba[0],0,0)
	       elseif GetSpriteX(gamba[0]) <= 180
		       SetSpriteFlip(gamba[0],255,0)
			   direcaog[0]=1 // andando para esquerda
	 endif
	 if  GetSpriteX(gamba[1]) >= 760
	     direcaog[1]=-1 // andando para direita
	     SetSpriteFlip(gamba[1],0,0)
		    elseif GetSpriteX(gamba[1]) <= 580
			   SetSpriteFlip(gamba[1],255,0)
			   direcaog[1]=1 // andando para esquerda
	 endif
	 if  GetSpriteX(gamba[2]) >= 500
	    direcaog[2]=-1 // andando para direita
	    SetSpriteFlip(gamba[2],0,0)
	       elseif GetSpriteX(gamba[2]) <= 300
		       SetSpriteFlip(gamba[2],255,0)
			   direcaog[2]=1 // andando para esquerda
	 endif
	 SetSpritePhysicsVelocity(gamba[0],150 * direcaog[0], GetSpriteY(gamba[0]))
	 SetSpritePhysicsVelocity(gamba[1],150 * direcaog[1], GetSpriteY(gamba[1]))
	 SetSpritePhysicsVelocity(gamba[2],95* direcaog[2], GetSpriteY(gamba[2]))
endif
if GetSpriteCollision(crash,manga[3])  // FASE 4
	  fase=4
	  SetSpritePosition(crash,0,660)
	  playsound(comeu)
	  SetSpritePosition(manga[3],9999,9999)
	  SetSpriteColorAlpha(manga[4],255)
	  SetSpritePosition(manga[4],920,680)
	  SetSpriteColorAlpha(tres,0)
	  SetSpriteColorAlpha(quatro,255)
      SetSpritePosition(quatro,185,25)
	  SetSpritePosition(gamba[0],180,590)
	  SetSpriteFlip(gamba[0],0,0)
	  SetSpritePosition(gamba[1],500,590)
	  SetSpritePosition(gamba[2],720,170)
	  SetSpritePosition(box[0],335,640)  
	  SetSpritePosition(box[1],410,380)
	  SetSpritePosition(box[2],610,320)
	  SetSpritePosition(box[3],710,320)
	  SetSpriteColorAlpha(box[4],255)
      SetSpritePosition(box[4],810,320)
      SetSpriteColorAlpha(box[5],255)
      SetSpritePosition(box[5],10,460)
endif
if fase=4 
	   if  GetSpriteX(gamba[1]) >= 780
	      direcaog[1]=-1 // andando para direita
	      SetSpriteFlip(gamba[1],0,0)
		     elseif GetSpriteX(gamba[1]) <= 425
 			      SetSpriteFlip(gamba[1],255,0)
				  direcaog[1]=1 // andando para esquerda
	   endif
	   if  GetSpriteX(gamba[2]) >= 790
	       direcaog[2]=-1 // andando para direita
	       SetSpriteFlip(gamba[2],0,0)
		       elseif GetSpriteX(gamba[2]) <= 580
			       SetSpriteFlip(gamba[2],255,0)
				   direcaog[2]=1 // andando para esquerda
	  endif
	  SetSpritePhysicsVelocity(gamba[1],150 * direcaog[1], GetSpriteY(gamba[1]))
	  SetSpritePhysicsVelocity(gamba[2],100 * direcaog[2], GetSpriteY(gamba[2]))
endif
if GetSpriteCollision(crash,manga[4])  // FASE 5
	fase=5
	playsound(comeu)
    SetSpriteColorAlpha(quatro,0)
	SetSpriteColorAlpha(cinco,255)
    SetSpritePosition(cinco,185,25)
	SetSpritePosition(crash,920,100)
	SetSpritePosition(box[0],100,490)
	SetSpritePosition(box[1],900,210)
	SetSpritePosition(box[2],440,370)
	SetSpritePosition(box[3],540,370)
	SetSpritePosition(box[4],640,370)
	SetSpritePosition(box[5],0,490)
	SetSpriteColorAlpha(manga[5],255)
	SetSpritePosition(manga[5],0,680)
	SetSpritePosition(manga[4],9999,9999)
	SetSpritePosition(gamba[0],200,590)
    SetSpritePosition(gamba[1],480,590)
    SetSpritePosition(gamba[2],800,590)
    SetSpriteColorAlpha(gamba[3],255)
	SetSpritePosition(gamba[3],540,250)
endif
if fase=5
	    if  GetSpriteX(gamba[0]) >= 290
	       direcaog[0]=-1 // andando para direita
	       SetSpriteFlip(gamba[0],0,0)
		      elseif GetSpriteX(gamba[0]) <= 60
 			     SetSpriteFlip(gamba[0],255,0)
				 direcaog[0]=1 // andando para esquerda
	    endif
		if  GetSpriteX(gamba[1]) >= 590
	        direcaog[1]=-1 // andando para direita
	        SetSpriteFlip(gamba[1],0,0)
			   elseif GetSpriteX(gamba[1]) <= 420
 			      SetSpriteFlip(gamba[1],255,0)
				  direcaog[1]=1 // andando para esquerda
		endif
		if  GetSpriteX(gamba[2]) >= 870
	        direcaog[2]=-1 // andando para direita
	        SetSpriteFlip(gamba[2],0,0)
		    elseif GetSpriteX(gamba[2]) <= 720
		       SetSpriteFlip(gamba[2],255,0)
			   direcaog[2]=1 // andando para esquerda
		endif
		if  GetSpriteX(gamba[3]) >= 630
	       direcaog[3]=-1 // andando para direita
	       SetSpriteFlip(gamba[3],0,0)
		      elseif GetSpriteX(gamba[3]) <= 400
			     SetSpriteFlip(gamba[3],255,0)
				 direcaog[3]=1 // andando para esquerda
	    endif
		SetSpritePhysicsVelocity(gamba[0],100 * direcaog[0], GetSpriteY(gamba[0]))
		SetSpritePhysicsVelocity(gamba[1],100 * direcaog[1], GetSpriteY(gamba[1]))
	    SetSpritePhysicsVelocity(gamba[2],100 * direcaog[2], GetSpriteY(gamba[2]))
		SetSpritePhysicsVelocity(gamba[3],100 * direcaog[3], GetSpriteY(gamba[3]))
endif
// PASSOU DA ULTIMA FASE TELA DE FIM
if GetSpriteCollision(crash,manga[5]) 
	playsound(comeu)
	playsound(ganhou,60,0)
	SetSpriteColorAlpha(dancando,255)
	SetSpritePosition(dancando,335,620)
	SetSpritePosition(crash,9999,9999)
	SetSpriteColorAlpha(txt3,255)
	SetSpritePosition(txt3,50,5)
	SetSpriteScale(sair,0.75,0.75)
	SetSpritePosition(sair,440,640)
	SetSpriteColorAlpha(nvl,0)
	SetSpriteColorAlpha(cinco,0)
       for i=0 to 5 
	      SetSpriteColorAlpha(gamba[i],0)
		  SetSpriteColorAlpha(box[i],0)
		  SetSpriteColorAlpha(manga[i],0)
	   next i 
endif	
// COLISAO DO CRASH COM OS GAMBAS DA GAME OVER
for i=0 to 4
		 if GetSpriteCollision(crash,gamba[i]) = 1 
		  playsound(morreu,60,0) 
		  playsound(perdeu,70,0)
		  StopMusic()
		  SetSpritePosition(morto,435,365)
		  SetSpriteColorAlpha(morto,255)  // sprite crash morrendo   
	      SetSpritePosition(crash,9999,9999) // tirando da tela para nao ter mais de uma colisao contada e o audio da morte bugar 
	      SetSpriteColorAlpha(gameover,255)
	      SetSpritePosition(gameover,280,30)
	      SetSpriteScale(sair,0.75,0.75)
	      SetSpritePosition(sair,400,500)
	      SetSpriteColorAlpha(nvl,0)
	      SetSpriteColorAlpha(cinco,0)
	         for i=0 to 5 
		        SetSpriteColorAlpha(gamba[i],0)
		        SetSpriteColorAlpha(box[i],0)
		        SetSpriteColorAlpha(manga[i],0)
		     next i 
	    endif
next i
Sync()
loop
