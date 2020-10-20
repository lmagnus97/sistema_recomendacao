from dao.MoviesDao import MoviesDao
from logic.Calculations import Calculations


class Recommender:

    @staticmethod
    def recommender_collaborative(database, user, fc_number):
        total = {}
        sum_similarity = {}

        # PERCORRE A LISTA DE AVALIACOES
        for target in database:

            # SE USUARIO FOR ELE MESMO, PULA
            if target == user:
                continue

            # CALCULA SIMILARIDADE
            similarity = Calculations.euclidean(database, user, target)

            # LOG
            if similarity > 0:
                '''print("A SIMILARIDADE DE " + user + " COM " + target + " É: " + str(similarity))'''

            # SE SIMILARIDADE FOR MENOR QUE 0 PULA
            if similarity <= 0:
                continue

            # PERCORRE A LISTA DE FILMES AVALIADOS PELO ALVO
            for item in database[target]:

                # VERIFICA SE O FILME JÁ NÃO FOI VISTO PELO USUÁRIO
                '''if item not in database[user]:'''
                # CALCULA O TOTAL
                total.setdefault(item, 0)
                total[item] += database[target][item] * similarity

                # CALCULA A SOMA DA SIMILARIDADE
                sum_similarity.setdefault(item, 0)
                sum_similarity[item] += similarity

        # GERA LISTA DE RECOMENDACAO
        rankings = [(total / sum_similarity[item], item) for item, total in total.items()]

        # ORDENA LISTA
        rankings.sort()
        rankings.reverse()

        # RETORNA LISTA DE RECOMENDAÇÃO
        return rankings[0:fc_number]

    @staticmethod
    def recommender_content(database, data_ratings, fbc_number):

        total = {}
        print("O TAMHNO DA LISTA É: " + str(len(database)))
        for movie in database:
            # CARREGA DADOS DO FILME
            data_movie = MoviesDao.get_movie(movie[1])

            # CARREGA LISTA DOS FILMES QUE CONTENHAM AO MENOS UMA CATEGORIA IGUAL AO FILME EM QUESTÃO
            data_movies = MoviesDao.get_all_movies_per_genre(data_movie['genres'])

            # REALIZA CALCULO DA SIMILARIDADE
            data_similar = Calculations.jaccard(data_movie, data_movies, data_ratings, fbc_number)

            # print(data_movie['title'] + ": " + str(movie[0]))

            # CALCULA POSSIVEL NOTA
            for item in data_similar:

                if item[1] in total:
                    continue

                new_rating = float(movie[0]) * float(item[0])
                # result_movie = MoviesDao.get_movie(item[1])

                total.setdefault(item[1], 0)
                total[item[1]] += new_rating

                # print("=============> " + result_movie['title'] + ": " + str(new_rating))

            # print()

        rankings = [(total, item) for item, total in total.items()]
        return rankings
