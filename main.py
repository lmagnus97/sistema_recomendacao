from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao

# PADROES
USER_ID = '104'
FC_NUMBER = 1000
FBC_NUMBER = 2

# RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA
resultFC = Recommender.recommender_collaborative(MoviesDao.get_movies(), USER_ID, FC_NUMBER)

# EXIBE RESULTADOS DA FILTRAGEM COLABORATIVA
print("\n-------------------- INICIO FILTRAGEM COLABORATIVA ----------------------")
print()

for movie in resultFC:
    print(MoviesDao.get_movie(movie[1])['title'] + ": " + str(movie[0]))

print()
print("-------------------- FIM FILTRAGEM COLABORATIVA ----------------------\n")

# RETORNA A LISTA DE RECOMENDAÇÃO BASEADA EM CONTEÚDO (METODO DE ACRESCIMO DE CARACTERISTICAS)
print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")

# CARREGA AVALIACOES JÁ REALIZADAS PELO USUÁRIO
data_ratings = MoviesDao.get_user_ratings(USER_ID)

# REALIZA RECOMENDAÇÃO BASEADA EM CONTEÚDO A PARTIR DA FILTRAGEM COLABORATIVA
resultFBC = Recommender.recommender_content(resultFC, data_ratings, FBC_NUMBER)

for movie in resultFBC:
    print(MoviesDao.get_movie(movie[1])['title'] + ": " + str(movie[0]))

print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")


