module Gobstones where
import Data.List

----------
--Punto 1-
----------

data Bolita = Rojo | Azul | Verde | Negro deriving(Show, Eq)
data Direccion = Norte | Sur | Este | Oeste deriving(Show)

type Sentencia = Tablero -> Tablero
type Posicion  = (Int, Int)
type Cabezal   = (Int, Int)
type Tamaño    = (Int, Int)
type Condicion = (Tablero -> Bool)

data Celda = Celda{
  posicion :: Posicion,
  bolitas  :: [Bolita]
} deriving(Show)

data Tablero = Tablero{
  celdas :: [Celda],
  tamaño  :: Tamaño,
  cabezal :: Cabezal
} deriving(Show)

mapCabezal :: (Cabezal -> Cabezal) -> Sentencia
mapCabezal f tablero = tablero{cabezal = f . cabezal $ tablero}

mapCeldas :: ([Celda] -> [Celda]) -> Sentencia
mapCeldas f tablero = tablero{celdas = f . celdas $ tablero}

mapBolitas :: ([Bolita] -> [Bolita]) -> Celda -> Celda
mapBolitas f celda = celda {bolitas = f . bolitas $ celda}

mapBolitasEnCelda :: (Bolita -> Cabezal -> Celda -> Celda) -> Bolita -> Tablero -> Tablero
mapBolitasEnCelda f bolita tablero = mapCeldas (map (f bolita . cabezal $ tablero)) tablero

operarSiEsLaCelda :: (Celda -> Celda) -> Bolita -> Cabezal -> Celda -> Celda
operarSiEsLaCelda f bolita cabezal celda
  | esEstaCelda cabezal celda = f celda
  | otherwise                 = celda

esEstaCelda :: Cabezal -> Celda -> Bool
esEstaCelda cabezal celda = posicion celda == cabezal
----------
--Punto 2-
----------

inicializarTablero :: Tamaño -> Tablero
inicializarTablero (filas, columnas) = Tablero [Celda (x, y) [] | x <-[1 .. filas], y <- [1 .. columnas]] (filas, columnas) (1, 1)


-------------
--Punto 3.a--
-------------

mover :: Direccion -> Sentencia
mover direccion tablero
  | puedeMoverse direccion tablero = moverCabezal direccion tablero
  | otherwise = error "Boom"

moverCabezal :: Direccion -> Sentencia
moverCabezal Norte = mapCabezal (sumaParOrdenado ( 0, 1))
moverCabezal Sur   = mapCabezal (sumaParOrdenado ( 0,-1))
moverCabezal Este  = mapCabezal (sumaParOrdenado ( 1, 0))
moverCabezal Oeste = mapCabezal (sumaParOrdenado (-1, 0))

betweenDupla :: Ord a => (a, a) -> (a, a) -> (a, a) -> Bool
betweenDupla (lix, liy) (lsx, lsy) (x, y) = between lix lsx x && between liy lsy y

between :: Ord a => a -> a -> a -> Bool
between li ls x = x >= li && x <= ls

sumaParOrdenado :: (Int, Int) -> (Int, Int) -> (Int, Int)
sumaParOrdenado (a, b) (c, d) = (a + c, b + d)

-------------
--Punto 3.b--
-------------

poner :: Bolita -> Sentencia
poner = mapBolitasEnCelda ponerBolitaEnCelda

ponerBolitaEnCelda :: Bolita -> Cabezal -> Celda -> Celda
ponerBolitaEnCelda bolita = operarSiEsLaCelda (mapBolitas (++ [bolita])) bolita


-------------
--Punto 3.c--
-------------

sacar :: Bolita -> Sentencia
sacar = mapBolitasEnCelda sacarBolitaEnCelda

sacarBolitaEnCelda :: Bolita -> Cabezal -> Celda -> Celda
sacarBolitaEnCelda bolita = operarSiEsLaCelda (mapBolitas (delete bolita)) bolita


-------------
--Punto 4.a--
-------------

ejecutarSentencias :: [Sentencia] -> Sentencia
ejecutarSentencias sentencias tablero = foldl (flip ($) ) tablero sentencias

repetir :: Int -> [Sentencia] -> Tablero -> Tablero
repetir cantidad sentencias = ejecutarSentencias (concat . replicate cantidad $ sentencias)

---------------
--Punto 4.b.i--
---------------

alternativa :: Condicion -> [Sentencia] -> [Sentencia] -> Sentencia
alternativa condicion sentenciasSi sentenciasNo tablero
  | condicion tablero = ejecutarSentencias sentenciasSi tablero
  | otherwise         = ejecutarSentencias sentenciasNo tablero


----------------
--Punto 4.b.ii--
----------------

si :: Condicion -> [Sentencia] -> Sentencia
si condicion tablero = alternativa condicion tablero []

-----------------
--Punto 4.b.iii--
-----------------

sino :: Condicion -> [Sentencia] -> Sentencia
sino condicion = si (not . condicion)

-------------
--Punto 4.c--
-------------

mientras :: Condicion -> [Sentencia] -> Sentencia
mientras condicion sentencias tablero
  | condicion tablero = mientras condicion sentencias (ejecutarSentencias sentencias tablero)
  | otherwise         = tablero


-------------
--Punto 4.d--
-------------

irAlBorde :: Direccion -> Sentencia
irAlBorde direccion = mientras (puedeMoverse direccion) [mover direccion]


-------------
--Punto 5.a--
-------------

puedeMoverse :: Direccion -> Tablero -> Bool
puedeMoverse unaDireccion tablero = betweenDupla (1, 1) (tamaño tablero) . cabezal . moverCabezal unaDireccion $ tablero

-------------
--Punto 5.b--
-------------

celdaActual :: Tablero -> Celda
celdaActual tablero = head . filter (esEstaCelda (cabezal tablero)) $ celdas tablero

hayBolita :: Bolita -> Tablero -> Bool
hayBolita bolita = elem bolita . bolitas . celdaActual

-------------
--Punto 5.c--
-------------

cantidadDeBolitas :: Bolita -> Tablero -> Int
cantidadDeBolitas bolita = length . filter (== bolita) . bolitas . celdaActual 

-----------
--Punto 6--
-----------

programa :: [Sentencia] -> Tablero -> Tablero
programa = ejecutarSentencias

-----------
--Punto 7--
-----------

program = programa [mover Norte, poner Negro, poner Negro, poner Azul, mover Norte, repetir 15 [poner Rojo, poner Azul], 
            alternativa (hayBolita Verde) [mover Este, poner Negro] [mover Sur, mover Este, poner Azul], mover Este,
            mientras ((<=9) . cantidadDeBolitas Verde) [poner Verde], poner Azul] (inicializarTablero (3,3))