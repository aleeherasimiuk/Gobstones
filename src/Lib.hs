module Gobstones where

----------
--Punto 1-
----------

data Bolita = Rojo | Azul | Verde | Negro deriving(Show)
data Direccion = Norte | Sur | Este | Oeste deriving(Show)

type Posicion = (Int, Int)
type Cabezal = (Int, Int)
type Tamaño  = (Int, Int)

data Celda = Celda{
  posicion :: Posicion,
  bolitas  :: [Bolita]
} deriving(Show)

data Tablero = Tablero{
  tablero :: [Celda],
  tamaño  :: Tamaño,
  cabezal :: Cabezal
} deriving(Show)

mapCabezal :: (Cabezal -> Cabezal) -> Tablero -> Tablero
mapCabezal f tablero = tablero{cabezal = f . cabezal $ tablero}


----------
--Punto 2-
----------

inicializarTablero :: Tamaño -> Tablero
inicializarTablero (filas, columnas) = Tablero [Celda (x, y) [] | x <-[1 .. filas], y <- [1 .. columnas]] (filas, columnas) (1, 1)


-------------
--Punto 3.a--
-------------

mover :: Direccion -> Tablero -> Tablero
mover direccion tablero
  | puedeMoverse direccion tablero = moverCabezal direccion tablero
  | otherwise = error "Boom"

moverCabezal :: Direccion -> Tablero -> Tablero
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


