import math
from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao


class Avalations:

    @staticmethod
    def realize_avaliation(database_movies, FC_NUMBER, is_hybrid):

        # HIBRIDO
        sum_hyb_rmse_total = 0
        sum_hyb_mae_total = 0
        sum_hyb_mse_total = 0
        count_hyb_avaliation = 0

        # FC
        sum_fc_rmse_total = 0
        sum_fc_mae_total= 0
        sum_fc_mse_total = 0
        count_fc_avaliation = 0

        for user_id in range(1, 10):
            print(str(user_id))
            resultFC = Recommender.recommender_collaborative(database_movies, str(user_id), FC_NUMBER)
            resultHybrid = resultFC[0:1000]
            resultFCFinal = resultFC[0:1000]

            print("TAM DA LISTA RESULTFC é: " + str(len(resultHybrid)))
            data_ratings = MoviesDao.get_user_ratings(str(user_id))
            resultFBC = Recommender.recommender_content(resultHybrid, data_ratings, 2)

            resultHybrid.extend(resultFBC)
            print("TAM HÍBRIDO: " + str(len(resultHybrid)))
            print("HÍBRIDO: " + str(resultHybrid))

            for item in resultHybrid:
                if item not in resultFCFinal:
                    dataInFC = [aux for aux in resultFC if aux[1] == item[1]]
                    print(str(dataInFC))
                    try:
                        resultFCFinal.append(dataInFC[0])
                    except:
                        print("DEU UM ERRO")

            print("RESULTFC FINAL TAM: " + str(len(resultFCFinal)))

            # HIBRIDO
            sum_hyb_dif_rsme = 0
            sum_hyb_mae = 0
            sum_hyb_mse = 0
            count_hyb = 0

            # FIILTRAGEM COLABORATIVA
            sum_fc_dif_rsme = 0
            sum_fc_mae = 0
            sum_fc_mse = 0
            count_fc = 0

            # CALCULA ABORDAGEM HIBRIDA
            for movie in resultHybrid:
                if movie[1] in database_movies[str(user_id)]:
                    # RMSE
                    sum_hyb_dif_rsme += pow(database_movies[str(user_id)][movie[1]] - movie[0], 2)
                    print("sum_hyb_dif_rsme: " + str(sum_hyb_dif_rsme))

                    # MAE
                    sum_hyb_mae += abs(database_movies[str(user_id)][movie[1]] - movie[0])

                    # MSE
                    sum_hyb_mse += pow(database_movies[str(user_id)][movie[1]] - movie[0], 2)

                    # COUNT
                    count_hyb += 1

            # CALCULA ABORDAGEM FC
            for movie in resultFCFinal:
                # print("FILME PRE: " + str(movie))
                # print("FILME: " + str(movie[0][1]))
                # print("DATA: " + str(database_movies[str(user_id)]))
                if movie[1] in database_movies[str(user_id)]:
                    # RMSE
                    sum_fc_dif_rsme += pow(database_movies[str(user_id)][movie[1]] - movie[0], 2)

                    # MAE
                    sum_fc_mae += abs(database_movies[str(user_id)][movie[1]] - movie[0])

                    # MSE
                    sum_fc_mse += pow(database_movies[str(user_id)][movie[1]] - movie[0], 2)

                    # COUNT
                    count_fc += 1

            # SOMA ABORDAGEM HIBRIDA
            if count_hyb > 0:
                sum_hyb_rmse_total += math.sqrt(sum_hyb_dif_rsme / count_hyb)
                sum_hyb_mae_total += (sum_hyb_mae / count_hyb)
                sum_hyb_mse_total += (sum_hyb_mse / count_hyb)
                count_hyb_avaliation += 1

            # SOMA ABORDAGEM FC
            if count_fc > 0:
                sum_fc_rmse_total += math.sqrt(sum_fc_dif_rsme / count_fc)
                sum_fc_mae_total += (sum_fc_mae / count_fc)
                sum_fc_mse_total += (sum_fc_mse / count_fc)
                count_fc_avaliation += 1

        print("RESULTADOS HIBRIDO")
        print(
            "A MÉDIA RMSE É: " + str(sum_hyb_rmse_total / count_hyb_avaliation) + "   USUARIOS: " + str(count_hyb_avaliation))
        print("A MÉDIA MAE É: " + str(sum_hyb_mae_total / count_hyb_avaliation) + "   USUARIOS: " + str(count_hyb_avaliation))
        print("A MÉDIA MSE É: " + str(sum_hyb_mse_total / count_hyb_avaliation) + "   USUARIOS: " + str(count_hyb_avaliation))
        print()

        print("RESULTADOS FILTRAGEM COLABORATIVA")
        print("A MÉDIA RMSE É: " + str(sum_fc_rmse_total / count_fc_avaliation) + "   USUARIOS: " + str(count_fc_avaliation))
        print("A MÉDIA MAE É: " + str(sum_fc_mae_total / count_fc_avaliation) + "   USUARIOS: " + str(count_fc_avaliation))
        print("A MÉDIA MSE É: " + str(sum_fc_mse_total / count_fc_avaliation) + "   USUARIOS: " + str(count_fc_avaliation))
        print()
