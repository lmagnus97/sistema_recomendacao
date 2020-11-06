from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao
from logic.Avaliations import Avaliations
from util.Util import Util
import math

# PADROES
USER_ID = '104'
FC_NUMBER = 5000
FBC_NUMBER = 1

# RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA

'''print("SEM CONTEXTO")
database = MoviesDao.get_movies(False)
Avalations.realize_avaliation(database, FC_NUMBER, False)'''

print("COM CONTEXTO")
database_ratings = MoviesDao.get_movies(False)
# Avalations.realize_avaliation(database, FC_NUMBER, False)

# resultFC = Recommender.recommender_collaborative(database, USER_ID, FC_NUMBER)

# EXIBE RESULTADOS DA FILTRAGEM COLABORATIVA
print("\n-------------------- INICIO FILTRAGEM COLABORATIVA ----------------------")
print()

'''for movie in resultFC:
    dataMovie = MoviesDao.get_movie(movie[1])

    if movie[1] in database[USER_ID]:
        print(dataMovie['title'] + " |||| " + str(database[USER_ID][movie[1]]) + " =====> " + str(movie[0]))

    print("|" + str(movie[1]) + "|" + " --- " + dataMovie['title'] + ": " + str(movie[0]))'''

print()
print("-------------------- FIM FILTRAGEM COLABORATIVA ----------------------\n")

# RETORNA A LISTA DE RECOMENDAÇÃO BASEADA EM CONTEÚDO (METODO DE ACRESCIMO DE CARACTERISTICAS)
print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")

# CARREGA AVALIACOES JÁ REALIZADAS PELO USUÁRIO
# data_ratings = MoviesDao.get_user_ratings(USER_ID)

# REALIZA RECOMENDAÇÃO BASEADA EM CONTEÚDO A PARTIR DA FILTRAGEM COLABORATIVA


'''for movie in resultFBC:
    print(MoviesDao.get_movie(movie[1])['title'] + ": " + str(movie[0]))'''

# print(str(resultFC))

avaliation = Avaliations()
print("COM CONTEXTO")
Util.write_result("relatorio_50", "COM CONTEXTO")
avaliation.realize_avaliation(FC_NUMBER, FBC_NUMBER, True)

print("SEM CONTEXTO")
Util.write_result("relatorio_50", "SEM CONTEXTO")
avaliation.realize_avaliation(FC_NUMBER, FBC_NUMBER, False)

print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")
