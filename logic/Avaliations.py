import math


class Avalations:

    @staticmethod
    def RMSE(database_movies, database_recommender, user_id):
        sum_dif = 0
        count = 0
        rmse = -1

        for movie in database_recommender:

            if movie[1] in database_movies[user_id]:
                sum_dif += pow(database_movies[user_id][movie[1]] - movie[0], 2)
                count += 1

        if count > 0:
            rmse = math.sqrt(sum_dif / count)
            print(str(user_id) + " -> RMSE: " + str(rmse))

        return rmse

    @staticmethod
    def MAE(database_movies, database_recommender, user_id):
        sum_dif = 0
        count = 0
        mae = 0

        for movie in database_recommender:

            if movie[1] in database_movies[user_id]:
                sum_dif += abs(database_movies[user_id][movie[1]] - movie[0])
                count += 1

        if count > 0:
            mae = sum_dif / count
            print(str(user_id) + " -> RMSE: " + str(mae))

        return mae

    @staticmethod
    def MSE(database_movies, database_recommender, user_id):
        sum_dif = 0
        count = 0
        mse = -1

        for movie in database_recommender:

            if movie[1] in database_movies[user_id]:
                sum_dif += pow(database_movies[user_id][movie[1]] - movie[0], 2)
                count += 1

        if count > 0:
            mse = sum_dif / count
            print(str(user_id) + " -> MSE: " + str(mse))

        return mse
