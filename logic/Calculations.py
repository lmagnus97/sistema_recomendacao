from math import sqrt


class Calculations:

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
    def jaccard(item, database, data_ratings, fbc_number):

        result = {}

        for movie in database:

            # IGNORA SE O FILME PERCORRIDO É IGUAL AO FILME ALVO
            if movie['movieId'] == item['movieId']:
                continue

            # IGNORA SE O FILME PERCORRIDO JÁ FOI AVALIADO PELO USUÁRIO
            if any(x['movieId'] == movie['movieId'] for x in data_ratings):
                continue

            # SOMA OS GENEROS IGUAIS ENTRE O FILME PERCORRIDO E O FILEM ALVO
            similar_genres = 0

            # SOMA O TOTAL DE GENEROS ENTRE OS 2 FILMES
            sum_genres = len(item["genres"])

            # PERCORRE OS GENEROS DO FILME PERCORRIDO
            for genre in movie["genres"]:

                # VERIFICA SE O GENERO DO FILME PERCORRIDO É IGUAL AO DO FILME ALVO
                if genre in item["genres"]:
                    similar_genres += 1
                else:
                    sum_genres += 1

            # print("SIMILARIDADE ITEM " + item['title'] + " COM " + movie['title'] + " é: + str(similar_genres / sum_genres))

            # SETA O RESULTADO DA SIMILARIDADE DO FILME
            result.setdefault(movie['movieId'], 0)
            result[movie['movieId']] += similar_genres / sum_genres

        # GERA LISTA DE RECOMENDACAO
        rankings = [(total, item) for item, total in result.items()]

        # ORDENA LISTA
        rankings.sort()
        rankings.reverse()

        # RETORNA LISTA DE RECOMENDAÇÃO
        return rankings[0:fbc_number]
