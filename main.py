from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao

# PADROES
USER_ID = '104'
FC_NUMBER = 10
FBC_NUMBER = 2

# RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA
database_ratings = MoviesDao.get_movies(False)
result = Recommender.recommender_collaborative(database_ratings, USER_ID, FC_NUMBER)

data_movies = list(MoviesDao.get_all_movies())
resultFBC = Recommender.recommender_content(result, MoviesDao.get_user_ratings(str(USER_ID)), FBC_NUMBER, data_movies)
result.extend(resultFBC)

for movie in result:
    dataMovie = MoviesDao.get_movie(movie[1])

    if movie[1] in database_ratings[USER_ID]:
        print(dataMovie['title'] + " |||| " + str(database_ratings[USER_ID][movie[1]]) + " =====> " + str(movie[0]))

    print("|" + str(movie[1]) + "|" + " --- " + dataMovie['title'] + ": " + str(movie[0]))

