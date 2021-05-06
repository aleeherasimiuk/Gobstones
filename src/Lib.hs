module Gobstones where
----------
--Punto 1-
----------

data Bolita = Rojo | Azul | Verde | Negro deriving(Show)
data Direccion = Norte | Sur | Este | Oeste

type Cabezal = (Int, Int) 
type Tamaño  = (Int, Int)

data Celda = Celda{
  posicion :: (Int, Int),
  bolitas  :: [Bolita]
} deriving(Show)

data Tablero = Tablero{
  tablero :: [Celda],
  tamaño  :: Tamaño,
  cabezal :: Cabezal
} deriving(Show)

inicializarTablero :: Tamaño -> Tablero
inicializarTablero (filas, columnas) = Tablero [Celda (x, y) [] | x <-[1 .. filas], y <- [1 .. columnas]] (filas, columnas) (1, 1)




