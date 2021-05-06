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

puedeMoverse :: Direccion -> Tablero -> Bool
puedeMoverse unaDireccion tablero = betweenDupla (1, 1) (tamaño tablero) . cabezal . moverCabezal unaDireccion $ tablero


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

esEstaCelda :: Cabezal -> Celda -> Bool
esEstaCelda cabezal celda = posicion celda == cabezal

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
ejecutarSentencias sentencias tablero = foldr ($) tablero sentencias

repetir :: Int -> [Sentencia] -> Tablero -> Tablero
repetir cantidad sentencias = ejecutarSentencias (concat . replicate cantidad $ sentencias)

---------------
--Punto 4.b.i--
---------------

alternativa :: (Tablero -> Bool) -> [Sentencia] -> [Sentencia] -> Sentencia
alternativa condicion sentenciasSi sentenciasNo tablero
  | condicion tablero = ejecutarSentencias sentenciasSi tablero
  | otherwise         = ejecutarSentencias sentenciasNo tablero


----------------
--Punto 4.b.ii--
----------------

si :: (Tablero -> Bool) -> [Sentencia] -> Sentencia
si condicion tablero = alternativa condicion tablero []

-----------------
--Punto 4.b.iii--
-----------------

sino :: (Tablero -> Bool) -> [Sentencia] -> Sentencia
sino condicion = si (not . condicion)





