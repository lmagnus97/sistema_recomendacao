from math import sqrt


class Calculations:

    @staticmethod
    def euclidean(database_ratings, user_id, user_other_id):

        # FILMES EM COMUM
        common = {}

        # PERCORRE LISTA DE FILMES AVALIADOS PELO USUÁRIO
        for movie in database_ratings[user_id]:

            # VERIFICA SE O ALVO TAMBÉM AVALIOU ESTE FILME
            if movie in database_ratings[user_other_id]:
                # IDENTIFICA QUE ESTE FILME É COMUM ENTRE OS DOIS
                common[movie] = 1

        # SE NÃO EXISTE AVALIAÇÕES EM COMUM RETORNA
        if len(common) == 0:
            return 0

        # SOMA AS VARIÂNCIAS ENTRE AS NOTAS DO USUARIO E DO ALVO REFERENTE AO MESMO FILME ELEVADO AO QUADRADO
        sum_distance = sum([pow(database_ratings[user_id][item] - database_ratings[user_other_id][item], 2)
                            for item in database_ratings[user_id] if item in database_ratings[user_other_id]])

        # RETORNA DISTANCIA EUCLIADIANA
        return 1 / (1 + sqrt(sum_distance))

    @staticmethod
    def euclidean2(database_ratings, user_id, user_other_id):

        # FILMES EM COMUM
        common = {}

        # PERCORRE LISTA DE FILMES AVALIADOS PELO USUÁRIO
        for movie in database_ratings:

            # VERIFICA SE O ALVO TAMBÉM AVALIOU ESTE FILME
            if movie in user_other_id:
                # IDENTIFICA QUE ESTE FILME É COMUM ENTRE OS DOIS
                common[movie] = 1

        # SE NÃO EXISTE AVALIAÇÕES EM COMUM RETORNA
        if len(common) == 0:
            return 0

        # SOMA AS VARIÂNCIAS ENTRE AS NOTAS DO USUARIO E DO ALVO REFERENTE AO MESMO FILME ELEVADO AO QUADRADO
        sum_distance = sum([pow(database_ratings[item] - user_other_id[item], 2)
                            for item in database_ratings if item in user_other_id])

        # RETORNA DISTANCIA EUCLIADIANA
        return 1 / (1 + sqrt(sum_distance))

    @staticmethod
    def jaccard(item, data_movies, data_ratings, fbc_number):

        result = {}

        for movie in data_movies:

            # IGNORA SE O FILME PERCORRIDO É IGUAL AO FILME ALVO
            if movie['movieId'] == item[1]:
                continue

            # IGNORA SE O FILME PERCORRIDO JÁ FOI AVALIADO PELO USUÁRIO
            if any(x['movieId'] == movie['movieId'] for x in data_ratings):
                continue

            # SOMA OS GENEROS IGUAIS ENTRE O FILME PERCORRIDO E O FILEM ALVO
            similar_count = 0

            # SOMA O TOTAL DE GENEROS ENTRE OS 2 FILMES
            total_count = len(item[2])

            # PERCORRE OS GENEROS DO FILME PERCORRIDO
            for genre in movie['genres']:

                # VERIFICA SE O GENERO DO FILME PERCORRIDO É IGUAL AO DO FILME ALVO
                if genre in item[2]:
                    similar_count += 1
                else:
                    total_count += 1

            '''if str(item[3]).isnumeric() and str(movie['year']).isnumeric():

                total_count += 1
                dif_years = int(item[3]) - int(movie['year'])
                if abs(dif_years) < 10:
                    similar_count += 1'''

            # SETA O RESULTADO DA SIMILARIDADE DO FILME
            result.setdefault(movie['movieId'], 0)
            result[movie['movieId']] += similar_count / total_count

        # GERA LISTA DE RECOMENDACAO
        rankings = [(total, item) for item, total in result.items()]

        # ORDENA LISTA
        rankings.sort()
        rankings.reverse()

        # RETORNA LISTA DE RECOMENDAÇÃO
        return rankings[0:fbc_number]
