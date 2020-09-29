from math import sqrt


class Brain:

    @staticmethod
    def euclidean(database, user, target):
        si = {}
        for item in database[user]:
            if item in database[target]:
                si[item] = 1

        if len(si) == 0:
            return 0

        sum_distance = sum([pow(database[user][item] - database[target][item], 2)
                            for item in database[user] if item in database[target]])
        return 1 / (1 + sqrt(sum_distance))

    @staticmethod
    def recommender_user(database, user):
        total = {}
        sum_similarity = {}
        for target in database:

            # SE USUARIO FOR ELE MESMO PULA
            if target == user:
                continue

            # CALCULA SIMILARIDADE
            similarity = Brain.euclidean(database, user, target)

            # SE SIMILARIDADE FOR MENOR QUE 0 PULA
            if similarity <= 0:
                continue

            for data in database[target]:
                if data not in database[user]:
                    total.setdefault(data, 0)
                    total[data] += database[target][data] * similarity
                    sum_similarity.setdefault(data, 0)
                    sum_similarity[data] += similarity

        # GERA LISTA DE RECOMENDACAO
        rankings = [(total / sum_similarity[item], item) for item, total in total.items()]

        # ORDENA LISTA
        rankings.sort()
        rankings.reverse()

        # RETORNA LISTA DE RECOMENDAÇÃO
        return rankings[0:30]
