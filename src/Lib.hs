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
  tamaño  :: Tamaño,
  tablero :: [Celda],
  cabezal :: Cabezal
} deriving(Show)


