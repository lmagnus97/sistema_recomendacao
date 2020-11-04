import math
from logic.Recommender import Recommender
from dao.MoviesDao import MoviesDao
from model.Result import Result
from util.Util import Util


class Avaliations:

    def calculate_result(self, database_ratings, user_id, database_movies, log=None):

        # RESULTADO GERAL
        sum_rsme = 0
        sum_mae = 0
        sum_mse = 0
        count = 0

        # PERCORRE AS RECOMENDAÇÕES GERADAS
        for movie in database_movies:

            # VERIFICA SE A RECOMENDAÇÃO GERADA JÁ FOI AVALIADA PELO USUÁRIO
            if movie[1] in database_ratings[str(user_id)]:
                # CALCULA DIFERENÇA
                dif = database_ratings[str(user_id)][movie[1]] - movie[0]

                # LOG DA DIFERENÇA ENTRE AVALIAÇÃO REAL E A GERADA
                '''if log is not None:
                    print(log + ": " + str(database_ratings[str(user_id)][movie[1]]) + " - " + str(
                        movie[0]) + " -> " + str(dif))'''
                Util.write_result("relatorio_50",
                                  str(user_id) + ";" + str(database_ratings[str(user_id)][movie[1]]) + ";" + str(
                                      movie[0]) + ";" + str(dif))

                # RESULTADOS
                sum_rsme += pow(dif, 2)
                sum_mae += abs(dif)
                sum_mse += pow(dif, 2)

                # COUNT
                count += 1

        # RETORNA RESULTADO
        return Result(sum_rsme, sum_mae, sum_mse, count)

    def toString(self, avaliation, type):

        print("RESULTADOS PARA: " + type)

        txt_RMSE = "A MÉDIA RMSE É: " + str(avaliation.rmse / avaliation.count) + "   USUARIOS: " + str(
            avaliation.count)
        txt_MAE = "A MÉDIA MAE É: " + str(avaliation.mae / avaliation.count) + "   USUARIOS: " + str(avaliation.count)
        txt_MSE = "A MÉDIA MSE É: " + str(avaliation.mse / avaliation.count) + "   USUARIOS: " + str(avaliation.count)
        print(txt_RMSE)
        print(txt_MAE)
        print(txt_MSE)
        print()

        # Util.write_result("RESULTADOS PARA: " + type + "\n" + txt_RMSE + "\n" + txt_MAE + "\n" + txt_MSE)

    def incrementFC(self, result_hybrid, result_fc, fc_number):

        result = result_fc[0:fc_number]
        for item in result_hybrid:

            # VERIFICA SE O ITEM NA LISTA HÍBRIDA ESTÁ NOS RESULTADOS DA FC
            if not any(x[1] == item[1] for x in result):

                # RECUPERA A AVALIAÇÃO GERADA PELA RECOMENDAÇÃO FC
                data_in_fc = [aux for aux in result_fc if aux[1] == item[1]]

                # ATUALIZA A LISTA DA RECOMENDAÇÃO FC ADICIONANDO O ITEM FALTANTE PARA ANALISE
                if len(data_in_fc) > 0:
                    result.append(data_in_fc[0])

        return result

    def realize_avaliation(self, fc_number, fbc_number, with_context=False):

        Util.write_result("relatorio_50", "user;avaliacao_real;avaliacao_gerada;diferenca")

        # CARREGA BASE DE AVALIAÇÕES
        if with_context:
            database_ratings = MoviesDao.get_movies(True)
        else:
            database_ratings = MoviesDao.get_movies(False)

        # INICIALIZA AS VARIAVEIS DOS RESULTADOS
        result_total_hyb = Result(0, 0, 0, 0)
        result_total_fc = Result(0, 0, 0, 0)
        result_total_fbc = Result(0, 0, 0, 0)

        # PERCORRE CADA USUÁRIOS PARA CALCULAR OS MÉTODOS AVALIATIVOS
        for user_id in range(1, 51):
            print("AVALIANDO USUARIO: " + str(user_id))
            # GERA A RECOMENDAÇÃO POR MEIO DA FILTRAGEM COLABORATIVA PARA O USUARIO EM QUESTÃO
            result_fc = Recommender.recommender_collaborative(database_ratings, str(user_id))

            # INICIA A LISTA DE RECOMENDAÇÃO HIBRIDA
            result_hybrid = result_fc[0:fc_number]

            # RECUPERA AS AVALIAÇÕES REAIS DO USUÁRIO
            data_ratings = MoviesDao.get_user_ratings(str(user_id))

            # GERA A RECOMENDAÇÃO POR MEIO DA FILTRAGEM BASEADA EM CONTEÚDO
            data_movies = list(MoviesDao.get_all_movies())
            result_fbc = Recommender.recommender_content(result_hybrid, data_ratings, fbc_number, data_movies)

            # JUNTA OS RESULTADOS DA FC E FBC
            result_hybrid.extend(result_fbc)

            # DEFINE A LISTA DE RECOMENDAÇÃO FC LIMITADA A QUANTIDADE DE RECOMENDAÇÕES
            result_fc_analyze = self.incrementFC(result_hybrid, result_fc, fc_number)

            # CALCULA AS MÉTRICAS AVALIATIVAS PARA CADA MODELO
            avaliation_hybrid = self.calculate_result(database_ratings, user_id, result_hybrid, "HÍBRIDO")
            avaliation_fbc = self.calculate_result(database_ratings, user_id, result_fbc, "FBC")
            avaliation_fc = self.calculate_result(database_ratings, user_id, result_fc_analyze, "FC")

            # REALIZA A SOMA GERAL DAS MÉTRICAS
            result_total_hyb.increment(avaliation_hybrid)
            result_total_fc.increment(avaliation_fc)
            result_total_fbc.increment(avaliation_fbc)

        # APRESENTA OS RESULTADOS
        self.toString(result_total_hyb, "RSME")
        self.toString(result_total_fc, "FC")
        self.toString(result_total_fbc, "FBC")
