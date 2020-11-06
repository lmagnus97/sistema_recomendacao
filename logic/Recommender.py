from dao.MoviesDao import MoviesDao
from logic.Calculations import Calculations
from util.Util import Util
from db.Connection import Connection
import copy
import gc


class Recommender:

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

            '''similarity = 0
            count_sim = 0
            for movie_id in database_ratings[user_id]:
                data_user = copy.deepcopy(database_ratings[user_id])
                data_target = copy.deepcopy(database_ratings[target])
                del data_user[movie_id]

                similarity += Calculations.euclidean2(data_user, user_id, data_target)
                count_sim += 1

            if count_sim == 0:
                continue

            similarity += similarity / count_sim'''

            # LOG
            # if similarity > 0:
            # print("A SIMILARIDADE DE " + str(user_id) + " COM " + target + " É: " + str(similarity))

            # SE SIMILARIDADE FOR MENOR QUE ZERO PROSSIGA
            if similarity <= 0:
                continue

            # PERCORRE A LISTA DE FILMES AVALIADOS PELO ALVO
            for item in database_ratings[target]:
                # VERIFICA SE O FILME JÁ NÃO FOI VISTO PELO USUÁRIO
                '''if item not in database[user]:'''

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
