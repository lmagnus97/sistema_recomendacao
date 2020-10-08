from math import sqrt
from dao.MoviesDao import MoviesDao


class Brain:

    @staticmethod
    def euclidean(database, user, target):

        # FILMES EM COMUM
        common = {}

        # PERCORRE LISTA DE FILMES AVALIADOS PELO USUÁRIO
        for movie in database[user]:

            # VERIFICA SE O ALVO TAMBÉM AVALIOU ESTE FILME
            if movie in database[target]:
                # IDENTIFICA QUE ESTE FILME É COMUM ENTRE OS DOIS
                common[movie] = 1

        # SE NÃO EXISTE AVALIAÇÕES EM COMUM RETORNA
        if len(common) == 0:
            return 0

        # SOMA AS VARIÂNCIAS ENTRE AS NOTAS DO USUARIO E DO ALVO REFERENTE AO MESMO FILME ELEVADO AO QUADRADO
        sum_distance = sum([pow(database[user][item] - database[target][item], 2)
                            for item in database[user] if item in database[target]])

        # RETORNA DISTANCIA EUCLIADIANA
        return 1 / (1 + sqrt(sum_distance))

    @staticmethod
    def jaccard(item, database):

        result = {}

        for movie in database:

            if movie == item:
                continue

            similar_genres = 0
            item_genres = item["genres"]
            sum_genres = len(item["genres"])

            for genre in movie["genres"]:
                if genre in item_genres:
                    similar_genres += 1
                else:
                    sum_genres += 1

            '''print("SIMILARIDADE ITEM " + item['title'] + " COM " + movie['title'] + " é: "
                  + str(similar_genres / sum_genres))'''

            result.setdefault(movie['movieId'], 0)
            # print(movie['title'] + ": SIMILARES: " + str(similar_genres) + " SOMA: " + (str(sum_genres)))
            result[movie['movieId']] += similar_genres / sum_genres

        # GERA LISTA DE RECOMENDACAO
        rankings = [(total, item) for item, total in result.items()]

        # ORDENA LISTA
        rankings.sort()
        rankings.reverse()

        # RETORNA LISTA DE RECOMENDAÇÃO
        return rankings[0:10]

    @staticmethod
    def recommender_collaborative(database, user):
        total = {}
        sum_similarity = {}

        # PERCORRE A LISTA DE AVALIACOES
        for target in database:

            # SE USUARIO FOR ELE MESMO, PULA
            if target == user:
                continue

            # CALCULA SIMILARIDADE
            similarity = Brain.euclidean(database, user, target)

            # LOG
            if similarity > 0:
                print("A SIMILARIDADE DE " + user + " COM " + target + " É: " + str(similarity))

            # SE SIMILARIDADE FOR MENOR QUE 0 PULA
            if similarity <= 0:
                continue

            # PERCORRE A LISTA DE FILMES AVALIADOS PELO ALVO
            for item in database[target]:

                # VERIFICA SE O FILME JÁ NÃO FOI VISTO PELO USUÁRIO
                if item not in database[user]:
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
        return rankings[0:10]

    '''
    @staticmethod
    def recommender_content(database):
        result = []

        for movie in database:
            for movieFCB in MoviesDao.get_tags_movie(movie[1]):
                print("MOVIE FCB: " + str(movieFCB))
                item = MoviesDao.load_movie(movieFCB['movieId'])
                print("Item: " + str(item))
                if any(x[1] == item['movieId'] for x in database):
                    continue

                print("nessa avancou")
                if item not in result:
                    result.append(item)

        print("DATABASE:" + str(database))
        print("RESULT:" + str(result))
        return result
    '''

    @staticmethod
    def recommender_content(database):
        result = []

        for movie in database:
            for genre in MoviesDao.get_categories(movie[1]):

                item = MoviesDao.get_movie_genre(genre)
                if any(x[1] == item['movieId'] for x in database):
                    continue

                if item not in result:
                    result.append(item)

        return result
