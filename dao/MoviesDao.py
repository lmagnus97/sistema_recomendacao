from db.Connection import Connection
from datetime import datetime
from util.Util import Util


class MoviesDao:

    @staticmethod
    def get_movies():

        # COLEÇÃO DE AVALIAÇÕES
        col_ratings = Connection.db()["ratings"]

        # COLEÇÃO DE FILMES
        col_movies = Connection.db()["movies"]

        # INICIA A BASE DE FILMES
        base_movies = {}
        for data in col_movies.find():
            base_movies[data['movieId']] = data['title']

        # INICIA A BASE DE AVALIACOES
        base_ratings = {}

        for data in col_ratings.find():

            # APLICAÇÃO DO CONTEXTO -> FILTRA AS AVALIACOES PELO CONTEXTO(SE É FIM DE SEMANA OU NÃO)
            if not Util.is_context_dayweek(datetime.fromtimestamp(float(data['timestamp'])).weekday()):
                continue

            base_ratings.setdefault(data['userId'], {})
            base_ratings[data['userId']][data['movieId']] = float(data['rating'])

        return base_ratings

    @staticmethod
    def get_movie(movie_id):

        # COLEÇÃO DE FILMES
        col_movies = Connection.db()["movies"]

        return col_movies.find_one({"movieId": movie_id})

    @staticmethod
    def get_tags_movie(movieId):
        col_tabs = Connection.db()["tags"]
        return col_tabs.find({"movieId": movieId})

    @staticmethod
    def get_categories(movieId):
        col_tabs = Connection.db()["movies"]
        return col_tabs.find_one({"movieId": movieId})["genres"]

    @staticmethod
    def get_movie_genre(genre):
        col_movies = Connection.db()["movies"]
        return col_movies.find_one({"genres": genre})

    @staticmethod
    def get_movies_links():
        col_links = Connection.db()["links"]
        return col_links.find()

    @staticmethod
    def get_all_movies():

        # COLEÇÃO DE FILMES
        col_movies = Connection.db()["movies"]

        return col_movies.find()

    @staticmethod
    def get_rating(movie_id):

        # COLEÇÃO DE FILMES
        col_movies = Connection.db()["ratings"]

        return col_movies.find_one({"movieId": movie_id})

    @staticmethod
    def get_all_movies_per_genre(genres):

        # COLEÇÃO DE FILMES
        col_movies = Connection.db()["movies"]

        return col_movies.find({"genres": {"$" "in": genres}})

    @staticmethod
    def get_user_ratings(user_id):

        # COLEÇÃO DE AVALIAÇÕES DO USUARIO
        col_movies = Connection.db()["ratings"]

        return col_movies.find({"userId": user_id})
