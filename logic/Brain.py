from math import sqrt
from dao.MoviesDao import MoviesDao


class Brain:

    @staticmethod
    def euclidean(database, user, target):

        # FILMES EM COMUM
        common = {}

        # PERCORRE LISTA DE FILMES AVALIADOS PELO USUÁRIO
        for item in database[user]:

            # VERIFICA SE O ALVO TAMBÉM AVALIOU ESTE FILME
            if item in database[target]:

                # IDENTIFICA QUE ESTE FILME É COMUM ENTRE OS DOIS
                common[item] = 1

        # SE NÃO EXISTE AVALIAÇÕES EM COMUM RETORNA
        if len(common) == 0:
            return 0

        # SOMA DA DISTANCIA
        sum_distance = sum([pow(database[user][item] - database[target][item], 2)
                            for item in database[user] if item in database[target]])

        print("DISTANCIA: " + str(sum_distance))

        # RETORNA DISTANCIA EUCLIADIANA
        return 1 / (1 + sqrt(sum_distance))

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
        return rankings[0:30]

    @staticmethod
    def recommender_content(recommender_collaborative):
        result = []

        for movie in recommender_collaborative:
            result.append(MoviesDao.load_movies_category(movie))

        return result



