import math
from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao


class Avalations:

    @staticmethod
    def realize_avaliation(database_ratings, fc_number):

        # HIBRIDO
        sum_hyb_rmse_total = 0
        sum_hyb_mae_total = 0
        sum_hyb_mse_total = 0
        count_hyb_avaliation = 0

        # FC
        sum_fc_rmse_total = 0
        sum_fc_mae_total = 0
        sum_fc_mse_total = 0
        count_fc_avaliation = 0

        # FBC
        sum_fbc_rmse_total = 0
        sum_fbc_mae_total = 0
        sum_fbc_mse_total = 0
        count_fbc_avaliation = 0

        for user_id in range(2, 3):

            # GERA A RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA PARA O USUARIO EM QUESTÃO
            result_fc = Recommender.recommender_collaborative(database_ratings, str(user_id), fc_number)

            # GERA LISTA DE RECOMENDAÇÃO HIBRIDA
            result_hybrid = result_fc[0:fc_number]

            # GERA LISTA DE RECOMENDAÇÃO FC LIMITADA A QUANTIDADE DE RECOMENDAÇÕES
            result_fc_analyze = result_fc[0:fc_number]

            print("TAM DA LISTA RESULTFC é: " + str(len(result_hybrid)))

            # RECUPERA AS AVALIAÇÕES DO USUÁRIO EM QUESTÃO
            data_ratings = MoviesDao.get_user_ratings(str(user_id))

            # GERA A RECOMENDAÇÃO POR MEIO DA FILTRAGEM BASEADA EM CONTEÚDO
            result_fbc = Recommender.recommender_content(result_hybrid, data_ratings, 5)
            result_fbc_analyze = result_fbc[0:2]
            print("TAM FBC: " + str(len(result_fbc)))

            # JUNTA OS RESULTADOS DA FC E FBC
            result_hybrid.extend(result_fbc)

            print("TAM HÍBRIDO: " + str(len(result_hybrid)))

            # PERCORRE OS FILMES RECOMENDADOS DE FORMA HÍBRIDA PARA INSERIR OS FALTANTES A FC
            for item in result_hybrid:

                # VERIFICA SE O ITEM NA LISTA HÍBRIDA ESTÁ NOS RESULTADOS DA FC
                if item not in result_fc_analyze:

                    # RECUPERA A AVALIAÇÃO GERADA PELA RECOMENDAÇÃO FC
                    data_in_fc = [aux for aux in result_fc if aux[1] == item[1]]

                    # ATUALIZA A LISTA DA RECOMENDAÇÃO FC ADICIONANDO O ITEM FALTANTE PARA ANALISE
                    if len(data_in_fc) > 0:
                        result_fc_analyze.append(data_in_fc[0])

            # PERCORRE OS FILMES RECOMENDADOS DE FORMA HÍBRIDA PARA INSERIR OS FALTANTES A FBC
            for item in result_hybrid:

                # VERIFICA SE O ITEM NA LISTA HÍBRIDA ESTÁ NOS RESULTADOS DA FC
                if item not in result_fc_analyze:

                    # RECUPERA A AVALIAÇÃO GERADA PELA RECOMENDAÇÃO FC
                    data_in_fc = [aux for aux in result_fc if aux[1] == item[1]]

                    # ATUALIZA A LISTA DA RECOMENDAÇÃO FC ADICIONANDO O ITEM FALTANTE PARA ANALISE
                    if len(data_in_fc) > 0:
                        result_fc_analyze.append(data_in_fc[0])

            print("RESULTFC FINAL TAM: " + str(len(result_fc_analyze)))

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

            # FIILTRAGEM BASEADA EM CONTEUDO
            sum_fbc_dif_rsme = 0
            sum_fbc_mae = 0
            sum_fbc_mse = 0
            count_fbc = 0

            # CALCULA ABORDAGEM HIBRIDA
            for movie in result_hybrid:
                if movie[1] in database_ratings[str(user_id)]:
                    # RMSE
                    sum_hyb_dif_rsme += pow(database_ratings[str(user_id)][movie[1]] - movie[0], 2)

                    # MAE
                    sum_hyb_mae += abs(database_ratings[str(user_id)][movie[1]] - movie[0])

                    # MSE
                    sum_hyb_mse += pow(database_ratings[str(user_id)][movie[1]] - movie[0], 2)

                    # COUNT
                    count_hyb += 1

            # CALCULA ABORDAGEM FBC
            '''for movie in result_fbc_analyze:
                if movie[1] in database_ratings[str(user_id)]:
                    # RMSE
                    sum_hyb_dif_rsme += pow(database_ratings[str(user_id)][movie[1]] - movie[0], 2)

                    # MAE
                    sum_hyb_mae += abs(database_ratings[str(user_id)][movie[1]] - movie[0])

                    # MSE
                    sum_hyb_mse += pow(database_ratings[str(user_id)][movie[1]] - movie[0], 2)

                    # COUNT
                    count_hyb += 1'''

            # CALCULA ABORDAGEM FC
            for movie in result_fc_analyze:

                # print("FILME PRE: " + str(movie))
                # print("FILME: " + str(movie[0][1]))
                # print("DATA: " + str(database_movies[str(user_id)]))
                if movie[1] in database_ratings[str(user_id)]:
                    # RMSE
                    sum_fc_dif_rsme += pow(database_ratings[str(user_id)][movie[1]] - movie[0], 2)

                    # MAE
                    sum_fc_mae += abs(database_ratings[str(user_id)][movie[1]] - movie[0])

                    # MSE
                    sum_fc_mse += pow(database_ratings[str(user_id)][movie[1]] - movie[0], 2)

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
            "A MÉDIA RMSE É: " + str(sum_hyb_rmse_total / count_hyb_avaliation) + "   USUARIOS: " + str(
                count_hyb_avaliation))
        print("A MÉDIA MAE É: " + str(sum_hyb_mae_total / count_hyb_avaliation) + "   USUARIOS: " + str(
            count_hyb_avaliation))
        print("A MÉDIA MSE É: " + str(sum_hyb_mse_total / count_hyb_avaliation) + "   USUARIOS: " + str(
            count_hyb_avaliation))
        print()

        print("RESULTADOS FILTRAGEM COLABORATIVA")
        print("A MÉDIA RMSE É: " + str(sum_fc_rmse_total / count_fc_avaliation) + "   USUARIOS: " + str(
            count_fc_avaliation))
        print("A MÉDIA MAE É: " + str(sum_fc_mae_total / count_fc_avaliation) + "   USUARIOS: " + str(
            count_fc_avaliation))
        print("A MÉDIA MSE É: " + str(sum_fc_mse_total / count_fc_avaliation) + "   USUARIOS: " + str(
            count_fc_avaliation))
        print()
