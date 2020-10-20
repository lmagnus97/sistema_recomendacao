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
            # print(str(user_id) + " -> RMSE: " + str(rmse))

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
            # print(str(user_id) + " -> MAE: " + str(mae))

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
            # print(str(user_id) + " -> MSE: " + str(mse))

        return mse

    @staticmethod
    def realize_avaliation(database_movies, database_recommender):
        sum_rmse = 0
        count_rmse = 0

        sum_mae = 0
        count_mae = 0

        sum_mse = 0
        count_mse = 0

        for user_id in range(1, 300):
            rmse = Avalations.RMSE(database_movies, database_recommender, str(user_id))
            if rmse > -1:
                sum_rmse += rmse
                count_rmse += 1

            mae = Avalations.MAE(database_movies, database_recommender, str(user_id))
            if mae > -1:
                sum_mae += mae
                count_mae += 1

            mse = Avalations.MSE(database_movies, database_recommender, str(user_id))
            if mae > -1:
                sum_mse += mse
                count_mse += 1

        print("A MÉDIA RMSE É: " + str(sum_rmse / count_rmse))
        print("A MÉDIA MAE É: " + str(sum_mae / count_mae))
        print("A MÉDIA MSE É: " + str(sum_mse / count_mse))
