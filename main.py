from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao
from logic.Avaliations import Avalations
import math

# PADROES
USER_ID = '104'
FC_NUMBER = 5000
FBC_NUMBER = 2

# RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA
database = MoviesDao.get_movies()
resultFC = Recommender.recommender_collaborative(database, USER_ID, FC_NUMBER)

# EXIBE RESULTADOS DA FILTRAGEM COLABORATIVA
print("\n-------------------- INICIO FILTRAGEM COLABORATIVA ----------------------")
print()

sum_rmse = 0
count_rmse = 0

sum_mae = 0
count_mae = 0

sum_mse = 0
count_mse = 0

for x in range(1, 300):
    sum_rmse += Avalations.RMSE(database, resultFC, str(x))
    count_rmse += 1

    sum_mae += Avalations.MAE(database, resultFC, str(x))
    count_mae += 1

    sum_mse += Avalations.MSE(database, resultFC, str(x))
    count_mse += 1

print("A MÉDIA RMSE É: " + str(sum_rmse/count_rmse))
print("A MÉDIA MAE É: " + str(sum_mae/count_mae))
print("A MÉDIA MSE É: " + str(sum_mse / count_mse))

'''for movie in resultFC:
    dataMovie = MoviesDao.get_movie(movie[1])

    if movie[1] in database[USER_ID]:
        print(dataMovie['title'] + " |||| " + str(database[USER_ID][movie[1]]) + " =====> " + str(movie[0]))

    print("|" + str(movie[1]) + "|" + " --- " + dataMovie['title'] + ": " + str(movie[0]))'''

print()
print("-------------------- FIM FILTRAGEM COLABORATIVA ----------------------\n")

# RETORNA A LISTA DE RECOMENDAÇÃO BASEADA EM CONTEÚDO (METODO DE ACRESCIMO DE CARACTERISTICAS)
'''print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")

# CARREGA AVALIACOES JÁ REALIZADAS PELO USUÁRIO
data_ratings = MoviesDao.get_user_ratings(USER_ID)

# REALIZA RECOMENDAÇÃO BASEADA EM CONTEÚDO A PARTIR DA FILTRAGEM COLABORATIVA
resultFBC = Recommender.recommender_content(resultFC, data_ratings, FBC_NUMBER)

for movie in resultFBC:
    print(MoviesDao.get_movie(movie[1])['title'] + ": " + str(movie[0]))

print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")'''
