from dao.MoviesDao import MoviesDao
from logic.Calculations import Calculations
from util.Config import Config
import random


class Recommender:

    @staticmethod
    def init(user_id):

        # RETORNA LISTA DE RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA
        database_ratings = MoviesDao.get_movies(False)
        data_movies = list(MoviesDao.get_all_movies())

        if user_id not in database_ratings:
            result = Recommender.recommender_init_random(data_movies)
        else:
            result = Recommender.recommender_collaborative(database_ratings, user_id, Config.fc_number)

        resultFBC = Recommender.recommender_content(result, MoviesDao.get_user_ratings(str(user_id)), Config.fbc_number,
                                                    data_movies)
        result.extend(resultFBC)

        recommendation = []
        for movie in result:
            data = MoviesDao.get_movie_link(movie[1])
            recommendation.append({
                'id': movie[1],
                'tmdb': data['tmdbId'],
                'imdb': data['imdbId'],
                'rating': movie[0]
            })

        return recommendation

    @staticmethod
    def recommender_collaborative(database_ratings, user_id, fc_number=None):
        total = {}
        sum_similarity = {}

        # PERCORRE A LISTA DE AVALIACOES
        for target in database_ratings:

            # SE USUARIO FOR ELE MESMO, PULA
            if target == user_id:
                continue

            # CALCULA SIMILARIDADE
            similarity = Calculations.euclidean(database_ratings, user_id, target)

            # LOG
            # if similarity > 0:
            # print("A SIMILARIDADE DE " + str(user_id) + " COM " + target + " É: " + str(similarity))

            # SE SIMILARIDADE FOR MENOR QUE ZERO PROSSIGA
            if similarity <= 0:
                continue

            # PERCORRE A LISTA DE FILMES AVALIADOS PELO ALVO
            for item in database_ratings[target]:
                # VERIFICA SE O FILME JÁ NÃO FOI VISTO PELO USUÁRIO
                if item not in database_ratings[user_id]:
                    # CALCULA O TOTAL
                    total.setdefault(item, 0)
                    total[item] += database_ratings[target][item] * similarity

                    # CALCULA A SOMA DA SIMILARIDADE
                    sum_similarity.setdefault(item, 0)
                    sum_similarity[item] += similarity

        # PEGA BASE DE FILMES
        base_movies = MoviesDao.get_all_movies_genres()

        # GERA LISTA DE RECOMENDACAO
        rankings = [(total / sum_similarity[item], item, base_movies[item][0], base_movies[item][1]) for item, total in
                    total.items()]

        # ORDENA LISTA
        rankings.sort()
        rankings.reverse()

        # RETORNA LISTA DE RECOMENDAÇÃO
        if fc_number is None:
            return rankings
        else:
            return rankings[0:fc_number]

    @staticmethod
    def recommender_content(database_result, user_ratings, fbc_number, data_movies):

        total = {}

        for movie in database_result:
            # REALIZA CALCULO DA SIMILARIDADE
            data_similar = Calculations.jaccard(movie, data_movies, user_ratings, fbc_number)

            # CALCULA POSSIVEL NOTA
            for item in data_similar:

                if item[1] in total:
                    continue

                new_rating = float(movie[0]) * float(item[0])

                total.setdefault(item[1], 0)
                total[item[1]] += new_rating

        rankings = [(total, item) for item, total in total.items()]
        return rankings

    @staticmethod
    def recommender_init_random(database_movies):
        # RANDOM LIST
        list_random = random.sample(database_movies, 15)

        # PEGA BASE DE FILMES
        base_movies = MoviesDao.get_all_movies_genres()

        rankings = []

        for movie in list_random:
            rankings.append((1.0, movie['movieId'], base_movies[movie['movieId']][0], base_movies[movie['movieId']][1]))

        return rankings
