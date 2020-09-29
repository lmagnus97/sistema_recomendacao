from db.Connection import Connection
from datetime import datetime
from util.Util import Util


class MoviesDao:

    @staticmethod
    def load_data():
        col_ratings = Connection.db()["ratings"]
        col_movies = Connection.db()["movies"]

        base_movies = {}
        for data in col_movies.find():
            base_movies[data['movieId']] = data['title']

        base_ratings = {}
        for data in col_ratings.find():
            if not Util.is_context_dayweek(datetime.fromtimestamp(float(data['timestamp'])).weekday()):
                continue

            base_ratings.setdefault(data['userId'], {})
            base_ratings[data['userId']][base_movies[data['movieId']]] = float(data['rating'])

        return base_ratings
