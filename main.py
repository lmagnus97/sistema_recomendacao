from logic.Brain import Brain
from dao.MoviesDao import MoviesDao

# RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA
resultFC = Brain.recommender_collaborative(MoviesDao.load_data(), "5")
# print(resultFC)

# EXIBE RESULTADOS DA FILTRAGEM COLABORATIVA
print("\n-------------------- INICIO FILTRAGEM COLABORATIVA ----------------------")

for movie in resultFC:
    print(MoviesDao.load_movie(movie[1])['title'] + ": " + str(movie[0]))

print("-------------------- FIM FILTRAGEM COLABORATIVA ----------------------\n")


# RETORNA A LISTA DE RECOMENDAÇÃO BASEADA EM CONTEÚDO (METODO DE ACRESCIMO DE CARACTERISTICAS)
print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")

resultHybrid = Brain.recommender_content(resultFC)
for movie in resultHybrid:
    print(movie['title'])

print("\n-------------------- INICIO FILTRAGEM BASEADA EM CONTEÚDO ----------------------\n")
