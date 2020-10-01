from logic.Brain import Brain
from dao.MoviesDao import MoviesDao

# RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA
resultFC = Brain.recommender_collaborative(MoviesDao.load_data(), "600")

print(resultFC)

for movie in resultFC:
    print(MoviesDao.load_movie(movie[1])['title'] + ": " + str(movie[0]))

